	#+ PLEASE DO NOT MODIFY: Default section
	#+ ------------------------------------------

.data

#test_neighbor_header: .asciiz "\nPos\toben\tlinks\tunten\trechts\n---\t----\t-----\t-----\t------\n"
test_neighbor_header: .asciiz "\nPos\tabove\tleft\tbelow\tright\n---\t-----\t----\t-----\t-----\n"
.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:   
	li $v0, SYS_PUTSTR
	la $a0, test_neighbor_header
	syscall
	
	move $s0, $zero

test_neighbor_loop_position:
	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	move $s1, $zero

test_neighbor_loop_direction:
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	jal neighbor
	
	move $a0, $v0   
	li $v0, SYS_PUTINT
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	addi $s1, $s1, 1
	blt $s1, 4, test_neighbor_loop_direction

	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	addi $s0, $s0, 1
	blt $s0, 64, test_neighbor_loop_position

	li $v0, SYS_EXIT
	syscall

	#+ BITTE 
	#+ -------------------------------------------------------------

	# V
	# N
	# M
	
	#+ the implementation here 
	#+ -----------------

neighbor:	addi $sp,$sp,-12	# making space on the stack
	sw $s0,8($sp)	# storing $s0 on the stack to preserve it's previous value
	sw $s1,4($sp)	# storing $s1 on the stack to preserve it's previous value
	sw $ra,($sp)	# storing $ra on the stack in case of another execution of jal inside neighbor

	# EXTRACTING X AND Y FROM POS ($s0)
	andi $s0,$a0,7	# $a0 and 111 to get 3 last bits of $a0 on $s0 (X)
	srl $s1,$a0,3	# roll bits 5,4 and 3 from $a0 to 2, 1 and 0 positions, respectively and store on $s1 (Y)

	# RETURN -1 OR INDEX
	beq $a1,$0,above	# if direction ($a1) is 0 jump to above label
	beq $a1,1,left		# if direction ($a1) is 1 jump to left label
	beq $a1,2,below		# if direction ($a1) is 2 jump to below label
	beq $a1,3,right		# if direction ($a1) is 3 jump to right label
above:	beq $s1,$0,ret_1	# if Y ($s1) is 0, jump to ret_1 label to return -1
	addi $s1,$s1,-1		# Y = Y -1 (above)
	j retind		# else, jump to retind label to return the index
left:	beq $s0,$0,ret_1	# if X ($s0) is 0, jump to ret_1 label to return -1
	addi $s0,$s0,-1		# X = X -1 (left)
	j retind		# else, jump to retin label to return the index
below:	beq $s1,7,ret_1		# if Y ($s1) is 7, jump to ret_1 label to return -1
	addi $s1,$s1,1		# Y = Y + 1 (below)
	j retind		# else, jump to retind label to return the index
right:	beq $s0,7,ret_1		# if X ($s0) is 7, jump to ret_1 label to return -1
	addi $s0,$s0,1		# X = X + 1 (right)
	j retind		# else, jump to retind label to return the index
ret_1:	addi $v0,$0,-1		# puts -1 on $v0
	j exit			# jump to exit label
retind:	sll $s1,$s1,3		# $s1=8Y
	add $v0,$s1,$s0		# index = $v0 = $s1 + $s0 = 8Y + X

exit:	lw $ra,($sp)	# loading $ra from stack
	lw $s1,4($sp)	# loading $s1 from stack
	lw $s0,8($sp)	# loading $s0 from stack
	addi $sp,$sp,12	# seting $sp to it's value before neighbor call
	jr $ra
