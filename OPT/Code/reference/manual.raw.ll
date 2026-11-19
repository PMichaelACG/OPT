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
  %t2 = add i32 %t1, 1
  %t3 = load i32, ptr %v2
  %t4 = icmp slt i32 %t2, %t3
  br i1 %t4, label %while.body.1, label %while.end.1

while.body.1:
  %t5 = load i32, ptr %v9
  %t6 = load i32, ptr %v6
  %t7 = load i32, ptr %v6
  %t8 = mul i32 %t6, %t7
  %t9 = add i32 %t5, %t8
  store i32 %t9, ptr %v9
  %t10 = load i32, ptr %v9
  %t11 = load i32, ptr %v6
  %t12 = add i32 %t11, 1
  %t13 = load i32, ptr %v6
  %t14 = add i32 %t13, 1
  %t15 = mul i32 %t12, %t14
  %t16 = add i32 %t10, %t15
  store i32 %t16, ptr %v9
  %t17 = load i32, ptr %v6
  %t18 = add i32 %t17, 2
  store i32 %t18, ptr %v6
  br label %while.cond.1

while.end.1:
  br label %while.cond.2

while.cond.2:
  %t19 = load i32, ptr %v6
  %t20 = load i32, ptr %v2
  %t21 = icmp slt i32 %t19, %t20
  br i1 %t21, label %while.body.2, label %while.end.2

while.body.2:
  %t22 = load i32, ptr %v9
  %t23 = load i32, ptr %v6
  %t24 = load i32, ptr %v6
  %t25 = mul i32 %t23, %t24
  %t26 = add i32 %t22, %t25
  store i32 %t26, ptr %v9
  %t27 = load i32, ptr %v6
  %t28 = add i32 %t27, 1
  store i32 %t28, ptr %v6
  br label %while.cond.2

while.end.2:
  %t29 = load i32, ptr %v9
  call i32 (ptr, ...) @printf(ptr @.fmt.int, i32 %t29)
  ret i32 0
}
