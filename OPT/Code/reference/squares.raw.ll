; QuectoC LLVM IR, semantic v2.0 foundation
@.fmt.int = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
declare i32 @printf(ptr, ...)

define i32 @main() {
entry:
  %v2 = alloca i32
  %v6 = alloca i32
  %v9 = alloca i32
  store i32 7, ptr %v2
  store i32 0, ptr %v6
  store i32 0, ptr %v9
  br label %while.cond.1

while.cond.1:
  %t1 = load i32, ptr %v6
  %t2 = load i32, ptr %v2
  %t3 = icmp slt i32 %t1, %t2
  br i1 %t3, label %while.body.1, label %while.end.1

while.body.1:
  %t4 = load i32, ptr %v9
  %t5 = load i32, ptr %v6
  %t6 = load i32, ptr %v6
  %t7 = mul i32 %t5, %t6
  %t8 = add i32 %t4, %t7
  store i32 %t8, ptr %v9
  %t9 = load i32, ptr %v6
  %t10 = add i32 %t9, 1
  store i32 %t10, ptr %v6
  br label %while.cond.1

while.end.1:
  %t11 = load i32, ptr %v9
  call i32 (ptr, ...) @printf(ptr @.fmt.int, i32 %t11)
  ret i32 0
}
