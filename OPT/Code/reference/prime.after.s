	.text
	.intel_syntax noprefix
	.file	"prime_work.c"
	.globl	is_prime                        # -- Begin function is_prime
	.p2align	4, 0x90
	.type	is_prime,@function
is_prime:                               # @is_prime
	.cfi_startproc
# %bb.0:                                # %entry
	xor	eax, eax
	cmp	edi, 2
	jge	.LBB0_1
.LBB0_9:                                # %return
	ret
.LBB0_1:                                # %if.end
	jne	.LBB0_3
# %bb.2:
	mov	eax, 1
	ret
.LBB0_3:                                # %if.end3
	test	dil, 1
	je	.LBB0_9
# %bb.4:                                # %for.cond.preheader
	mov	eax, 1
	cmp	edi, 9
	jb	.LBB0_9
# %bb.5:                                # %for.body.preheader
	mov	esi, 3
	.p2align	4, 0x90
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	mov	eax, edi
	xor	edx, edx
	div	esi
	mov	ecx, edx
	test	edx, edx
	je	.LBB0_8
# %bb.6:                                # %for.cond
                                        #   in Loop: Header=BB0_7 Depth=1
	add	esi, 2
	mov	eax, edi
	xor	edx, edx
	div	esi
	cmp	esi, eax
	jbe	.LBB0_7
.LBB0_8:                                # %cleanup.loopexit
	xor	eax, eax
	test	ecx, ecx
	setne	al
	ret
.Lfunc_end0:
	.size	is_prime, .Lfunc_end0-is_prime
	.cfi_endproc
                                        # -- End function
	.globl	count_primes_serial             # -- Begin function count_primes_serial
	.p2align	4, 0x90
	.type	count_primes_serial,@function
count_primes_serial:                    # @count_primes_serial
	.cfi_startproc
# %bb.0:                                # %entry
	push	rbp
	.cfi_def_cfa_offset 16
	push	r14
	.cfi_def_cfa_offset 24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset rbx, -32
	.cfi_offset r14, -24
	.cfi_offset rbp, -16
	xor	ebp, ebp
	cmp	edi, 2
	jl	.LBB1_3
# %bb.1:                                # %for.body.preheader
	mov	ebx, edi
	neg	ebx
	xor	ebp, ebp
	mov	r14d, 2
	.p2align	4, 0x90
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	mov	edi, r14d
	call	is_prime
	add	ebp, eax
	lea	eax, [rbx + r14]
	inc	eax
	mov	ecx, r14d
	inc	ecx
	mov	r14d, ecx
	cmp	eax, 1
	jne	.LBB1_2
.LBB1_3:                                # %for.cond.cleanup
	mov	eax, ebp
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end1:
	.size	count_primes_serial, .Lfunc_end1-count_primes_serial
	.cfi_endproc
                                        # -- End function
	.globl	count_primes_parallel           # -- Begin function count_primes_parallel
	.p2align	4, 0x90
	.type	count_primes_parallel,@function
count_primes_parallel:                  # @count_primes_parallel
	.cfi_startproc
# %bb.0:                                # %entry
	sub	rsp, 24
	.cfi_def_cfa_offset 32
	mov	dword ptr [rsp + 12], edi
	mov	qword ptr [rsp + 16], rsi
	mov	dword ptr [rsp + 8], 0
	lea	rdi, [rip + .L__unnamed_1]
	lea	rdx, [rip + count_primes_parallel.omp_outlined]
	lea	rcx, [rsp + 12]
	lea	r8, [rsp + 16]
	lea	r9, [rsp + 8]
	mov	esi, 3
	xor	eax, eax
	call	__kmpc_fork_call@PLT
	mov	eax, dword ptr [rsp + 8]
	add	rsp, 24
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end2:
	.size	count_primes_parallel, .Lfunc_end2-count_primes_parallel
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function count_primes_parallel.omp_outlined
	.type	count_primes_parallel.omp_outlined,@function
count_primes_parallel.omp_outlined:     # @count_primes_parallel.omp_outlined
	.cfi_startproc
# %bb.0:                                # %entry
	push	rbp
	.cfi_def_cfa_offset 16
	push	r15
	.cfi_def_cfa_offset 24
	push	r14
	.cfi_def_cfa_offset 32
	push	r13
	.cfi_def_cfa_offset 40
	push	r12
	.cfi_def_cfa_offset 48
	push	rbx
	.cfi_def_cfa_offset 56
	sub	rsp, 40
	.cfi_def_cfa_offset 96
	.cfi_offset rbx, -56
	.cfi_offset r12, -48
	.cfi_offset r13, -40
	.cfi_offset r14, -32
	.cfi_offset r15, -24
	.cfi_offset rbp, -16
	mov	r15d, dword ptr [rdx]
	cmp	r15d, 2
	jl	.LBB3_10
# %bb.1:                                # %omp.precond.then
	mov	rbx, r8
	mov	r14, rcx
	add	r15d, -2
	mov	dword ptr [rsp + 20], 0
	mov	dword ptr [rsp + 16], r15d
	mov	dword ptr [rsp + 28], 1
	mov	dword ptr [rsp + 24], 0
	mov	dword ptr [rsp + 12], 0
	mov	ebp, dword ptr [rdi]
	sub	rsp, 8
	.cfi_adjust_cfa_offset 8
	lea	rax, [rsp + 36]
	lea	rdi, [rip + .L__unnamed_2]
	lea	rcx, [rsp + 32]
	lea	r8, [rsp + 28]
	lea	r9, [rsp + 24]
	mov	esi, ebp
	mov	edx, 34
	push	1
	.cfi_adjust_cfa_offset 8
	push	1
	.cfi_adjust_cfa_offset 8
	push	rax
	.cfi_adjust_cfa_offset 8
	call	__kmpc_for_static_init_4@PLT
	add	rsp, 32
	.cfi_adjust_cfa_offset -32
	mov	eax, dword ptr [rsp + 16]
	cmp	eax, r15d
	cmovl	r15d, eax
	mov	dword ptr [rsp + 16], r15d
	mov	r12d, dword ptr [rsp + 20]
	cmp	r12d, r15d
	jle	.LBB3_2
.LBB3_6:                                # %omp.loop.exit
	lea	rdi, [rip + .L__unnamed_2]
	mov	esi, ebp
	call	__kmpc_for_static_fini@PLT
	lea	rax, [rsp + 12]
	mov	qword ptr [rsp + 32], rax
	sub	rsp, 8
	.cfi_adjust_cfa_offset 8
	mov	rax, qword ptr [rip + .gomp_critical_user_.reduction.var@GOTPCREL]
	lea	rdi, [rip + .L__unnamed_3]
	lea	r9, [rip + count_primes_parallel.omp_outlined.omp.reduction.reduction_func]
	lea	r8, [rsp + 40]
	mov	ecx, 8
	mov	esi, ebp
	mov	edx, 1
	push	rax
	.cfi_adjust_cfa_offset 8
	call	__kmpc_reduce_nowait@PLT
	add	rsp, 16
	.cfi_adjust_cfa_offset -16
	cmp	eax, 2
	je	.LBB3_9
# %bb.7:                                # %omp.loop.exit
	cmp	eax, 1
	jne	.LBB3_10
# %bb.8:                                # %.omp.reduction.case1
	mov	eax, dword ptr [rsp + 12]
	add	dword ptr [rbx], eax
	lea	rdi, [rip + .L__unnamed_3]
	mov	rdx, qword ptr [rip + .gomp_critical_user_.reduction.var@GOTPCREL]
	mov	esi, ebp
	call	__kmpc_end_reduce_nowait@PLT
	jmp	.LBB3_10
.LBB3_2:                                # %omp.inner.for.body.preheader
	xor	r13d, r13d
	jmp	.LBB3_3
	.p2align	4, 0x90
.LBB3_5:                                # %if.end
                                        #   in Loop: Header=BB3_3 Depth=1
	lea	edi, [r12 + 2]
	call	is_prime
	add	r13d, eax
	mov	dword ptr [rsp + 12], r13d
	lea	eax, [r12 + 1]
	cmp	r12d, r15d
	mov	r12d, eax
	jge	.LBB3_6
.LBB3_3:                                # %omp.inner.for.body
                                        # =>This Inner Loop Header: Depth=1
	test	r12d, r12d
	jne	.LBB3_5
# %bb.4:                                # %if.then
                                        #   in Loop: Header=BB3_3 Depth=1
	call	omp_get_num_threads@PLT
	mov	rcx, qword ptr [r14]
	mov	dword ptr [rcx], eax
	mov	r15d, dword ptr [rsp + 16]
	jmp	.LBB3_5
.LBB3_9:                                # %.omp.reduction.case2
	mov	eax, dword ptr [rsp + 12]
	lock		add	dword ptr [rbx], eax
.LBB3_10:                               # %omp.precond.end
	add	rsp, 40
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	r12
	.cfi_def_cfa_offset 40
	pop	r13
	.cfi_def_cfa_offset 32
	pop	r14
	.cfi_def_cfa_offset 24
	pop	r15
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end3:
	.size	count_primes_parallel.omp_outlined, .Lfunc_end3-count_primes_parallel.omp_outlined
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function count_primes_parallel.omp_outlined.omp.reduction.reduction_func
	.type	count_primes_parallel.omp_outlined.omp.reduction.reduction_func,@function
count_primes_parallel.omp_outlined.omp.reduction.reduction_func: # @count_primes_parallel.omp_outlined.omp.reduction.reduction_func
	.cfi_startproc
# %bb.0:                                # %entry
	mov	rax, qword ptr [rsi]
	mov	rcx, qword ptr [rdi]
	mov	eax, dword ptr [rax]
	add	dword ptr [rcx], eax
	ret
.Lfunc_end4:
	.size	count_primes_parallel.omp_outlined.omp.reduction.reduction_func, .Lfunc_end4-count_primes_parallel.omp_outlined.omp.reduction.reduction_func
	.cfi_endproc
                                        # -- End function
	.type	.L__unnamed_4,@object           # @0
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_4:
	.asciz	";unknown;unknown;0;0;;"
	.size	.L__unnamed_4, 23

	.type	.L__unnamed_2,@object           # @1
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_2:
	.long	0                               # 0x0
	.long	514                             # 0x202
	.long	0                               # 0x0
	.long	22                              # 0x16
	.quad	.L__unnamed_4
	.size	.L__unnamed_2, 24

	.type	.gomp_critical_user_.reduction.var,@object # @.gomp_critical_user_.reduction.var
	.comm	.gomp_critical_user_.reduction.var,32,8
	.type	.L__unnamed_3,@object           # @2
	.p2align	3, 0x0
.L__unnamed_3:
	.long	0                               # 0x0
	.long	18                              # 0x12
	.long	0                               # 0x0
	.long	22                              # 0x16
	.quad	.L__unnamed_4
	.size	.L__unnamed_3, 24

	.type	.L__unnamed_1,@object           # @3
	.p2align	3, 0x0
.L__unnamed_1:
	.long	0                               # 0x0
	.long	2                               # 0x2
	.long	0                               # 0x0
	.long	22                              # 0x16
	.quad	.L__unnamed_4
	.size	.L__unnamed_1, 24

	.ident	"Debian clang version 18.1.8 (++20240731024826+3b5b5c1ec4a3-1~exp1~20240731144843.145)"
	.section	".note.GNU-stack","",@progbits
