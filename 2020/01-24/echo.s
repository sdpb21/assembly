.section .data	# .data section starts
	sys_exit: .int 1
	sys_write: .int 4
	stdout: .int 1
	slashn: .int 10
	spaceChar: .byte 32
	minusn: .ascii "-n\n"
	minusnlen: .int 3
	flg: .int 0

.section .text	# text (instruction code) section starts
.global _start	# _start is like main(), .global means public
		# public symbols are for linker to link into runtime
_start:		# _start starts here
	push %ebp
	mov %esp,%ebp

	cmpl $1,4(%ebp)
	je NoArguments	# exit if there is 1 argument

	movl $3,%ebx		
	mov (%ebp,%ebx,4),%edi	# next argument
	test %edi,%edi		
	jz Exit			# if there is no more arguments exit

	push %ebx		# calculating the argument chars to store it on edx
	xor %ecx,%ecx		
	not %ecx		
	xor %eax,%eax		
	cld			
	repne scasb		
	movb $10,-1(%edi)	
	not %ecx		
	pop %ebx		
	lea -1(%ecx),%edx	# edx=number of characters of the string argument

	movl (%ebp,%ebx,4),%ecx	# store the direction of the argument string
	call DisplayNorm	# print the argument on screen

	inc %ebx		# increment arguments array index

DoNextArg:
	mov (%ebp,%ebx,4),%edi	# next argument
	test %edi,%edi		
	jz Exit			# if there is no argument then exit

	push %ebx		

	movl sys_write,%eax	# to print a space character
	movl stdout,%ebx	
	movl $spaceChar,%ecx	
	movl $1,%edx		
	int $0x80		

	xor %ecx,%ecx		# to obtain the lenght of the argument string
	not %ecx		
	xor %eax,%eax		
	cld			
	repne scasb		
	movb $10,-1(%edi)	
	not %ecx		
	pop %ebx		
	lea -1(%ecx),%edx	# lenght of the string on edx

	movl (%ebp,%ebx,4),%ecx	# memory direction of the argument on ecx to print on next line
	call DisplayNorm	# show argument on screen unless it is -n

	inc %ebx		# increment argument array index
	jmp DoNextArg		# repeat for the next argument if there is one


NoArguments:
	jmp Exit

Exit:	mov %ebp,%esp		
	pop %ebp		
	xor %ecx,%ecx		
	movl flg,%ecx		
	cmpl $1,%ecx		# if ecx==1 do not print the \n
	je noNL		
	movl sys_write,%eax	# to print the \n
	movl stdout,%ebx		
	movl $slashn,%ecx		
	movl $1,%edx		
	int $0x80		

noNL:	movl sys_exit,%eax	# to exit correctly
	xor %ebx,%ebx		
	int $0x80		

DisplayNorm:		
	push %ebx	

	push %ecx	
	cld		# looking for the -n argument
	leal minusn,%esi	
	leal (%ecx),%edi	
	movl minusnlen,%ecx	
	repe cmpsb		
	je equals	# if the argument is -n go to equals
	pop %ecx		

	movl sys_write,%eax	# if not, print the argument
	movl stdout,%ebx	
	int $0x80		
	pop %ebx		
	ret			
equals:	movl $1,flg	# to not print the -n argument
	pop %ecx	
	pop %ebx	
	ret		

