.data
result:	.asciiz	"\n\nResult of A/B by the iterative subtraction --> Remainder = "
quot:	.asciiz	", Quotient = "
newline:	.asciiz	"\n"
firstl:	.asciiz	"Step\tAction\t\tQuotient\tDivisor \tReminder"
inival:	.asciiz	"\tInitial Vals\t"
tab:	.asciiz	"\t"
rem:	.asciiz	"\tRem=Rem-Div\t"
reml0:	.asciiz	"\tRem<0,R+D,Q<<\t"
rshift:	.asciiz	"\tRshift Div\t"
remg0:	.asciiz	"\tRem>=0,Q<<,q0=1\t"
.text
.globl	ex.3.18
ex.3.18:addi	$sp,$sp,-4
	sw	$ra,($sp)

	move	$t0,$a0	# $t0: dividend
	move	$t1,$a1	# $t1: divisor
	move	$t2,$a2	# $t2: number of bits
	jal	display
	
	li	$t3,0	# quotient register
	li	$t4,0	# steps counter
	la	$a0,firstl	# first line
	li	$v0,4
	syscall
	sllv	$t1,$t1,$t2	# the divisor starts in the left half of the divisor register
	la	$a3,inival
	jal	pdata
divl:	bltz	$t2,done	# if $t2<0, go to done label
	la	$a0,newline	# to print a \n character
	li	$v0,4
	syscall
	addi	$t4,$t4,1	# increment the number of steps
	sub	$t0,$t0,$t1	# 1.substract the divisor register from the reminder register and place the result in the reminder register
	la	$a3,rem		# to print rem=rem-div
	jal	pdata
	bltz	$t0,rltz	# test remainder, if remainder less than 0, go to rltz label, else...
	sll	$t3,$t3,1	# 2a.if reminder is greater or equal to 0, shift the quotient register to the left,
	ori	$t3,1		# set the new rightmost bit to 1
	la	$a3,remg0	# print when remainder > 0
	jal	pdata
	j	step3		# jump to step3 label
rltz:	add	$t0,$t0,$t1	# 2b.if reminder is less than 0, restore the original value of reminder
	sll	$t3,$t3,1	# and shift the quotient register to the left and place 0 in the least significant bit
	la	$a3,reml0	# reminder less than 0
	jal	pdata
step3:	srl	$t1,$t1,1	# 3.shift the divisor register right 1 bit
	la	$a3,rshift	# print step 3
	jal	pdata
	addi	$t2,$t2,-1	# decreases the number of bits
	j	divl
	
done:	la	$a0,result
	li	$v0,4
	sysCall
	move	$a0,$t0	# to print the remainder
	li	$v0,1
	sysCall
	la	$a0,quot
	li	$v0,4
	syscall
	move	$a0,$t3	# to print the quotient
	li	$v0,1
	syscall
	la	$a0,newline	# to print a \n
	li	$v0,4
	syscall

	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra
###################################################
pdata:	addi	$sp,$sp,-4
	sw	$ra,($sp)

	la	$a0,newline	# to print a \n character
	li	$v0,4
	syscall
	move	$a0,$t4	# to print the step number
	li	$v0,1
	syscall
	move	$a0,$a3	# to print the action
	li	$v0,4
	syscall
	move	$a0,$t3	# to print the quotient in binary format
	move	$a1,$a2	# number of bits
	jal	pbin
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	move	$a0,$t1	# to print the divisor in binary format
	sll	$a1,$a2,1	# number of bits
	jal	pbin
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	move	$a0,$t0	# to print the remainder in binary format
	jal	pbin

	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr $ra
