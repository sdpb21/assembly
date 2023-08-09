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
# 2. extract n bits from index start
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
				
	#li $v0, 4
	#la $a0, INPUT
	#syscall # print out string that read in 
	#li $v0, 4
	#la $a0, NEWLINE
	#syscall	


		
##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################

report_value:
#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################
	li $v0, 4
	la $a0, OUTPUTMSG
	syscall	



#############################################################
# Add your code here to get two integers: start and n
#############################################################

	li $v0, 4
	la $a0, INPUTSTARTMSG
	syscall	# print out MSG asking for which byte to extract

		
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

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