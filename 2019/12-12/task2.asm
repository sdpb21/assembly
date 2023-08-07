.data
maze: .space 256
buffer: .space 64	#64 bytes to store the contents of the file to read
fin: .asciiz "maze.txt"      # filename for input
message: .asciiz "YOU WIN!!!! CONGRATULATIONS!!!"

.text
main:
	jal createMaze
	li $s7,0xFFFF0000	# get the base address of MMIO area
	li $t1,1	# initial player row
	li $t2,6	# initial player column
keyWait:
	lw $t0,($s7)	# get control register on $t0
	andi $t0,$t0,1	# isolate ready bit
	beq $t0,$zero,keyWait	# is key available? if no, repeat
	lbu $a0,4($s7)	# get key valueS

	beq $a0,'z',ze	#jump to ze label if $a0=z UP
	beq $a0,'s',es	#jump to es label if $a0=s DOWN
	beq $a0,'q',qu	#jump to qu label if $a0=q LEFT
	beq $a0,'d',di	#jump to di label if $a0=d RIGHT
	beq $a0,'x',ex	#jump to ex label if $a0=x EXIT

cont:	j keyWait

ex:	la $a0,message	# to print the victory message in the Run I/O
	li $v0,4
	syscall		# print the victory message
	li $v0,10
	syscall	#exit main
	#UP
ze:	addi $a2,$t1,-1	#substract a row to go UP, $a2 new row
	move $a3,$t2	# new column is the same column
	move $a0,$t1	# parameter to the function, actual row
	move $a1,$t2	# parameter to the function, actual column
	jal updatePosition
	move $t1,$v0	# store the row value
	move $t2,$v1	# store the column value
	j cont
	#DOWN
es:	move $a0,$t1	# parameter to the function, actual row
	move $a1,$t2	# parameter to the function, actual column
	addi $a2,$t1,1	# add a row to go down to new row
	move $a3,$t2	# the new column is the same column
	jal updatePosition
	move $t1,$v0	# store the row value
	move $t2,$v1	# store the column value
	j cont
	#LEFT
qu:	move $a0,$t1	# parameter to the function, actual row
	move $a1,$t2	# parameter to the function, actual column
	move $a2,$t1	# new row is the same row
	addi $a3,$t2,-1	# substract a column to go to LEFT, new column
	jal updatePosition
	move $t1,$v0	# store the row value
	move $t2,$v1	# store the column value
	j cont
	#RIGHT
di:	move $a0,$t1	# parameter to the function, actual row
	move $a1,$t2	# parameter to the function, actual column
	move $a2,$t1	# new row is the same row
	addi $a3,$t2,1	# add a column to go to the RIGHT, new column
	jal updatePosition
	move $t1,$v0	# store the row value
	move $t2,$v1	# store the column value
	j cont
	
createMaze:
	addi $sp,$sp,-20#making space in the stack to store some register values
	sw $a0,($sp)	#storing $a0, $a1, $a2 and $s0
	sw $a1,4($sp)
	sw $a2,8($sp)
	sw $s0,12($sp)
# Open file for reading
li   $v0, 13       # system call for open file
la   $a0, fin      # input file name
li   $a1, 0        # flag for reading
li   $a2, 0        # mode is ignored
syscall            # open a file 
move $s0, $v0      # save the file descriptor 

# reading from file just opened
li   $v0, 14       # system call for reading from file
move $a0, $s0      # file descriptor 
la   $a1, buffer   # address of buffer to store the contents of the file
li   $a2,  128  # hardcoded buffer length
syscall            # read from file

	li $t0,0	#to count bytes
	li $t3,0	#to count words
loop:	lb $t1,buffer($t0)# load elements from the maze to $t1
	beq $t1,'w',blue
	beq $t1,'p',black
	beq $t1,'s',yell
	beq $t1,'u',gree

lb1:	addi $t0,$t0,1	#next byte
	addi $t3,$t3,4	#next word
	bne $t0,64,loop	#

# close the file
li $v0,16
move $a0,$s0	#file descriptor saved in $s0 move to $a0
syscall		#execute the file close

	lw $a0,($sp)	#returning values stored in the stack
	lw $a1,4($sp)
	lw $a2,8($sp)
	lw $s0,12($sp)
	addi $sp,$sp,20	#returning the stack pointer value before the function call
	jr $ra		#jump to the next line where createMaze was called

blue:	li $t2,0x000000FF#loading blue hexadecimal value
	sw $t2,maze($t3)#storing $t2 to print blue
	j lb1		#jump to the last program lines
black:	li $t2,0x00000000
	sw $t2,maze($t3)
	j lb1
yell:	li $t2,0x00FFFF00
	sw $t2,maze($t3)
	j lb1
gree:	li $t2,0x0000F000
	sw $t2,maze($t3)
	j lb1

updatePosition:
	#outputs $v0 row index and $v1 column index
	addi $sp,$sp,-8
	sw $ra,($sp)
	#$a0 and $a1 are actual position
	#$a2 and $a3 are possible new position
	jal getDirection#$v0 contains the address of the ($a2,$a3) element of maze
	lw $s0,($v0)	#load on $s0 the element on $v0 direction
	move $v0,$a0	#to return actual row position in case of movement not allowed
	move $v1,$a1	#to return actual column position in case of movement not allowed
	bne $s0,0,note	#jump if element in maze is not black (passage) else execute next lines
	#UPDATE THE PIXEL
	jal getDirection#$v0 contains the address of the ($a2,$a3) element of maze
	li $s1,0x00FFFF00# to paint in yellow the new pixel
	sw $s1,($v0)	# store yellow on $v0 direction, the new pixel
	move $s2,$a2	# move $a2 to $s2 to preserve the $a2 value
	move $s3,$a3	# move $a3 to $s3 to preserve the $a3 value
	move $a2,$a0	# old index row to $a2
	move $a3,$a1	# old index column to $a3
	jal getDirection# to get the direction of the old pixel to paint it black
	li $s1,0x00000000# to paint in black the old pixel
	sw $s1,($v0)	# store black on $v0 direction, the old pixel
	move $v0,$s2	#return new row position, movement allowed
	move $v1,$s3	#return new column position, movement allowed

note:	lw $ra,($sp)
	addi $sp,$sp,8
	jr $ra	#jump to the next line where upadtePosition was called

getDirection:
	addi $sp,$sp,-4
	sw $s0,($sp)

	#$a2 is row index and $a3 is column index
	la $s0,maze	#put on $s0 maze first element direction
	mul $v0,$a2,8	#multiply the row index of desired element and the number of columns
	add $v0,$v0,$a3	#add the last multiplication and the column index
	mul $v0,$v0,4	#multiply the last operation and the size in bytes of a word because each matrix element is a word
	add $v0,$s0,$v0	#$v0=baseAddr+(rowIndex*colsize+colIndex)*dataSize    $s0=baseAddr

	lw $s0,($sp)
	addi $sp,$sp,4
	jr $ra	#jump to the next line where getDirection was called