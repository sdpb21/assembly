#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#	starting point of HW1 MIPS programming part.
#
# CS465-001 F2020 HW1  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME 
# G# 
# NAME 2
# G# 2
#############################################################

#############################################################
# DESCRIPTION OF ALGORITHMS 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
# 1. hexdecimal string to integer value
	# a- $t0 = 0  
	# b- Get a ascii coded hexa decimal digit
	# c- Convert it to corresponding decimal value and save it in $t3
	# d- Left shift $t0 by 4 bits
	# e- Take bitwise OR of $t0 with the $t3
	# f- goto step b- if there are still ascii coded hexa decimal digits that needs to be processed
	# g- $t0 has the converted value
# 2. extract n bits from index start
	# a- $t3 = 0, $t0 has the converted value obtained form Algorithm 1. above
	# b- Subtract starting bit from 31 to find out how much we need to shift left $t0
	# c- shift left $t0 by that amount to bring the first bit to be extracted at MSB position
	# d- shift left $t3 by 1
	# e- Check if the MSB of $t0 is 1
	# f- if it is place 1 in LSB of $t3
	# g- shift left $t0 by 1 to bring the next bit to be extracted at MSB position
	# h- goto d- if not all the bits have been extracted yet
	# i- $t3 has the extracted bit
#############################################################

#############################################################
# Data segment
# 
# Feel free to add more data items
#############################################################
.data
	INPUTMSG: .asciiz "Enter a hexadecimal number: "
	INPUTSTARTMSG: .asciiz "Where to start extraction (31-MSB, 0-LSB)? "
	INPUTNMSG: .asciiz "How many bits to extract? "
	OUTPUTMSG: .asciiz "Input: "
	BITSMSG: .asciiz "Extracted bits: "
	ERROR: .asciiz "Error: Input has invalid digits!"
	EQUALS: .asciiz " = "
	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"
	.align 4
	INPUT: .space 8

#############################################################
# Code segment
#############################################################
.text

#############################################################
# Provided entry of program execution
# DO NOT MODIFY this part
#############################################################
		
main:
	li $v0, 4
	la $a0, INPUTMSG
	syscall	# print out MSG asking for a hexadecimal
	
	li $v0, 8
	la $a0, INPUT
	li $a1, 9 # one more than the number of allowed characters
	syscall # read in one string of 8 chars and store in INPUT
	
#############################################################
# END of provided code that you CANNOT modify 
#############################################################
	
	li $v0, 4
	la $a0, NEWLINE
	syscall			# print a new line					

##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################

	li $t0, 0	# $t0 will store the converted value
	li $t1, 8	# Hexadecimal string character counter
	la $t2, INPUT
conversion_loop:
	lbu $t3, ($t2)			# get a hexadecimal string character
	blt $t3, '0', report_error	# report error if ascii character is less than '0'
	ble $t3, '9', decimal_digit	# if its a ascii coded decimal digit, convert it to its corresponding decimal value
	blt $t3, 'A', report_error	# report error if ascii character is less than 'A'
	bgt $t3, 'F', report_error	# report error if ascii character is less than 'F'
	sub $t3, $t3, 'A'		# convert the current ascii coded hexadecimal digit that is greater than 9 by first subtracting ascii code of 'A' from it 
	add $t3, $t3, 10		# and then add 10 to it
	b continue			
decimal_digit:
	sub $t3, $t3, '0'		# convert the current ascii coded decimal digit to its corresponding decimal value
continue:
	sll $t0, $t0, 4			# shift the already placed hex digits to left
	or $t0, $t0, $t3		# place the current hexa decimal digit in $t0
	addi $t2, $t2, 1		# move on to the next hexadecimal string character
	addi $t1, $t1, -1		# decrement loop counter
	bnez $t1, conversion_loop	# keep processing characters untill all of them get processed	
	b report_value			# print the converted value
report_error:
	li $v0, 4
	la $a0, ERROR
	syscall				# print error message
	b exit				# and exit
report_value:

#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################

	li $v0, 4
	la $a0, OUTPUTMSG
	syscall			# print the message "Input: "
	li $v0, 34
	move $a0, $t0
	syscall			# print the converted numeric value in hexadecimal	
	li $v0, 4
	la $a0, EQUALS
	syscall			# print out message " =  "
	li $v0, 36
	move $a0, $t0
	syscall			# print the converted numeric value as unsigned int
	li $v0, 4
	la $a0, NEWLINE
	syscall			# print a new line

#############################################################
# Add your code here to get two integers: start and n
#############################################################

	li $v0, 4
	la $a0, INPUTSTARTMSG
	syscall			# print out MSG asking "Where to start extraction (31-MSB, 0-LSB)? "
	li $v0, 5
	syscall			# get a starting bit no 
	move $t1, $v0		# save it in $t1
	li $v0, 4
	la $a0, INPUTNMSG
	syscall			# print out MSG asking "How many bits to extract?  "
	li $v0, 5
	syscall			# get no of bits 
	move $t2, $v0		# save it in $t2
	
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

	li $t3, 0		# $t3 will store the extracted value
	li $t4, 31
	sub $t4, $t4, $t1	# Subtract starting bit from 31 to find out how much we need to shift left the converted value 
	sllv $t0, $t0, $t4 	# shift left the converted value by that amount to bring the first bit to be extracted at MSB position
extraction_loop:		# Now we need n characters starting from MSB
	sll $t3, $t3, 1		# by default, place 0 in LSB of $t3
	bgez $t0, append_zero	# Check if the MSB is one
	or $t3, $t3, 1		# if it is place 1 in LSB of $t3
append_zero:			
	sll $t0, $t0, 1		# bring the next bit to be extracted at MSB position
	addi $t2, $t2, -1	# decrement loop counter
	bnez $t2, extraction_loop # keep on extracing untill all have been extracted	
	li $v0, 4
	la $a0, BITSMSG
	syscall			# print out "Extracted buts: "
	li $v0, 34
	move $a0, $t3
	syscall			# print the extracted value in hexadecimal
	li $v0, 4
	la $a0, EQUALS
	syscall			# print out message " =  "
	li $v0, 36
	move $a0, $t3
	syscall			# print the extracted value in decimal
	li $v0, 4
	la $a0, NEWLINE
	syscall			# print a new line
	
#############################################################
# Optional exit 
#############################################################
exit:
	li $v0, 10
	syscall

# Example input	
# H: 0x 0   1    2    3    4    5    6    A
# B: 0000 0001 0010 0011 0100 0101 0110 1010
#    31   27   23   19   15   11   7    3  0 (index)
