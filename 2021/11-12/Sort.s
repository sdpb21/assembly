.data 
quest:	.asciiz	"\nHow many numbers do you want to enter? "
ints:	.asciiz	"\nEnter the integer #"
enter:	.asciiz	"\nYou have entered: "
sorted:	.asciiz	"\nHere is the sorted list in ascending order: "
.align 2
arr:	.space	512
.text 
main:	addi $v0,$0,4	# $v0=4 to print a null-terminated character string
	la $a0,quest	# address of quest string to $a0
	syscall		# print "How many numbers do you want to enter?"

	addi $v0,$0,5	# $v0=5 to read an integer from user
	syscall		# wait for the integer and return it on $v0

	beq $v0,$0,exit	# empty array, exit
	add $t0,$0,$v0	# copy $v0 to $t0
	add $t1,$0,$0	# $t1=0 (to count the integers introduced)
	la $t2,arr	# memory space labeled arr address to $t2
lab1:	addi $v0,$0,4	# $v0=4 to print a null-terminated character string
	la $a0,ints	# address of ints string to $a0
	syscall		# print "Enter the integer #"
	addi $t1,$t1,1	# increment the integers counter by one
	addi $v0,$0,1	# $v0=1 to print an integer number
	add $a0,$0,$t1	# integer to be printed to $a0 ($t1)
	syscall		# print the integer stored on $t1 register
	addi $v0,$0,11	# $v0=11 to print a character
	addi $a0,$0,' '	# character to print to $a0
	syscall		# print a space
	addi $v0,$0,5	# $v0=5 to read an integer from user
	syscall		# wait for the integer and return it on $v0
	sw $v0,($t2)	# store integer on memory space labeled arr
	addi $t2,$t2,4	# increments $t2 by 4 for the next word (integer)
	beq $t1,$t0,lab2# if $t0 and $t1 are equals branch to lab2 label
	j lab1		# jump to lab1 label

lab2:	addi $v0,$0,4	# $v0=4 to print a null-terminated character string
	la $a0,enter	# enter string address to $a0
	syscall		# print "You have entered: "
	la $t2,arr	# memory space labeled arr address to $t2
	add $t1,$0,$0	# $t1=0 (to count the integers introduced)
lab3:	addi $t1,$t1,1	# increment the integers counter by one
	lw $a0,($t2)	# load word on $t2 address to $a0 (an array element)
	addi $v0,$0,1	# $v0=1 to print an integer number
	syscall		# print the array element on $t2 address
	addi $v0,$0,11	# $v0=11 to print a character
	addi $a0,$0,' '	# character to print to $a0
	syscall		# print a space
	addi $t2,$t2,4	# increments $t2 by 4 for the next word (integer)
	beq $t1,$t0,lab4# if $t0 and $t1 are equals branch to lab4 label
	j lab3		# jump to lab3 label

lab4:	add $a0,$0,$t0 	# number of array elements to $a0
	la $a1,arr	# arr array address to $a1

sort:	li $t7,0 	# flag to indicate a swap
swLoop:	add $t6,$0,$a0	# array elements number to $t6
	addi $t6,$t6,-1	# last array element index
	bgtz $t7,print 	# when array is sorted go to print label
	li $t7,1	# to indicate no swap, array sorted
loopCount:
lab5:	beq $t6,$0,swLoop	# if $t6=0 repeat all again from swLoop label
	addi $t5,$t6,-1	# t5 is t6- 1 to get length - 2 value
	mul $t0,$t6,4	# distance in words from $a1 to $t0
	mul $t1,$t5,4	# distance in words from $a1 to $t1 (previous array element)
	add $t2,$t0,$a1	# an element address in the array to $t2
	add $t3,$t1,$a1	# previous to $t2 element address in the array, to $t3
	lw $t4,($t2)	# load word at $t2 address in $t4
	lw $t5,($t3)	# load previous array word, to $t5
	blt $t4,$t5,swap# if $t4 is less than $t5(previous), swap them
	addi $t6,$t6,-1	# previous element index
	j lab5		# jump to lab5 label
	
swap:	sw  $t5,($t2)	# store word on $t5 in $t2 address
	sw  $t4,($t3)	# store word on $t4 in $t3 address
	addi $t6,$t6,-1	# previous element index
	li $t7,0	# to indicate there was a swap
	j lab5		# jump to lab5 label

print:	add $t0,$0,$a0	# array elements number to $t0
	addi $v0,$0,4	# $v0=4 to print a null-terminated character string
	la $a0,sorted	# sprted string address to $a0
	syscall		# print "Here is the sorted list in ascending order: "
	la $t2,arr	# memory space labeled arr address to $t2
	add $t1,$0,$0	# $t1=0 (to count the integers introduced)
lab6:	addi $t1,$t1,1	# increment the integers counter by one
	lw $a0,($t2)	# load word on $t2 address to $a0 (an array element)
	addi $v0,$0,1	# $v0=1 to print an integer number
	syscall		# print the array element on $t2 address
	addi $v0,$0,11	# $v0=11 to print a character
	addi $a0,$0,' '	# character to print to $a0
	syscall		# print a space
	addi $t2,$t2,4	# increments $t2 by 4 for the next word (integer)
	beq $t1,$t0,exit# if $t0 and $t1 are equals branch to exit label
	j lab6		# jump to lab6 label

exit:	li $v0,10	# stop program
	syscall 
