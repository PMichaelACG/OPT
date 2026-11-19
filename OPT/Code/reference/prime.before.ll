; ModuleID = 'openmp/prime_work.c'
source_filename = "openmp/prime_work.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ident_t = type { i32, i32, i32, i32, ptr }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 514, i32 0, i32 22, ptr @0 }, align 8
@.gomp_critical_user_.reduction.var = common global [8 x i32] zeroinitializer, align 8
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 18, i32 0, i32 22, ptr @0 }, align 8
@3 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @is_prime(i32 noundef %value) #0 {
entry:
  %retval = alloca i32, align 4
  %value.addr = alloca i32, align 4
  %divisor = alloca i32, align 4
  store i32 %value, ptr %value.addr, align 4
  %0 = load i32, ptr %value.addr, align 4
  %cmp = icmp slt i32 %0, 2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 0, ptr %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  %1 = load i32, ptr %value.addr, align 4
  %cmp1 = icmp eq i32 %1, 2
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  store i32 1, ptr %retval, align 4
  br label %return

if.end3:                                          ; preds = %if.end
  %2 = load i32, ptr %value.addr, align 4
  %rem = srem i32 %2, 2
  %cmp4 = icmp eq i32 %rem, 0
  br i1 %cmp4, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end3
  store i32 0, ptr %retval, align 4
  br label %return

if.end6:                                          ; preds = %if.end3
  store i32 3, ptr %divisor, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end6
  %3 = load i32, ptr %divisor, align 4
  %4 = load i32, ptr %value.addr, align 4
  %5 = load i32, ptr %divisor, align 4
  %div = sdiv i32 %4, %5
  %cmp7 = icmp sle i32 %3, %div
  br i1 %cmp7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %6 = load i32, ptr %value.addr, align 4
  %7 = load i32, ptr %divisor, align 4
  %rem8 = srem i32 %6, %7
  %cmp9 = icmp eq i32 %rem8, 0
  br i1 %cmp9, label %if.then10, label %if.end11

if.then10:                                        ; preds = %for.body
  store i32 0, ptr %retval, align 4
  br label %return

if.end11:                                         ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end11
  %8 = load i32, ptr %divisor, align 4
  %add = add nsw i32 %8, 2
  store i32 %add, ptr %divisor, align 4
  br label %for.cond, !llvm.loop !7

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %retval, align 4
  br label %return

return:                                           ; preds = %for.end, %if.then10, %if.then5, %if.then2, %if.then
  %9 = load i32, ptr %retval, align 4
  ret i32 %9
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @count_primes_serial(i32 noundef %limit) #0 {
entry:
  %limit.addr = alloca i32, align 4
  %count = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %limit, ptr %limit.addr, align 4
  store i32 0, ptr %count, align 4
  store i32 2, ptr %value, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %value, align 4
  %1 = load i32, ptr %limit.addr, align 4
  %cmp = icmp sle i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %value, align 4
  %call = call i32 @is_prime(i32 noundef %2)
  %3 = load i32, ptr %count, align 4
  %add = add nsw i32 %3, %call
  store i32 %add, ptr %count, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %4 = load i32, ptr %value, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, ptr %value, align 4
  br label %for.cond, !llvm.loop !9

for.end:                                          ; preds = %for.cond
  %5 = load i32, ptr %count, align 4
  ret i32 %5
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @count_primes_parallel(i32 noundef %limit, ptr noundef %actual_threads) #0 {
entry:
  %limit.addr = alloca i32, align 4
  %actual_threads.addr = alloca ptr, align 8
  %count = alloca i32, align 4
  store i32 %limit, ptr %limit.addr, align 4
  store ptr %actual_threads, ptr %actual_threads.addr, align 8
  store i32 0, ptr %count, align 4
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @3, i32 3, ptr @count_primes_parallel.omp_outlined, ptr %limit.addr, ptr %actual_threads.addr, ptr %count)
  %0 = load i32, ptr %count, align 4
  ret i32 %0
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @count_primes_parallel.omp_outlined(ptr noalias noundef %.global_tid., ptr noalias noundef %.bound_tid., ptr noundef nonnull align 4 dereferenceable(4) %limit, ptr noundef nonnull align 8 dereferenceable(8) %actual_threads, ptr noundef nonnull align 4 dereferenceable(4) %count) #1 {
entry:
  %.global_tid..addr = alloca ptr, align 8
  %.bound_tid..addr = alloca ptr, align 8
  %limit.addr = alloca ptr, align 8
  %actual_threads.addr = alloca ptr, align 8
  %count.addr = alloca ptr, align 8
  %.omp.iv = alloca i32, align 4
  %tmp = alloca i32, align 4
  %.capture_expr. = alloca i32, align 4
  %.capture_expr.1 = alloca i32, align 4
  %value = alloca i32, align 4
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %count3 = alloca i32, align 4
  %value4 = alloca i32, align 4
  %.omp.reduction.red_list = alloca [1 x ptr], align 8
  store ptr %.global_tid., ptr %.global_tid..addr, align 8
  store ptr %.bound_tid., ptr %.bound_tid..addr, align 8
  store ptr %limit, ptr %limit.addr, align 8
  store ptr %actual_threads, ptr %actual_threads.addr, align 8
  store ptr %count, ptr %count.addr, align 8
  %0 = load ptr, ptr %limit.addr, align 8
  %1 = load ptr, ptr %actual_threads.addr, align 8
  %2 = load ptr, ptr %count.addr, align 8
  %3 = load i32, ptr %0, align 4
  store i32 %3, ptr %.capture_expr., align 4
  %4 = load i32, ptr %.capture_expr., align 4
  %sub = sub nsw i32 %4, 1
  %div = sdiv i32 %sub, 1
  %sub2 = sub nsw i32 %div, 1
  store i32 %sub2, ptr %.capture_expr.1, align 4
  store i32 2, ptr %value, align 4
  %5 = load i32, ptr %.capture_expr., align 4
  %cmp = icmp sle i32 2, %5
  br i1 %cmp, label %omp.precond.then, label %omp.precond.end

omp.precond.then:                                 ; preds = %entry
  store i32 0, ptr %.omp.lb, align 4
  %6 = load i32, ptr %.capture_expr.1, align 4
  store i32 %6, ptr %.omp.ub, align 4
  store i32 1, ptr %.omp.stride, align 4
  store i32 0, ptr %.omp.is_last, align 4
  store i32 0, ptr %count3, align 4
  %7 = load ptr, ptr %.global_tid..addr, align 8
  %8 = load i32, ptr %7, align 4
  call void @__kmpc_for_static_init_4(ptr @1, i32 %8, i32 34, ptr %.omp.is_last, ptr %.omp.lb, ptr %.omp.ub, ptr %.omp.stride, i32 1, i32 1)
  %9 = load i32, ptr %.omp.ub, align 4
  %10 = load i32, ptr %.capture_expr.1, align 4
  %cmp5 = icmp sgt i32 %9, %10
  br i1 %cmp5, label %cond.true, label %cond.false

cond.true:                                        ; preds = %omp.precond.then
  %11 = load i32, ptr %.capture_expr.1, align 4
  br label %cond.end

cond.false:                                       ; preds = %omp.precond.then
  %12 = load i32, ptr %.omp.ub, align 4
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %11, %cond.true ], [ %12, %cond.false ]
  store i32 %cond, ptr %.omp.ub, align 4
  %13 = load i32, ptr %.omp.lb, align 4
  store i32 %13, ptr %.omp.iv, align 4
  br label %omp.inner.for.cond

omp.inner.for.cond:                               ; preds = %omp.inner.for.inc, %cond.end
  %14 = load i32, ptr %.omp.iv, align 4
  %15 = load i32, ptr %.omp.ub, align 4
  %cmp6 = icmp sle i32 %14, %15
  br i1 %cmp6, label %omp.inner.for.body, label %omp.inner.for.end

omp.inner.for.body:                               ; preds = %omp.inner.for.cond
  %16 = load i32, ptr %.omp.iv, align 4
  %mul = mul nsw i32 %16, 1
  %add = add nsw i32 2, %mul
  store i32 %add, ptr %value4, align 4
  %17 = load i32, ptr %value4, align 4
  %cmp7 = icmp eq i32 %17, 2
  br i1 %cmp7, label %if.then, label %if.end

if.then:                                          ; preds = %omp.inner.for.body
  %call = call i32 @omp_get_num_threads()
  %18 = load ptr, ptr %1, align 8
  store i32 %call, ptr %18, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %omp.inner.for.body
  %19 = load i32, ptr %value4, align 4
  %call8 = call i32 @is_prime(i32 noundef %19)
  %20 = load i32, ptr %count3, align 4
  %add9 = add nsw i32 %20, %call8
  store i32 %add9, ptr %count3, align 4
  br label %omp.body.continue

omp.body.continue:                                ; preds = %if.end
  br label %omp.inner.for.inc

omp.inner.for.inc:                                ; preds = %omp.body.continue
  %21 = load i32, ptr %.omp.iv, align 4
  %add10 = add nsw i32 %21, 1
  store i32 %add10, ptr %.omp.iv, align 4
  br label %omp.inner.for.cond

omp.inner.for.end:                                ; preds = %omp.inner.for.cond
  br label %omp.loop.exit

omp.loop.exit:                                    ; preds = %omp.inner.for.end
  %22 = load ptr, ptr %.global_tid..addr, align 8
  %23 = load i32, ptr %22, align 4
  call void @__kmpc_for_static_fini(ptr @1, i32 %23)
  %24 = getelementptr inbounds [1 x ptr], ptr %.omp.reduction.red_list, i64 0, i64 0
  store ptr %count3, ptr %24, align 8
  %25 = load ptr, ptr %.global_tid..addr, align 8
  %26 = load i32, ptr %25, align 4
  %27 = call i32 @__kmpc_reduce_nowait(ptr @2, i32 %26, i32 1, i64 8, ptr %.omp.reduction.red_list, ptr @count_primes_parallel.omp_outlined.omp.reduction.reduction_func, ptr @.gomp_critical_user_.reduction.var)
  switch i32 %27, label %.omp.reduction.default [
    i32 1, label %.omp.reduction.case1
    i32 2, label %.omp.reduction.case2
  ]

.omp.reduction.case1:                             ; preds = %omp.loop.exit
  %28 = load i32, ptr %2, align 4
  %29 = load i32, ptr %count3, align 4
  %add11 = add nsw i32 %28, %29
  store i32 %add11, ptr %2, align 4
  call void @__kmpc_end_reduce_nowait(ptr @2, i32 %26, ptr @.gomp_critical_user_.reduction.var)
  br label %.omp.reduction.default

.omp.reduction.case2:                             ; preds = %omp.loop.exit
  %30 = load i32, ptr %count3, align 4
  %31 = atomicrmw add ptr %2, i32 %30 monotonic, align 4
  br label %.omp.reduction.default

.omp.reduction.default:                           ; preds = %.omp.reduction.case2, %.omp.reduction.case1, %omp.loop.exit
  br label %omp.precond.end

omp.precond.end:                                  ; preds = %.omp.reduction.default, %entry
  ret void
}

; Function Attrs: nounwind
declare void @__kmpc_for_static_init_4(ptr, i32, i32, ptr, ptr, ptr, ptr, i32, i32) #2

declare i32 @omp_get_num_threads() #3

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(ptr, i32) #2

; Function Attrs: noinline norecurse nounwind uwtable
define internal void @count_primes_parallel.omp_outlined.omp.reduction.reduction_func(ptr noundef %0, ptr noundef %1) #4 {
entry:
  %.addr = alloca ptr, align 8
  %.addr1 = alloca ptr, align 8
  store ptr %0, ptr %.addr, align 8
  store ptr %1, ptr %.addr1, align 8
  %2 = load ptr, ptr %.addr, align 8
  %3 = load ptr, ptr %.addr1, align 8
  %4 = getelementptr inbounds [1 x ptr], ptr %3, i64 0, i64 0
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds [1 x ptr], ptr %2, i64 0, i64 0
  %7 = load ptr, ptr %6, align 8
  %8 = load i32, ptr %7, align 4
  %9 = load i32, ptr %5, align 4
  %add = add nsw i32 %8, %9
  store i32 %add, ptr %7, align 4
  ret void
}

; Function Attrs: convergent nounwind
declare i32 @__kmpc_reduce_nowait(ptr, i32, i32, i64, ptr, ptr, ptr) #5

; Function Attrs: convergent nounwind
declare void @__kmpc_end_reduce_nowait(ptr, i32, ptr) #5

; Function Attrs: nounwind
declare !callback !10 void @__kmpc_fork_call(ptr, i32, ptr, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noinline norecurse nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { convergent nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4, !5}
!llvm.ident = !{!6}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"openmp", i32 51}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{!"Debian clang version 18.1.8 (++20240731024826+3b5b5c1ec4a3-1~exp1~20240731144843.145)"}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = !{!11}
!11 = !{i64 2, i64 -1, i64 -1, i1 true}
