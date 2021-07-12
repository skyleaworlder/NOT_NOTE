	.file	"memory.c"
	.text
	.globl	g1
	.bss
	.align 4
g1:
	.space 4
	.globl	g2
	.align 4
g2:
	.space 4
	.globl	g3
	.align 4
g3:
	.space 4
	.comm	bss1, 4, 2
	.comm	bss2, 4, 2
	.comm	bss3, 4, 2
	.section .rdata,"dr"
.LC0:
	.ascii "\264\362\323\241max\263\314\320\362\265\330\326\267\0"
.LC1:
	.ascii "in max: 0x%08x\12\0"
.LC2:
	.ascii "\264\362\323\241max\272\257\312\375\326\320\276\262\314\254\261\344\301\277\265\330\326\267\0"
.LC3:
	.ascii "0x%08x\12\0"
.LC4:
	.ascii "\264\362\323\241max\264\253\310\353\262\316\312\375\265\330\326\267\0"
.LC5:
	.ascii "\264\362\323\241max\272\257\312\375\326\320\276\326\262\277\261\344\301\277\265\330\326\267\0"
.LC6:
	.ascii "\264\362\323\241max\272\257\312\375\326\320malloc\267\326\305\344\265\330\326\267\0"
	.text
	.globl	max
	.def	max;	.scl	2;	.type	32;	.endef
	.seh_proc	max
max:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	%ecx, 16(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -20(%rbp)
	movl	$10, %ecx
	call	malloc
	movq	%rax, -8(%rbp)
	leaq	.LC0(%rip), %rcx
	call	puts
	leaq	max(%rip), %rdx
	leaq	.LC1(%rip), %rcx
	call	printf
	leaq	.LC2(%rip), %rcx
	call	puts
	leaq	n1_max.4101(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	n2_max.4102(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	n3_max.4103(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC4(%rip), %rcx
	call	puts
	leaq	16(%rbp), %rdx
	leaq	.LC1(%rip), %rcx
	call	printf
	leaq	.LC5(%rip), %rcx
	call	puts
	leaq	-12(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	-16(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	-20(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC6(%rip), %rcx
	call	puts
	movq	-8(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	movl	16(%rbp), %eax
	cmpl	$1, %eax
	sete	%al
	movzbl	%al, %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
.LC7:
	.ascii "\264\362\323\241\327\323\272\257\312\375\306\360\312\274\265\330\326\267\0"
.LC8:
	.ascii "max: 0x%08x\12\0"
.LC9:
	.ascii "\264\362\323\241\263\314\320\362\263\365\312\274\263\314\320\362main\265\330\326\267\0"
.LC10:
	.ascii "main: 0x%08x\12\0"
.LC11:
	.ascii "\264\362\323\241 argv \265\330\326\267\0"
.LC12:
	.ascii "argv: 0x%08x\12\0"
.LC13:
	.ascii "\264\362\323\241malloc\267\326\305\344\265\304\266\321\265\330\326\267\0"
.LC14:
	.ascii "malloc: 0x%08x\12\0"
	.align 8
.LC15:
	.ascii "\264\362\323\241\270\367\310\253\276\326\261\344\301\277(\322\321\263\365\312\274\273\257)\265\304\304\332\264\346\265\330\326\267\0"
.LC16:
	.ascii "\264\362\323\241\270\367\276\262\314\254\261\344\301\277\265\304\304\332\264\346\265\330\326\267\0"
	.align 8
.LC17:
	.ascii "\264\362\323\241\270\367\310\253\276\326\261\344\301\277(\316\264\263\365\312\274\273\257)\265\304\304\332\264\346\265\330\326\267\0"
.LC18:
	.ascii "\264\362\323\241 argc \265\330\326\267\0"
.LC19:
	.ascii "\264\362\323\241\270\367\276\326\262\277\261\344\301\277\265\304\304\332\264\346\265\330\326\267\0"
.LC20:
	.ascii "======================\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	%ecx, 16(%rbp)
	movq	%rdx, 24(%rbp)
	call	__main
	movl	$0, -12(%rbp)
	movl	$0, -20(%rbp)
	movl	$10, %ecx
	call	malloc
	movq	%rax, -8(%rbp)
	leaq	.LC7(%rip), %rcx
	call	puts
	leaq	max(%rip), %rdx
	leaq	.LC8(%rip), %rcx
	call	printf
	leaq	.LC9(%rip), %rcx
	call	puts
	leaq	main(%rip), %rdx
	leaq	.LC10(%rip), %rcx
	call	printf
	leaq	.LC11(%rip), %rcx
	call	puts
	movq	24(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC12(%rip), %rcx
	call	printf
	leaq	.LC13(%rip), %rcx
	call	puts
	movq	-8(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC14(%rip), %rcx
	call	printf
	leaq	.LC15(%rip), %rcx
	call	puts
	leaq	g1(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	g2(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	g3(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC16(%rip), %rcx
	call	puts
	leaq	s1.4112(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	s2.4113(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	s3.4114(%rip), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC17(%rip), %rcx
	call	puts
	leaq	bss1(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	bss2(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	bss3(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC18(%rip), %rcx
	call	puts
	leaq	16(%rbp), %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC19(%rip), %rcx
	call	puts
	leaq	-12(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	-16(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	-20(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rcx
	call	printf
	leaq	.LC20(%rip), %rcx
	call	puts
	movl	-12(%rbp), %eax
	movl	%eax, %ecx
	call	max
	leaq	.LC20(%rip), %rcx
	call	puts
	movl	$0, %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
.lcomm n1_max.4101,4,4
.lcomm n2_max.4102,4,4
.lcomm n3_max.4103,4,4
.lcomm s1.4112,4,4
.lcomm s2.4113,4,4
.lcomm s3.4114,4,4
	.ident	"GCC: (x86_64-posix-seh, Built by strawberryperl.com project) 8.3.0"
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
