; ModuleID = 'build/squares.ssa.ll'
source_filename = "build/squares.raw.ll"

@.fmt.int = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(ptr, ...)

define i32 @main() {
entry:
  br label %while.cond.1

while.cond.1:                                     ; preds = %while.body.1.1, %entry
  %v6.0 = phi i32 [ 0, %entry ], [ %t10.1, %while.body.1.1 ]
  %v9.0 = phi i32 [ 0, %entry ], [ %t8.1, %while.body.1.1 ]
  br label %while.body.1

while.body.1:                                     ; preds = %while.cond.1
  %t7 = mul i32 %v6.0, %v6.0
  %t8 = add i32 %v9.0, %t7
  %t10 = add nuw nsw i32 %v6.0, 1
  %t3.1 = icmp ult i32 %t10, 7
  br i1 %t3.1, label %while.body.1.1, label %while.end.1

while.body.1.1:                                   ; preds = %while.body.1
  %t7.1 = mul i32 %t10, %t10
  %t8.1 = add i32 %t8, %t7.1
  %t10.1 = add nuw nsw i32 %v6.0, 2
  br label %while.cond.1, !llvm.loop !0

while.end.1:                                      ; preds = %while.body.1
  %v9.0.lcssa = phi i32 [ %t8, %while.body.1 ]
  %0 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i32 %v9.0.lcssa)
  ret i32 0
}

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
