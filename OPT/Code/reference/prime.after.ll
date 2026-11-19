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

; Function Attrs: nofree noinline norecurse nosync nounwind memory(none) uwtable
define dso_local noundef i32 @is_prime(i32 noundef %value) local_unnamed_addr #0 {
entry:
  %cmp = icmp slt i32 %value, 2
  br i1 %cmp, label %return, label %if.end

if.end:                                           ; preds = %entry
  %cmp1 = icmp eq i32 %value, 2
  br i1 %cmp1, label %return, label %if.end3

if.end3:                                          ; preds = %if.end
  %rem = and i32 %value, 1
  %cmp4 = icmp eq i32 %rem, 0
  br i1 %cmp4, label %return, label %for.cond.preheader

for.cond.preheader:                               ; preds = %if.end3
  %cmp7.not20 = icmp ult i32 %value, 9
  br i1 %cmp7.not20, label %return, label %for.body

for.cond:                                         ; preds = %for.body
  %add = add nuw nsw i32 %divisor.021, 2
  %div = udiv i32 %value, %add
  %cmp7.not = icmp ugt i32 %add, %div
  br i1 %cmp7.not, label %cleanup.loopexit, label %for.body, !llvm.loop !6

for.body:                                         ; preds = %for.cond.preheader, %for.cond
  %divisor.021 = phi i32 [ %add, %for.cond ], [ 3, %for.cond.preheader ]
  %rem8 = urem i32 %value, %divisor.021
  %cmp9 = icmp ne i32 %rem8, 0
  br i1 %cmp9, label %for.cond, label %cleanup.loopexit

cleanup.loopexit:                                 ; preds = %for.body, %for.cond
  %0 = zext i1 %cmp9 to i32
  br label %return

return:                                           ; preds = %for.cond.preheader, %cleanup.loopexit, %if.end3, %if.end, %entry
  %retval.1 = phi i32 [ 0, %entry ], [ 1, %if.end ], [ 0, %if.end3 ], [ 1, %for.cond.preheader ], [ %0, %cleanup.loopexit ]
  ret i32 %retval.1
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree norecurse nosync nounwind memory(none) uwtable
define dso_local i32 @count_primes_serial(i32 noundef %limit) local_unnamed_addr #2 {
entry:
  %cmp.not4 = icmp slt i32 %limit, 2
  br i1 %cmp.not4, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %count.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %count.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %value.06 = phi i32 [ %inc, %for.body ], [ 2, %entry ]
  %count.05 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %call = tail call i32 @is_prime(i32 noundef %value.06), !range !9
  %add = add nuw nsw i32 %call, %count.05
  %inc = add nuw i32 %value.06, 1
  %exitcond.not = icmp eq i32 %value.06, %limit
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !10
}

; Function Attrs: nounwind uwtable
define dso_local i32 @count_primes_parallel(i32 noundef %limit, ptr noundef %actual_threads) local_unnamed_addr #3 {
entry:
  %limit.addr = alloca i32, align 4
  %actual_threads.addr = alloca ptr, align 8
  %count = alloca i32, align 4
  store i32 %limit, ptr %limit.addr, align 4, !tbaa !11
  store ptr %actual_threads, ptr %actual_threads.addr, align 8, !tbaa !15
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %count) #5
  store i32 0, ptr %count, align 4, !tbaa !11
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr nonnull @3, i32 3, ptr nonnull @count_primes_parallel.omp_outlined, ptr nonnull %limit.addr, ptr nonnull %actual_threads.addr, ptr nonnull %count)
  %0 = load i32, ptr %count, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %count) #5
  ret i32 %0
}

; Function Attrs: alwaysinline norecurse nounwind uwtable
define internal void @count_primes_parallel.omp_outlined(ptr noalias nocapture noundef readonly %.global_tid., ptr noalias nocapture readnone %.bound_tid., ptr nocapture noundef nonnull readonly align 4 dereferenceable(4) %limit, ptr nocapture noundef nonnull readonly align 8 dereferenceable(8) %actual_threads, ptr nocapture noundef nonnull align 4 dereferenceable(4) %count) #4 {
entry:
  %.omp.lb = alloca i32, align 4
  %.omp.ub = alloca i32, align 4
  %.omp.stride = alloca i32, align 4
  %.omp.is_last = alloca i32, align 4
  %count3 = alloca i32, align 4
  %.omp.reduction.red_list = alloca [1 x ptr], align 8
  %0 = load i32, ptr %limit, align 4, !tbaa !11
  %cmp = icmp sgt i32 %0, 1
  br i1 %cmp, label %omp.precond.then, label %omp.precond.end

omp.precond.then:                                 ; preds = %entry
  %sub2 = add nsw i32 %0, -2
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %.omp.lb) #5
  store i32 0, ptr %.omp.lb, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %.omp.ub) #5
  store i32 %sub2, ptr %.omp.ub, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %.omp.stride) #5
  store i32 1, ptr %.omp.stride, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %.omp.is_last) #5
  store i32 0, ptr %.omp.is_last, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %count3) #5
  store i32 0, ptr %count3, align 4, !tbaa !11
  %1 = load i32, ptr %.global_tid., align 4, !tbaa !11
  call void @__kmpc_for_static_init_4(ptr nonnull @1, i32 %1, i32 34, ptr nonnull %.omp.is_last, ptr nonnull %.omp.lb, ptr nonnull %.omp.ub, ptr nonnull %.omp.stride, i32 1, i32 1)
  %2 = load i32, ptr %.omp.ub, align 4
  %cond = call i32 @llvm.smin.i32(i32 %2, i32 %sub2)
  store i32 %cond, ptr %.omp.ub, align 4, !tbaa !11
  %3 = load i32, ptr %.omp.lb, align 4, !tbaa !11
  %cmp6.not20 = icmp sgt i32 %3, %cond
  br i1 %cmp6.not20, label %omp.loop.exit, label %omp.inner.for.body

omp.inner.for.body:                               ; preds = %omp.precond.then, %if.end
  %4 = phi i32 [ %7, %if.end ], [ %cond, %omp.precond.then ]
  %5 = phi i32 [ %add9, %if.end ], [ 0, %omp.precond.then ]
  %.omp.iv.021 = phi i32 [ %add10, %if.end ], [ %3, %omp.precond.then ]
  %add = add nsw i32 %.omp.iv.021, 2
  %cmp7 = icmp eq i32 %.omp.iv.021, 0
  br i1 %cmp7, label %if.then, label %if.end

if.then:                                          ; preds = %omp.inner.for.body
  %call = call i32 @omp_get_num_threads()
  %6 = load ptr, ptr %actual_threads, align 8, !tbaa !15
  store i32 %call, ptr %6, align 4, !tbaa !11
  %.pre = load i32, ptr %.omp.ub, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then, %omp.inner.for.body
  %7 = phi i32 [ %.pre, %if.then ], [ %4, %omp.inner.for.body ]
  %call8 = call i32 @is_prime(i32 noundef %add), !range !9
  %add9 = add nuw nsw i32 %5, %call8
  store i32 %add9, ptr %count3, align 4, !tbaa !11
  %add10 = add nsw i32 %.omp.iv.021, 1
  %cmp6.not.not = icmp slt i32 %.omp.iv.021, %7
  br i1 %cmp6.not.not, label %omp.inner.for.body, label %omp.loop.exit

omp.loop.exit:                                    ; preds = %if.end, %omp.precond.then
  call void @__kmpc_for_static_fini(ptr nonnull @1, i32 %1)
  store ptr %count3, ptr %.omp.reduction.red_list, align 8
  %8 = call i32 @__kmpc_reduce_nowait(ptr nonnull @2, i32 %1, i32 1, i64 8, ptr nonnull %.omp.reduction.red_list, ptr nonnull @count_primes_parallel.omp_outlined.omp.reduction.reduction_func, ptr nonnull @.gomp_critical_user_.reduction.var)
  switch i32 %8, label %.omp.reduction.default [
    i32 1, label %.omp.reduction.case1
    i32 2, label %.omp.reduction.case2
  ]

.omp.reduction.case1:                             ; preds = %omp.loop.exit
  %9 = load i32, ptr %count, align 4, !tbaa !11
  %10 = load i32, ptr %count3, align 4, !tbaa !11
  %add11 = add nsw i32 %10, %9
  store i32 %add11, ptr %count, align 4, !tbaa !11
  call void @__kmpc_end_reduce_nowait(ptr nonnull @2, i32 %1, ptr nonnull @.gomp_critical_user_.reduction.var)
  br label %.omp.reduction.default

.omp.reduction.case2:                             ; preds = %omp.loop.exit
  %11 = load i32, ptr %count3, align 4, !tbaa !11
  %12 = atomicrmw add ptr %count, i32 %11 monotonic, align 4
  br label %.omp.reduction.default

.omp.reduction.default:                           ; preds = %.omp.reduction.case2, %.omp.reduction.case1, %omp.loop.exit
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %count3) #5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %.omp.is_last) #5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %.omp.stride) #5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %.omp.ub) #5
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %.omp.lb) #5
  br label %omp.precond.end

omp.precond.end:                                  ; preds = %.omp.reduction.default, %entry
  ret void
}

; Function Attrs: nounwind
declare void @__kmpc_for_static_init_4(ptr, i32, i32, ptr, ptr, ptr, ptr, i32, i32) local_unnamed_addr #5

; Function Attrs: nounwind
declare i32 @omp_get_num_threads() local_unnamed_addr #6

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(ptr, i32) local_unnamed_addr #5

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable
define internal void @count_primes_parallel.omp_outlined.omp.reduction.reduction_func(ptr nocapture noundef readonly %0, ptr nocapture noundef readonly %1) #7 {
entry:
  %2 = load ptr, ptr %1, align 8
  %3 = load ptr, ptr %0, align 8
  %4 = load i32, ptr %3, align 4, !tbaa !11
  %5 = load i32, ptr %2, align 4, !tbaa !11
  %add = add nsw i32 %5, %4
  store i32 %add, ptr %3, align 4, !tbaa !11
  ret void
}

; Function Attrs: convergent nounwind
declare i32 @__kmpc_reduce_nowait(ptr, i32, i32, i64, ptr, ptr, ptr) local_unnamed_addr #8

; Function Attrs: convergent nounwind
declare void @__kmpc_end_reduce_nowait(ptr, i32, ptr) local_unnamed_addr #8

; Function Attrs: nounwind
declare !callback !17 void @__kmpc_fork_call(ptr, i32, ptr, ...) local_unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #9

attributes #0 = { nofree noinline norecurse nosync nounwind memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree norecurse nosync nounwind memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { alwaysinline norecurse nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { convergent nounwind }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"openmp", i32 51}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 2}
!5 = !{!"Debian clang version 18.1.8 (++20240731024826+3b5b5c1ec4a3-1~exp1~20240731144843.145)"}
!6 = distinct !{!6, !7, !8}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = !{i32 0, i32 2}
!10 = distinct !{!10, !7, !8}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !13, i64 0}
!13 = !{!"omnipotent char", !14, i64 0}
!14 = !{!"Simple C/C++ TBAA"}
!15 = !{!16, !16, i64 0}
!16 = !{!"any pointer", !13, i64 0}
!17 = !{!18}
!18 = !{i64 2, i64 -1, i64 -1, i1 true}
