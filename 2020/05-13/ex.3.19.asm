.data
result:	.asciiz	"\n\nResult of A/B by the refined iterative subtraction --> Remainder = "
quot:	.asciiz	", Quotient = "
newline:	.asciiz	"\n"
firstl:	.asciiz	"Step\tAction\t\tDivisor \tReminder,Quotient"
inival:	.asciiz	"\tInitial Vals\t"
tab:	.asciiz	"\t"
rem:	.asciiz	"\tRem=Rem-Div\t"
reml0:	.asciiz	"\tRem<0,R+D,Q<<\t"
lshift:	.asciiz	"\t(Rem,Q)<<\t"
remg0:	.asciiz	"\tRem>=0, q0=1\t"
.text
.globl	ex.3.19
ex.3.19:sw	$ra,($sp)
	addi	$sp,$sp,4

	#li	$a0,100
	move	$t0,$a0	# $t0: dividend, in this case can be used as (remainder,quotient) (Rem,Q)
	#li	$a1,11
	move	$t1,$a1	# $t1: divisor
	#li	$a2,9
	move	$t2,$a2	# $t2: number of bits
	jal	display
	
	li	$t3,0	# steps counter
	li	$t4,0	# initializes remainder

	li	$t6,0xffffffff	# mask
	sllv	$t6,$t6,$a2
	not	$t6,$t6
	la	$a0,firstl	# first line
	li	$v0,4
	syscall

	sllv	$t5,$t4,$a2	# place the reminder in the hihg half of $t5,$t5: the (Rem,Q) register
	and	$t0,$t0,$t6
	or	$t5,$t5,$t0	# place the dividend in the low half of the (Rem,Q) register
	la	$a3,inival
	jal	pdata
	
divil:	beqz	$t2,done
	addi	$t2,$t2,-1
	addi	$t3,$t3,1
	la	$a0,newline
	li	$v0,4
	syscall
	sll	$t5,$t5,1	# (Rem,Q)<<
	and	$t0,$t5,$t6
	la	$a3,lshift
	jal 	pdata
	srlv	$t4,$t5,$a2	# copy the remainder from (Rem,Q) to $t4
	sub	$t4,$t4,$t1	# Rem=Rem-Div (Remainder=Remainder-Divisor)
	sllv	$t5,$t4,$a2	# place the reminder in the hihg half of $t5,$t5: the (Rem,Q) register
	and	$t0,$t0,$t6
	or	$t5,$t5,$t0	# place the dividend in the low half of the (Rem,Q) register
	la	$a3,rem
	jal	pdata
	bltz	$t4,rltz	# if remainder is less than zero, go to rltz label, else, execute next line
	sllv	$t5,$t4,$a2	# place the reminder in the hihg half of $t5,$t5: the (Rem,Q) register
	and	$t0,$t0,$t6
	or	$t5,$t5,$t0	# place the dividend in the low half of the (Rem,Q) register
	ori	$t5,1		# q0=1
	la	$a3,remg0
	jal	pdata
	j	step3
rltz:	add	$t4,$t4,$t1	# Rem<0,R+D
	sllv	$t5,$t4,$a2	# place the reminder in the hihg half of $t5,$t5: the (Rem,Q) register
	and	$t0,$t0,$t6
	or	$t5,$t5,$t0	# place the dividend in the low half of the (Rem,Q) register
	andi	$t5,0xfffffffe	# q0=0 1110=2+4+8=14=e
	la	$a3,reml0
	jal	pdata
step3:	j	divil

done:	la	$a0,result
	li	$v0,4
	sysCall
	move	$a0,$t4	# to print the remainder
	li	$v0,1
	sysCall
	la	$a0,quot
	li	$v0,4
	syscall
	and	$t0,$t5,$t6	# $t0=quotient
	move	$a0,$t0	# to print the quotient
	li	$v0,1
	syscall
	la	$a0,newline	# to print a \n
	li	$v0,4
	syscall

	addi	$sp,$sp,-4
	lw	$ra,($sp)
	jr	$ra

pdata:	sw	$ra,($sp)
	addi	$sp,$sp,4

	la	$a0,newline
	li	$v0,4
	syscall
	move	$a0,$t3	# print step number
	li	$v0,1
	syscall
	move	$a0,$a3	# to print the action
	li	$v0,4
	syscall
	move	$a0,$t1	# to print the divisor
	move	$a1,$a2	# number of bits
	jal	pbin
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	move	$a0,$t5	# to print Remainder,Quotient
	sll	$a1,$a2,1
	jal	pbin
	
	addi	$sp,$sp,-4
	lw	$ra,($sp)
	jr	$ra