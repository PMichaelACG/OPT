	.text
	.intel_syntax noprefix
	.file	"squares.raw.ll"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	xor	eax, eax
	xor	esi, esi
	cmp	eax, 6
	jg	.LBB0_3
	.p2align	4, 0x90
.LBB0_2:                                # %while.body.1
                                        # =>This Inner Loop Header: Depth=1
	mov	ecx, eax
	imul	ecx, eax
	add	esi, ecx
	inc	eax
	cmp	eax, 6
	jle	.LBB0_2
.LBB0_3:                                # %while.end.1
	push	rax
	.cfi_def_cfa_offset 16
	lea	rdi, [rip + .L.fmt.int]
	xor	eax, eax
	call	printf@PLT
	xor	eax, eax
	pop	rcx
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.L.fmt.int,@object              # @.fmt.int
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.fmt.int:
	.asciz	"%d\n"
	.size	.L.fmt.int, 4

	.type	.L.fmt.str,@object              # @.fmt.str
.L.fmt.str:
	.asciz	"%s\n"
	.size	.L.fmt.str, 4

	.section	".note.GNU-stack","",@progbits
