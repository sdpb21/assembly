.data
ITERATIVE_RESULT:	.asciiz	"\n\nResult of A*B by the refined iterative multiplication --> "
SEPARATOR:	.asciiz	" "
newline:.asciiz	 "\n"
firstl:	.asciiz	"Step\tAction\t\tMultiplicand\tProduct/Multiplier"
inival:	.asciiz	"\tInitial Vals\t"
tab:	.asciiz	"\t"
lsb0:	.asciiz	"\tlsb=0, no op\t"
rshift:	.asciiz	"\tRshift Mplier\t"
prod:	.asciiz	"\tProd=Prod+Mcand\t"
.text
.globl ex.3.13
ex.3.13:sw	$ra,($sp)
	addi	$sp,$sp,4
	
  	move 	$t0,$a0	# t0 = multiplicand
  	move 	$t6,$a1 # t6 = multiplier
	move	$t7,$a2	# number of bits is assumed to be 32 for now
	jal	display
	li	$t3,0	# steps counter

	la	$a0,firstl	# first line
	li	$v0,4
	syscall
	la	$a3,inival	# to print the initial values
	jal	pdata

	#li	$t1,32	# loop count
	move	$t1,$t7	# counter
	li	$t2,1
	#sll	$t2,$t2,31	# t2 = 0b 1000 0000 0000 0000 0000 0000 0000 0000
	addi	$t7,$t7,-1
	sllv	$t2,$t2,$t7

	li	$t5,0	# product stored in $t5 and $t6
loop:	beq	$t1,$0,done	#  if $t1==0 quit loop
	la	$a0,newline
	li	$v0,4
	sysCall
	addi	$t3,$t3,1	# increment the steps counter
	addi	$t1,$t1,-1	#   t1 --;
	andi	$t4,$t6,1	#  t4  = right most bit of multiplier t6
	beq	$t4,$0,EVEN	#  if t4 == 0, then t6 is even and jump to EVEN

ODD:	addu	$t5,$t5,$t0	#  otherwise, t1 is odd, so we do t5 += t0 (multiplicand)
	la	$a3,prod	# to print a prod+mcand action
	jal	pdata
	j	aprod		# jump to aprod (after product) label

EVEN :	la	$a3,lsb0	# to print no operation
	jal	pdata
aprod:	andi	$t4,$t5,1	#  t4  = right most bit of t5
	srl	$t5,$t5,1	#  shift t5 1 bit to the right
	srl	$t6,$t6,1	#  shift t6 1 bit to the right
	la	$a3,rshift	# to print a rshift action
	bnez	$t4,t4nz	# if $t4 is not 0, go to t4nz label
	jal	pdata
	beq	$t4,$0,loop	#  if $t4==0 go back to loop
t4nz:	or	$t6,$t6,$t2     #  leftmost bit of t6 set to 1
	jal	pdata
	j	loop

done:	la	$a0,ITERATIVE_RESULT
	li	$v0,4
	sysCall
	sllv	$t5,$t5,$a2
	or	$t6,$t5,$t6
	and	$t5,$t5,$0
	move	$a0,$t6	# print out $t6, the result by the iterative addition
	li	$v0,1
	sysCall
	la	$a0,newline	# to print a \n
	li	$v0,4
	syscall

RETURN:	addi	$sp,$sp,-4
	lw	$ra,($sp)
	jr	$ra
#########################################################
pdata:	sw	$ra,($sp)
	addi	$sp,$sp,4

	la	$a0,newline	# to print a \n character
	li	$v0,4
	syscall
	move	$a0,$t3	# to print the step number
	li	$v0,1
	syscall
	move	$a0,$a3	# to print the action
	li	$v0,4
	syscall
	move	$a0,$t0	# to print the Multiplicand in binary format
	move	$a1,$a2	# number of bits
	jal	pbin
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	la	$a0,tab	# to print a \t character
	li	$v0,4
	syscall
	move	$a0,$t5	# to print Product
	jal	pbin
	move	$a0,$t6	# to print the multiplier
	jal	pbin

	addi	$sp,$sp,-4
	lw	$ra,($sp)
	jr	$ra
