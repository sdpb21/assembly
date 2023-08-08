.section .data
	sys_exit: .int 1
	sys_write: .int 4
	stdout: .int 1
	slashn: .byte 10
	minus: .ascii "-"
	remL: .ascii " (+"
	remR: .ascii ")"

.section .bss
	.lcomm itos_buff,12

.section .text
.global _start

_start:
	push %ebp
	mov %esp,%ebp

	cmpl $1,4(%ebp)
	je NoArgs		# no args entered

	cmpl $4,4(%ebp)
	jne Exit1		# if there aren't 3 arguments exit with error

	mov 12(%ebp),%edi	# first operand
	test %edi,%edi
	jz Exit			# if there is no argument then exit

	call GetStrlen		# store the string length on edx

	push 12(%ebp)
	call stoi		# stores on ebx the number on the first string on interger format
	pop %ecx		# clear the stack from the last push

	mov 16(%ebp),%edi	# next argument, must be a valid operator
	test %edi,%edi
	jz Exit			# if there is no argument then exit

	call GetStrlen		# store the string length on edx
	cmpl $1,%edx		# lenght operator must be 1
	jne Exit1		# if it isn't exit with error

	mov 16(%ebp),%ecx	# put the direction of the operator string on ecx
	movzxb (%ecx),%eax	# store first char of the operator string on eax

	mov 20(%ebp),%edi	# last operand
	test %edi,%edi
	jz Exit			# if there is no argument then exit
	call GetStrlen		# store the string length on edx
	push %ebx		# first operand still in ebx
	push 20(%ebp)		# push in the stack the last operand
	call stoi		# store on ebx the last operand on integer format
	pop %ecx		# get out from stack the direction of last operand

	cmp $'+',%eax
	je add1
	cmp $'-',%eax
	je sub1
	cmp $'x',%eax
	je mul1
	cmp $'/',%eax
	je div1
	cmp $'^',%eax
	je pot1
	jmp Exit1		# if operator isn't valid, exit with error

contin:	pop %ecx		# clear the stack from the first operand
	push %ebx		# on ebx is the result of the operation
	call itosprnt		# integer to string conversion and print on screen
	pop %ecx
	jmp Exit

add1:	call add2		# adds the operands, one in the stack and the other in ebx
	jmp contin

sub1:	call sub2
	jmp contin

mul1:	call mul2
	jmp contin

div1:	call div2
	jmp contin

pot1:	call pot2
	jmp contin
;####################################################
itosprnt:
	push %ebp
	mov %esp,%ebp

	mov $itos_buff,%ecx
	movb $0,(%ecx)
	mov 8(%ebp),%eax	# move the result to eax to make the conversion to string & print
	mov $10,%ebx		# ebx=10 to divide eax by 10 several times
itos:	xor %edx,%edx		# clear edx
	div %ebx		# divide eax by 10
	add $0x30,%edx		# the remainder of eax/10 is on edx
	inc %ecx		# go to the next byte position to store next digit
	mov %dl,(%ecx)		# store the digit
	test %eax,%eax
	jnz itos
print:	cmpb $0,(%ecx)
	je printE
	mov $4,%eax
	mov $1,%ebx
	mov $1,%edx
	int $0x80
	dec %ecx
	jmp print

printE:	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
add2:
	push %ebp
	mov %esp,%ebp

	add 8(%ebp),%ebx

	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
sub2:
	push %ebp
	mov %esp,%ebp

	sub 8(%ebp),%ebx
	imul $-1,%ebx
	cmp $0,%ebx
	jnl positi
	imul $-1,%ebx
	push %ebx
	mov sys_write,%eax
	mov stdout,%ebx
	mov $minus,%ecx
	mov $1,%edx
	int $0x80
	pop %ebx

positi:	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
mul2:
	push %ebp
	mov %esp,%ebp

	mov 8(%ebp),%eax
	mul %ebx
	mov %eax,%ebx

	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
div2:
	push %ebp
	mov %esp,%ebp

	xor %edx,%edx		# initialize to 0 the remainder
	mov 8(%ebp),%eax	# puts on eax the dividend
	div %ebx		# ebx is the divisor
	mov %eax,%ebx		# puts eax on ebx to print if there is no remainder
	push %edx		# push the remainder on the stack
	cmp $0,%edx
	je noRem		# if there is no remainder just print the quotient

	push %ebx		# push the quotient
	call itosprnt		# print the quotient
	pop %ecx		# pop the quotient
	mov sys_write,%eax
	mov stdout,%ebx
	mov $remL,%ecx
	mov $3,%edx
	int $0x80
	call itosprnt		# print the remainder
	pop %ecx		# pop the remainder
	mov sys_write,%eax	# to print the ")"
	mov stdout,%ebx
	mov $remR,%ecx
	mov $1,%edx
	int $0x80
	jmp Exit

noRem:	pop %ecx		# pop the remainder
	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
pot2:
	push %ebp
	mov %esp,%ebp

	mov 8(%ebp),%eax	# base on acummulator
	mov %ebx,%ecx		# power on counter
	dec %ecx
powL:	imul 8(%ebp),%eax
	dec %ecx
	jnz powL
	mov %eax,%ebx

	mov %ebp,%esp
	pop %ebp
	ret
;####################################################
NoArgs:
#    No args entered,
#    start program without args here
    jmp     Exit
;####################################################
GetStrlen:
	push %eax
	xor %ecx,%ecx
	not %ecx
	xor %eax,%eax
	cld
	repne scasb
	movb $10,-1(%edi)
	not %ecx
	lea -1(%ecx),%edx
	pop %eax
	ret
;####################################################
stoi:	# translate a string of ascii numbers to the equivalent integer, store it in ebx
	push %eax
	push %ebp
	mov %esp,%ebp

	xor %ebx,%ebx		# store 0 on ebx
	mov 12(%ebp),%ecx
nextB:	movzxb (%ecx),%eax	# store next byte on eax
	inc %ecx		# go to the next byte direction
	cmp $0x30,%eax		# compare with ascii 0, to find if it's lower
	jb Exit1		# if eax<'0' exit with error
	cmp $0x39,%eax		# compare with ascii 9 to verify if it's greater
	ja Exit1		#	ja Exit1		; if eax>'9' exit with error
	sub $0x30,%eax		# conversion from ascii number to integer number
	imul $10,%ebx		# multiply ebx by 10
	add %eax,%ebx		# add ebx*10 and the next digit on the string ebx=ebx*10+eax
	dec %edx
	cmp $0,%edx
	jne nextB

end1:	mov %ebp,%esp
	pop %ebp
	pop %eax
	ret
;####################################################
Exit:	mov %ebp,%esp
	pop %ebp
	mov sys_write,%eax	# to print the \n
	mov stdout,%ebx
	mov $slashn,%ecx
	mov $1,%edx
	int $0x80
	mov sys_exit,%eax
	xor %ebx,%ebx
	int $0x80
;####################################################
Exit1:	mov %ebp,%esp
	pop %ebp
	mov sys_write,%eax	# to print the \n
	mov stdout,%ebx
	mov $slashn,%ecx
	mov $1,%edx
	int $0x80
	mov sys_exit,%eax
	mov $1,%ebx		# exit with error
	int $0x80
