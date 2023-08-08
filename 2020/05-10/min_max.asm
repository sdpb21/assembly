.data
table:	.word	3,-1,6,5,7,-3,-15,18,2
N:	.word	9
#table:	.word	3
#N:	.word	1
minmsg:	.asciiz	"minimum: "
maxmsg:	.asciiz "maximum: "
slashn:	.asciiz	"\n"
.text
# $a0: minimum or maximum value
# $t1: to store the memory address of first element in table or the address of the constant that indicates the number of elements of table array
# $t2: to load the elements of table
# $t3: flag to indicate that $t2 is less or greater than $t0
# $t4: to control the number of iterations of the loop to find the minimum or maximum
# $t5: counter for the number of iterations
	li $v0,4		# to print minimum message
	la $a0,minmsg
	syscall
	li $a0,0x7FFFFFFF	# first minimum value is a big value
	la $t1,N		# address of the constant that indicates the number or elements of the table
	lw $t4,($t1)		# load on $t4 the number of the table elements
	la $t1,table		# address of first element of table
	li $t5,0		# to initilize the counter of iterations
nextel:	beq $t4,$t5,end1	# if the counter of iteration is equal to the number of elements in table, go to end1 label
	lw $t2,($t1)		# load on $t2 the element of table at $t1 address
	addi $t1,$t1,4		# increment the address to access to next word
	addi $t5,$t5,1		# to increment the counter
	slt $t3,$t2,$a0		# if the value of the table at address $t1 is less than the minimum value, sets $t3
	beqz $t3,nextel		# if $t2 is not less than $a0 go to nextel (next element) label
	move $a0,$t2		# $t2 is the new minimum
	j nextel		# go to nextel label

end1:	li $v0,1		# to print an integer
	syscall

	li $v0,4		# to print \n
	la $a0,slashn
	syscall

	li $v0,4		# to print maximum message
	la $a0,maxmsg
	syscall
	li $a0,0x80000000	# first maximum value is a big negative value
	la $t1,table		# address of first element of table
	li $t5,0		# to initilize the counter of iterations
nexte1:	beq $t4,$t5,end2	# if the counter of iteration is equal to the number of elements in table, go to end2 label
	lw $t2,($t1)		# load on $t2 the element of table at $t1 address
	addi $t1,$t1,4		# increment the address to access to next word
	addi $t5,$t5,1		# to increment the counter
	sgt $t3,$t2,$a0		# if the value of the table at address $t1 is greater than the maximum value, sets $t3
	beqz $t3,nexte1		# if $t2 is not greater than $a0 go to nexte1 (next element 1) label
	move $a0,$t2		# $t2 is the new maximum
	j nexte1		# go to nexte1 label

end2:	li $v0,1		# to print an integer
	syscall

	li $v0,10		# finish
	syscall