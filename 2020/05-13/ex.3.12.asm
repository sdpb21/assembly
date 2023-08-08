.data
result:	.asciiz	"\nResult by iterative addition --> "
prompt:	.asciiz	"Enter a number: "
SEPARATOR:	.asciiz	" "
newline:	.asciiz	"\n"
firstl:	.asciiz	"Step\tAction\t\tMultiplier\tMultiplicand\tProduct"
inival:	.asciiz	"\tInitial Vals\t"
tab:	.asciiz	"\t"
lsb0:	.asciiz	"\tlsb=0, no op\t"
lshift:	.asciiz	"\tLshift Mcand\t"
rshift:	.asciiz	"\tRshift Mplier\t"
prod:	.asciiz	"\tProd=Prod+Mcand\t"
.text
.globl	pbin
.globl	ex.3.12
ex.3.12:addi	$sp,$sp,-4
	sw	$ra,($sp)

	move 	$t0,$a0	# A = multiplicand
	move 	$t1,$a1	# B = multiplier
	move $t7,  $a2    # number of bits is assumed to be 32 for now
	li	$t3,0	# initialization of steps counter

	li	$t6,0	# operation result

	la	$a0,firstl	# first line
	li	$v0,4
	syscall
	# print data
	la	$a3,inival
	jal	pdata

loop:	beq	$t3,$a2,done	# if $t1==0 quit loop
	addi	$t3,$t3,1	# increment the counter
	
	# xxx the following uses andi and 1 to check if  t1 is 1 or 0
	andi	$t4,$t1,1	# xxx t4  = right most bit of multiplier t1. 
	beq	$t4,$0,ZERO	# xxx if t4 == 0, then jump to ZERO

ONE:	addu	$t6,$t6,$t0	# xxx otherwise, t1 is one, so we do t6 += t0 (multiplicand)
	la	$a3,prod
	jal	pdata		# prod=prod+Mcand
	j	shifts		# jump to execute the shifts
ZERO :	la	$a3,lsb0
	jal	pdata		# lsb=0
shifts:	sll	$t0,$t0,1	# xxx shift t0 (multiplicand) 1 bit to the left
	la	$a3,lshift
	jal	pdata		# print left shift
	srl	$t1,$t1,1	# xxx shift t1 (multiplier) 1 bit to the right
	la	$a3,rshift
	jal	pdata		# print right shift
	j	loop

done:	la	$a0,result
	li	$v0,4
	syscall
	move	$a0,$t5		# print out $t5, the result by the iterative addition
	li	$v0,1
	syscall

	la	$a0,SEPARATOR
	li	$v0,4
	syscall

	move	$a0,$t6		# print out $t6, the result by the iterative addition
	li	$v0,1
	syscall
	la	$a0,newline
	li	$v0,4
	syscall

RETURN:	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra
###########################################
# pbin: to print in binary format
# parameters:
# $a0: integer to print
# $a1: number of bits to print
###########################################
pbin:	addi	$sp,$sp,-4
	sw	$ra,($sp)

	move	$s0,$a0		# move to $s0 integer to print in binary format
	move	$s1,$a1		# move to $s1 the number of bits to print
	move	$s2,$s0		# save $s0 to $s2
nxtbit:	addi	$s1,$s1,-1	# countdown
	bltz	$s1,pbend	# if number of bits is less or equal than 0, do not print
	srlv	$s0,$s0,$s1	# 
	andi	$s0,$s0,1	# load bit 0 in $s0
	beqz	$s0,prnt0	# if bit is 0, go to prnt0 (print 0) label
	li	$a0,1		# else, print 1
	j	p_int
prnt0:	li	$a0,0		# puts 0 in $a0 to print 0
p_int:	li	$v0,1
	syscall			# prints the integer on $a0
	move	$s0,$s2		# move the value in $s2 to $s0
	j	nxtbit		# jump to nxtbit label to print the next bit

pbend:	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr $ra
###########################################
# pdata: to print the data in bits
# parameters:
# $a3: address of the characters array with the action
###########################################
pdata:	addi	$sp,$sp,-4
	sw	$ra,($sp)

	la	$a0,newline	# to print a \n character
	li	$v0,4
	syscall
	move	$a0,$t3	# to print the step number
	li	$v0,1
	syscall
	move	$a0,$a3	# action
	li	$v0,4
	syscall
	move	$t7,$a2	# move to $t7 the number of bits again
	move	$a0,$t1	# to print the multiplier in binary format
	move	$a1,$t7	# number of bits to print
	jal	pbin	# jump to print on binary format function
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	move	$a0,$t0	# to print the multiplicand
	sll	$t7,$t7,1	# $t7x2
	move	$a1,$t7	# number of bits to print
	jal	pbin
	la	$a0,tab	# print a \t character
	li	$v0,4
	syscall
	move	$a0,$t6	# to print the product
	jal	pbin	#

	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr $ra
##################################
