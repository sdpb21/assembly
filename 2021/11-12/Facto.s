.data
input:	.asciiz	"\nIntroduce an integer number: "
result:	.asciiz	"! = "
negat:	.asciiz	"\nError: negative factorial is not defined.\n"
overf:	.asciiz	"\nError: out of boundary.\n"
.text
main:
	la $a0,input	# load input string address in $a0
	li $v0,4	# $v0=4 to print null-terminated character string
	syscall		# print "Introduce an integer number: "

	li $v0,5	# $v0=5 to read an integer number from the user
	syscall		# wait for the integer number and returns it on $v0

	bltz $v0,error1	# if introduced integer is negative branch to error1 label
	bgt $v0,12,error2	# if introduced integer is greater than 12 branch to error2 label

	add $a0,$0,$v0	# $a0=$v0 parameter for the factorial procedure
	add $t0,$0,$v0	# store the returned value ($v0) in $t0
	jal fact	# jump to factorial procedure and store the next instruction address in $ra
	add $t1,$0,$v0	# store the returned value ($v0) in $t1

	li $v0,1	# $v0=1 to print a 32 bit integer number
	add $a0,$0,$t0	# copy integer to print in $a0
	syscall		# print the introduced integer

	la $a0,result	# load result string address in $a0
	li $v0,4	# $v0=4 to print a null-terminated character string
	syscall		# print the "! = " string

	li $v0,1	# $v0=1 to print a 32 bit integer number
	add $a0,$0,$t1	# copy the integer to print in $a0
	syscall		# print the factorial result
	j exit		# jump to exit label to finish

error1:	la $a0,negat	# load negat string address in $a0
	li $v0,4	# $v0=4 to print a null-terminated character string
	syscall		# print "Error: negative factorial is not defined."
	j exit		# jump to exit label to finish

error2:	la $a0,overf	# load overf string address in $a0
	li $v0,4	# $v0=4 to print a null-terminated character string
	syscall		# print "Error: out of boundary." message on screen

exit:	li $v0,10	# $v0=10 to stop program from running
	syscall		# stop program

fact:	addi $sp,$sp,-8	# make space on the stack for 2 words
	sw $s0,($sp)	# store $s0 on stack
	sw $ra,4($sp)	# store $ra on stack

	bne $a0,$0,decr	# if $a0 not equal to zero, decrement $a0
	addi $v0,$0,1	# to return 1 when the parameter $a0 is zero
	j end		# jump to end label to finish the factorial procedure

decr:	add $s0,$0,$a0	# copy $a0 to $s0
	addi $a0,$a0,-1	# decrement $a0 in 1
	jal fact	# jump to recursive procedure fact
	multu $s0,$v0	# execute x*(x-1)!
	mflo $v0	# store the x(x-1)! result on $v0

end:	lw $ra,4($sp)	# load $ra from stack
	lw $s0,($sp)	# load $s0 from stack
	addi $sp,$sp,8	# move stack pointer 2 words up
	jr $ra		# jump to address stored on $ra register