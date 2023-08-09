.data
array:	.word 5 4 3 2 1		# array
i:	.word 5			# number of array elements
msg:	.asciiz	"The computed result is "
.text
	la	$a0,array	# copy array first element address on $a0
	lw	$a1,i		# copy the number of elements on $a1
	jal	compute		# jump to compute procedure
	move	$t0,$v0		# move compute procedure output ($v0) to $t0 register
	li	$v0,4		# copy 4 to $v0
	la	$a0,msg		# copy msg address to $a0 register
	syscall			# print message pointed by msg on console
	li	$v0,1		# copy 1 on $v0 register
	move	$a0,$t0		# copy the result of compute procedure on $a0
	syscall			# print the result of the compute procedute on the console
	li	$v0,10		# to finish
	syscall

compute: addi	$sp,$sp,-32	# making space on the stack
	sw	$ra,28($sp)	# storing $ra register on the stack
	sw	$s0,24($sp)	# storing $s0 register on the stack
	sw	$s1,20($sp)	# storing $s1 register on the stack

	beq	$a1,1,end	# if $a1==1 jump to end label
	lw	$s0,0($a0)	# load the array element pointed by $a0 address on $s0
	lw	$s1,4($a0)	# load the next array element
	addi	$a0,$a0,4	# store in $a0 the next word address
	addi	$a1,$a1,-1	# decrements the array elements number
	jal	compute		# recursive call to compute procedure
	subu	$s0,$s0,$s1	# get the diference between an array element and the next and copy it to $s0
	abs	$s0,$s0		# copy the absolute value of the diference on $s0 register
	add	$v0,$v0,$s0	# sum the absolute differences between array consecutive elements, sotores it on $v0

end:	lw	$s1,20($sp)	# LIFO, last element stored on the stack must be first in getting out from it
	lw	$s0,24($sp)	# loading $s0 from stack
	lw	$ra,28($sp)	# loading $ra from stack
	addi	$sp,$sp,32	# restoring stack pointer address
	jr	$ra		# jump to the address pointed by $ra
