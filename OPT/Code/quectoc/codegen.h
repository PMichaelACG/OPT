#ifndef QUECTOC_CODEGEN_H
#define QUECTOC_CODEGEN_H
#include "ast.h"
#include "semantic.h"
#include <stdio.h>
/* Precondition: successful parsing and semantic checks; borrowed live AST.
 * 0: module written, 1: literal out of range, 2: I/O/resource/internal error.
 * Generation uses a temporary stream so rejected input produces no partial IR. */
int codegen_write_llvm(FILE *, FILE *, const AstNode *, const SemanticResult *);
#endif
