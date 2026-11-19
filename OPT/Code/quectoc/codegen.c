#include "codegen.h"
#include <errno.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    FILE *out, *diagnostics;
    const SemanticResult *symbols;
    size_t temporary, label;
    unsigned depth;
    int status, has_print;
} Generator;
typedef struct { char operand[64]; Type type; } Value;

static int is(const AstNode *n, const char *kind) {
    return n && n->kind && strcmp(n->kind, kind) == 0;
}
static const AstNode *child(const AstNode *n, const char *role) {
    for (const AstNode *c = n ? n->first_child : NULL; c; c = c->next_sibling)
        if (c->role && strcmp(c->role, role) == 0) return c;
    return NULL;
}
static void fail(Generator *g, int status, const char *message) {
    if (!g->status && g->diagnostics) fprintf(g->diagnostics, "%s\n", message);
    if (!g->status) g->status = status;
}
static void emit(Generator *g, const char *format, ...) {
    if (g->status) return;
    va_list args; va_start(args, format);
    if (vfprintf(g->out, format, args) < 0) fail(g, 2, "CODEGEN_IO write failed");
    va_end(args);
}
static int enter(Generator *g) {
    if (g->status) return 0;
    if (g->depth >= 512) { fail(g, 2, "CODEGEN_DEPTH limit 512 exceeded"); return 0; }
    ++g->depth; return 1;
}
static uintmax_t integer(Generator *g, const AstNode *n) {
    if (!n || !n->text || n->inferred_type != TYPE_INT) {
        fail(g, 2, "CODEGEN_INTERNAL integer annotation missing"); return 0;
    }
    char *end; errno = 0;
    int base = n->text[0] == '0' && (n->text[1] == 'x' || n->text[1] == 'X') ? 16 : 10;
    uintmax_t v = strtoumax(n->text, &end, base);
    if (errno == ERANGE || v > INT32_MAX) {
        fail(g, 1, "CODEGEN_RANGE literal must be in 0..2147483647"); return 0;
    }
    if (end == n->text || *end || n->text[0] == '-' || n->text[0] == '+')
        fail(g, 2, "CODEGEN_INTERNAL invalid integer spelling");
    return v;
}
static size_t slot(Generator *g, const AstNode *declaration) {
    if (is(declaration, "Declaration") && declaration->inferred_type == TYPE_INT) {
        for (size_t i = 0; i < g->symbols->count; ++i)
            if (g->symbols->symbols[i].declaration == declaration) return declaration->id;
    }
    fail(g, 2, "CODEGEN_INTERNAL declaration binding missing"); return 0;
}
static Value temporary(Generator *g, Type type) {
    Value v = {{0}, type};
    snprintf(v.operand, sizeof v.operand, "%%t%zu", ++g->temporary); return v;
}
/* A prepass emits module-level string constants and checks literal range. */
static void globals(Generator *g, const AstNode *n) {
    if (!n || !enter(g)) return;
    if (is(n, "Integer")) (void)integer(g, n);
    if (is(n, "Print")) g->has_print = 1;
    if (is(n, "String")) {
        if (!n->text || n->inferred_type != TYPE_STRING)
            fail(g, 2, "CODEGEN_INTERNAL string annotation missing");
        else {
            emit(g, "@.str%zu = private unnamed_addr constant [%zu x i8] c\"", n->id, strlen(n->text)+1);
            for (const unsigned char *p = (const unsigned char *)n->text; *p; ++p)
                emit(g, "\\%02X", (unsigned)*p);
            emit(g, "\\00\"\n");
        }
    }
    for (const AstNode *c = n->first_child; c && !g->status; c = c->next_sibling) globals(g, c);
    --g->depth;
}
static Value expression(Generator *g, const AstNode *n) {
    Value v = {{0}, TYPE_ERROR};
    if (!enter(g)) return v;
    if (is(n, "Integer")) {
        uintmax_t value = integer(g, n); v.type = TYPE_INT;
        snprintf(v.operand, sizeof v.operand, "%" PRIuMAX, value);
    } else if (is(n, "Identifier") && n->inferred_type == TYPE_INT) {
        size_t id = slot(g, n->binding); v = temporary(g, TYPE_INT);
        emit(g, "  %s = load i32, ptr %%v%zu\n", v.operand, id);
    } else if (is(n, "String") && n->inferred_type == TYPE_STRING) {
        v.type = TYPE_STRING; snprintf(v.operand, sizeof v.operand, "@.str%zu", n->id);
    } else if (is(n, "Unary") && n->text) {
        Value a = expression(g, child(n, "operand"));
        if (a.type != TYPE_INT || n->inferred_type != TYPE_INT) fail(g, 2, "CODEGEN_INTERNAL unary type");
        if (strcmp(n->text, "+") == 0) v = a;
        else if (strcmp(n->text, "-") == 0) {
            v = temporary(g, TYPE_INT); emit(g, "  %s = sub i32 0, %s\n", v.operand, a.operand);
        } else fail(g, 2, "CODEGEN_INTERNAL unary operator");
    } else if (is(n, "Binary") && n->text) {
        Value a = expression(g, child(n, "left"));
        Value b = expression(g, child(n, "right"));
        const char *op = NULL; Type type = TYPE_INT;
        const char *source[] = {"+","-","*","/","%","==","!=","<","<=",">",">="};
        const char *llvm[] = {"add","sub","mul","sdiv","srem","icmp eq","icmp ne","icmp slt","icmp sle","icmp sgt","icmp sge"};
        for (size_t i = 0; i < sizeof source/sizeof source[0]; ++i)
            if (strcmp(n->text, source[i]) == 0) { op = llvm[i]; type = i < 5 ? TYPE_INT : TYPE_BOOL; break; }
        if (!op || a.type != TYPE_INT || b.type != TYPE_INT || n->inferred_type != type)
            fail(g, 2, "CODEGEN_INTERNAL binary operator or type");
        else { v = temporary(g, type); emit(g, "  %s = %s i32 %s, %s\n", v.operand, op, a.operand, b.operand); }
    } else fail(g, 2, "CODEGEN_INTERNAL expression kind or annotation");
    --g->depth; return v;
}
static void statement(Generator *g, const AstNode *n) {
    if (!enter(g)) return;
    if (is(n, "Program") || is(n, "Block")) {
        for (const AstNode *c = n->first_child; c && !g->status; c = c->next_sibling) statement(g, c);
    } else if (is(n, "Declaration")) {
        size_t id = slot(g, n); const AstNode *init = child(n, "initializer");
        if (init) {
            Value v = expression(g, init);
            if (v.type != TYPE_INT) fail(g, 2, "CODEGEN_INTERNAL initializer type");
            emit(g, "  store i32 %s, ptr %%v%zu\n", v.operand, id);
        }
    } else if (is(n, "Assign")) {
        const AstNode *target = child(n, "target");
        size_t id = slot(g, target ? target->binding : NULL);
        Value v = expression(g, child(n, "value"));
        if (v.type != TYPE_INT) fail(g, 2, "CODEGEN_INTERNAL assignment type");
        emit(g, "  store i32 %s, ptr %%v%zu\n", v.operand, id);
    } else if (is(n, "Print")) {
        Value v = expression(g, child(n, "value"));
        if (v.type != TYPE_INT && v.type != TYPE_STRING) fail(g, 2, "CODEGEN_INTERNAL print type");
        emit(g, "  call i32 (ptr, ...) @printf(ptr @.fmt.%s, %s %s)\n",
             v.type == TYPE_INT ? "int" : "str", v.type == TYPE_INT ? "i32" : "ptr", v.operand);
    } else if (is(n, "If")) {
        size_t label = ++g->label;
        Value v = expression(g, child(n, "condition"));
        if (v.type != TYPE_BOOL) fail(g, 2, "CODEGEN_INTERNAL condition type");
        emit(g, "  br i1 %s, label %%if.then.%zu, label %%if.else.%zu\n\nif.then.%zu:\n", v.operand, label, label, label);
        statement(g, child(n, "then"));
        emit(g, "  br label %%if.end.%zu\n\nif.else.%zu:\n", label, label);
        if (child(n, "else")) statement(g, child(n, "else"));
        emit(g, "  br label %%if.end.%zu\n\nif.end.%zu:\n", label, label);
    } else if (is(n, "While")) {
        size_t label = ++g->label;
        emit(g, "  br label %%while.cond.%zu\n\nwhile.cond.%zu:\n", label, label);
        Value v = expression(g, child(n, "condition"));
        if (v.type != TYPE_BOOL) fail(g, 2, "CODEGEN_INTERNAL condition type");
        emit(g, "  br i1 %s, label %%while.body.%zu, label %%while.end.%zu\n\nwhile.body.%zu:\n", v.operand, label, label, label);
        statement(g, child(n, "body"));
        emit(g, "  br label %%while.cond.%zu\n\nwhile.end.%zu:\n", label, label);
    } else if (is(n, "For")) {
        size_t label = ++g->label;
        statement(g, child(n, "initial"));
        emit(g, "  br label %%for.cond.%zu\n\nfor.cond.%zu:\n", label, label);
        Value v = expression(g, child(n, "condition"));
        if (v.type != TYPE_BOOL) fail(g, 2, "CODEGEN_INTERNAL condition type");
        emit(g, "  br i1 %s, label %%for.body.%zu, label %%for.end.%zu\n\nfor.body.%zu:\n", v.operand, label, label, label);
        statement(g, child(n, "body"));
        emit(g, "  br label %%for.update.%zu\n\nfor.update.%zu:\n", label, label);
        statement(g, child(n, "update"));
        emit(g, "  br label %%for.cond.%zu\n\nfor.end.%zu:\n", label, label);
    } else fail(g, 2, "CODEGEN_INTERNAL statement kind");
    --g->depth;
}
int codegen_write_llvm(FILE *out, FILE *diagnostics, const AstNode *root, const SemanticResult *symbols) {
    if (!out || !symbols || symbols->errors || !is(root, "Program")) return 2;
    FILE *staged = tmpfile();
    if (!staged) { if (diagnostics) perror("codegen tmpfile"); return 2; }
    Generator g = {.out=staged, .diagnostics=diagnostics, .symbols=symbols};
    emit(&g, "; QuectoC LLVM IR, semantic v2.0 foundation\n");
    globals(&g, root);
    if (g.has_print) emit(&g,
        "@.fmt.int = private unnamed_addr constant [4 x i8] c\"%%d\\0A\\00\"\n"
        "@.fmt.str = private unnamed_addr constant [4 x i8] c\"%%s\\0A\\00\"\n"
        "declare i32 @printf(ptr, ...)\n");
    emit(&g, "\ndefine i32 @main() {\nentry:\n");
    for (size_t i = 0; i < symbols->count && !g.status; ++i) {
        size_t id = slot(&g, symbols->symbols[i].declaration);
        emit(&g, "  %%v%zu = alloca i32\n", id);
    }
    statement(&g, root);
    emit(&g, "  ret i32 0\n}\n");
    if (!g.status && (fflush(staged) != 0 || fseek(staged, 0, SEEK_SET) != 0)) g.status = 2;
    if (!g.status) {
        char buffer[4096]; size_t n;
        while ((n = fread(buffer, 1, sizeof buffer, staged)) != 0)
            if (fwrite(buffer, 1, n, out) != n) { g.status = 2; break; }
        if (ferror(staged)) g.status = 2;
    }
    if (fclose(staged) != 0) g.status = 2;
    return g.status;
}
