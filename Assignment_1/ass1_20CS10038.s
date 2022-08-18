	.file	"asgn1.c" 								# source file name
	.text											# start of read
	.section	.rodata 							# read-only data section
	.align 8										# align with 8 bit boundary
.LC0:													
	.string	"Enter the string (all lower case): "	# 1st printf statement to prompt for str
.LC1:
	.string	"%s"									# label of f-string scanf, scanning the string str
.LC2:
	.string	"Length of the string: %d\n"			# printf for printing length of string
	.align 8										# align with 8 byte boundary
.LC3:
	.string	"The string in descending order: %s\n"  # printf for printing sorted string
	.text											# code starts
	.globl	main									# main is a global name
	.type	main, @function							# main is a function
main: 												# start of main
.LFB0: 					
	.cfi_startproc									
	endbr64			
	pushq	%rbp									# save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6
	subq	$80, %rsp								# create space for local variables
	movq	%fs:40, %rax							# segment addressing
	movq	%rax, -8(%rbp)							# set (rbp-8) to %rax 
	xorl	%eax, %eax								# set eax to 0
	leaq	.LC0(%rip), %rax						# load the input prompt into rax
	movq	%rax, %rdi								# set rdi(first argument) to the input prompt(LC0)
	movl	$0, %eax								# set eax to 0
	call	printf@PLT								# call the printf function to print input prompt(printf(LC0))
	leaq	-64(%rbp), %rax							# str(rbp-64) is stored in %rax
	movq	%rax, %rsi								# set %rsi(second argument) to str
	leaq	.LC1(%rip), %rax						# set rax to "%s"(LC1)
	movq	%rax, %rdi								# set %rdi(first argument) to LC1
	movl	$0, %eax								# set %eax to 0 
	call	__isoc99_scanf@PLT						# call the scanf function(scanf("%s", str))
	leaq	-64(%rbp), %rax							# set %rax to str
	movq	%rax, %rdi								# set %rdi(first argument) to str
	call	length									# call the length function(length(str))
	movl	%eax, -68(%rbp)							# set len(rbp-68) to return value from length(str)
	movl	-68(%rbp), %eax							# set %eax to len
	movl	%eax, %esi								# set %esi(second argument) to len
	leaq	.LC2(%rip), %rax						# set %rax to LC2(printf for length)
	movq	%rax, %rdi								# set %rdi(first argument) to LC2
	movl	$0, %eax								# set %eax to 0
	call	printf@PLT								# call printf for length(printf(LC2, len))
	leaq	-32(%rbp), %rdx							# load dest(rbp-32) into %rdx(the third argument)
	movl	-68(%rbp), %ecx							# set %ecx to len
	leaq	-64(%rbp), %rax							# load str into %rax
	movl	%ecx, %esi								# set %esi(second argument) to len
	movq	%rax, %rdi								# set %rdi(first argument) to str
	call	sort									# call sort function(sort(str, len, dest))
	leaq	-32(%rbp), %rax							# load dest into %rax
	movq	%rax, %rsi								# set %rsi(second argument) to dest
	leaq	.LC3(%rip), %rax						# load LC3(printf for printing sorted string) into %rax
	movq	%rax, %rdi								# set %rdi(first argument) to LC3
	movl	$0, %eax								# set %eax to 0
	call	printf@PLT								# call printf(LC3, dest)
	movl	$0, %eax								# set %eax to 0
	movq	-8(%rbp), %rdx							# set %rdx to (rbp-8)
	subq	%fs:40, %rdx							# segment addressing
	je	.L3
	call	__stack_chk_fail@PLT
.L3:												
	leave											# leave main by storing the previous base pointer in %rbp and popping it from the stack
	.cfi_def_cfa 7, 8		
	ret												# return main
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	length									# length is global function
	.type	length, @function						# length is a function
length:												# start of length function
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp 									# save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# set new stack base pointer
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)							# store str at rbp-24
	movl	$0, -4(%rbp)							# set i(rbp-4) to 0
	jmp	.L5											# jump to the for loop in length function(L5)
.L6:												# increment code
	addl	$1, -4(%rbp)							# add 1 to i
.L5:												# for loop 
	movl	-4(%rbp), %eax							# set %eax to i
	movslq	%eax, %rdx								# set %rdx to i 
	movq	-24(%rbp), %rax							# storing str in %rax
	addq	%rdx, %rax								# after this %rax is at i-th position of the string  
	movzbl	(%rax), %eax							# set %eax to (str+i)
	testb	%al, %al								# this line checks if str[i] is '\0'(which has ascii value of 0)
	jne	.L6											# if the condition doesn't satisfy, jump to L6 which adds 1 to i and repeats the loop
	movl	-4(%rbp), %eax							# store i(which would be the length when '\0' is encountered) into %eax(return register) 
	popq	%rbp									# pop the current pointer from the stack
	.cfi_def_cfa 7, 8
	ret												# return
	.cfi_endproc
.LFE1:
	.size	length, .-length
	.globl	sort									# sort is a global function
	.type	sort, @function							# sort is a function
sort:												# start of sort
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp									# store the base pointer in stack
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# set new stack base pointer
	.cfi_def_cfa_register 6
	subq	$48, %rsp								# allocating Memory for local variables
	movq	%rdi, -24(%rbp)							# set str(rbp - 24) to %rdi(argument 1)
	movl	%esi, -28(%rbp)							# set len(rbp - 28) to %esi(argument 2)
	movq	%rdx, -40(%rbp)							# set dest(rbp - 40) to %rdx(argument 3)
	movl	$0, -8(%rbp)							# set i(rbp-8) to 0
	jmp	.L9											# get into first for loop(i = 0;i < len;i++)
.L13:												# inner loop start 
	movl	$0, -4(%rbp)							# set j(rbp-4) to 0
	jmp	.L10										# jump to L10
.L12:												# code for swapping str[i], str[j] if str[i] <= str[j]
	movl	-8(%rbp), %eax							# set eax to i
	movslq	%eax, %rdx								# set rdx to i
	movq	-24(%rbp), %rax							# set rax to str
	addq	%rdx, %rax								# set rax to (str+i)
	movzbl	(%rax), %edx							# set edx to (str+i)
	movl	-4(%rbp), %eax							# set %eax to j
	movslq	%eax, %rcx								# set %rcx to j
	movq	-24(%rbp), %rax							# set %rax to str  						
	addq	%rcx, %rax								# set %rax to (str+j)								
	movzbl	(%rax), %eax							# set %eax to (str+j)							
	cmpb	%al, %dl								# compare str[j] with str[j]								 
	jge	.L11										# if str[i] >= str[j], jump to L11(continue without swap)
	movl	-8(%rbp), %eax							# set %eax to i
	movslq	%eax, %rdx								# set %rdx to i								
	movq	-24(%rbp), %rax							# set %rax to str							
	addq	%rdx, %rax								# set %rax to (str+i)								
	movzbl	(%rax), %eax							# set %eax to (str+i)
	movb	%al, -9(%rbp)							# store str[i] in temp(rbp-9)
	movl	-4(%rbp), %eax							# set %eax to j
	movslq	%eax, %rdx								# set %rdx to j
	movq	-24(%rbp), %rax							# set %rax to str
	addq	%rdx, %rax								# set %rax to str[j]								
	movl	-8(%rbp), %edx							# set %edx to i							
	movslq	%edx, %rcx								# set %rcx to i
	movq	-24(%rbp), %rdx							# set %rdx to str							
	addq	%rcx, %rdx								# set %rdx to (str+i)
	movzbl	(%rax), %eax							# set %eax to str[j]							
	movb	%al, (%rdx)								# store str[j] at rdx(effectively str[i] = str[j]) 
	movl	-4(%rbp), %eax							# set %eax to j
	movslq	%eax, %rdx								# set %rdx to j								
	movq	-24(%rbp), %rax							# set %rax to str
	addq	%rax, %rdx								# set %rdx to str[j]
	movzbl	-9(%rbp), %eax							# set %eax to temp(rbp-9)
	movb	%al, (%rdx)								# store temp at rdx(effectively str[j] = temp(previous value of str[i]))
.L11:												# increment j by 1
	addl	$1, -4(%rbp)
.L10:												# code for comparing j with len
	movl	-4(%rbp), %eax							# set %eax to j
	cmpl	-28(%rbp), %eax							# compare j with len
	jl	.L12										# if j less than len, jump to L12
	addl	$1, -8(%rbp)							# increment i by one
.L9:												# outer for loop
	movl	-8(%rbp), %eax							# set %eax to i 
	cmpl	-28(%rbp), %eax							# compare i with length
	jl	.L13										# while i is less than len, jump to L13
	movq	-40(%rbp), %rdx							# set %rdx to dest(third arg)
	movl	-28(%rbp), %ecx							# set %ecx to len
	movq	-24(%rbp), %rax							# set %rax to str
	movl	%ecx, %esi								# set %esi to len(second arg)
	movq	%rax, %rdi								# set %rdi to str(first arg)
	call	reverse									# call reverse with the saved args
	nop
	leave											# leave pops the current stack pointer of function and reverts to the previous pointer
	.cfi_def_cfa 7, 8
	ret												# return
	.cfi_endproc
.LFE2:
	.size	sort, .-sort
	.globl	reverse									# reverse is a global name
	.type	reverse, @function						# reverse is a function
reverse:											# start of reverse
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp									# save old stack pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp								# save new stack base pointer 
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)							# set str to %rdi
	movl	%esi, -28(%rbp)							# set len to %esi
	movq	%rdx, -40(%rbp)							# set dest to %rdx
	movl	$0, -8(%rbp)							# set i to 0
	jmp	.L15										# jump to L15
.L20:												# inner loop start
	movl	-28(%rbp), %eax							# set %eax to len
	subl	-8(%rbp), %eax							# set %eax to len-i
	subl	$1, %eax								# set %eax to len-i-1
	movl	%eax, -4(%rbp)							# set j to len-i-1
	nop
	movl	-28(%rbp), %eax							# line 206 - 210 (divide len by 2 using the same method as in line 244 - 248)
	movl	%eax, %edx								
	shrl	$31, %edx								
	addl	%edx, %eax								 
	sarl	%eax									# %eax = len/2
	cmpl	%eax, -4(%rbp)							# compare j with len/2
	jl	.L18										# if j < len/2 jump to L18(increment i and continue)
	movl	-8(%rbp), %eax							# set #eax to i
	cmpl	-4(%rbp), %eax							# compare i with j
	je	.L23										# if i == j jump to L23(break)
	movl	-8(%rbp), %eax							# line 216-220: set %eax to (str+i)
	movslq	%eax, %rdx								
	movq	-24(%rbp), %rax							 
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movb	%al, -9(%rbp)							# set temp(Memory[rbp-9]) to str[i]
	movl	-4(%rbp), %eax							# line 222-225: set %rax to (str+j)
	movslq	%eax, %rdx								
	movq	-24(%rbp), %rax							
	addq	%rdx, %rax								
	movl	-8(%rbp), %edx							# line 226-229: set %rdx to (str+i)
	movslq	%edx, %rcx								
	movq	-24(%rbp), %rdx							
	addq	%rcx, %rdx								
	movzbl	(%rax), %eax							# set %eax to str[j]
	movb	%al, (%rdx)								# set (str+i) to str[j]
	movl	-4(%rbp), %eax							# line 232-235: set %rdx to str[j]
	movslq	%eax, %rdx								
	movq	-24(%rbp), %rax							
	addq	%rax, %rdx
	movzbl	-9(%rbp), %eax							# set %eax to temp
	movb	%al, (%rdx)								# set (str+j) to temp(str[i] before changing)
	jmp	.L18										# jump to L18
.L23:												# break code
	nop
.L18:												
	addl	$1, -8(%rbp)							# increment i by 1
.L15:												# code to compare i with len/2 and make jumps accordingly
	movl	-28(%rbp), %eax							# set %eax to len
	movl	%eax, %edx								# set %edx to len
	shrl	$31, %edx								# right shift %edx by 31 to get the sign bit
	addl	%edx, %eax								# add sign bit to len 
	sarl	%eax									# shift len by 1 bit to the right(effectively diving by 2)
	cmpl	%eax, -8(%rbp)							# compare i and len/2 
	jl	.L20										# if i is less than len/2 jump to L20 
	movl	$0, -8(%rbp)							# set i to 0 
	jmp	.L21										# jump to L21
.L22:												# code to set dest[i] to str[i]
	movl	-8(%rbp), %eax 							# line 254-257: set %rax to (str+i)
	movslq	%eax, %rdx								
	movq	-24(%rbp), %rax							
	addq	%rdx, %rax
	movl	-8(%rbp), %edx							# line 258-261: set %rdx to (dest+i)
	movslq	%edx, %rcx
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax							# set %eax to str[i]
	movb	%al, (%rdx)								# set (dest+i) to str[i]
	addl	$1, -8(%rbp)							# increment i
.L21:												# second for loop
	movl	-8(%rbp), %eax							# set %eax to i
	cmpl	-28(%rbp), %eax							# compare i with length
	jl	.L22										# if i is less than length, jump to L22
	nop
	nop
	popq	%rbp									# pop the current pointer from stack
	.cfi_def_cfa 7, 8
	ret												# return
	.cfi_endproc
.LFE3:
	.size	reverse, .-reverse
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
