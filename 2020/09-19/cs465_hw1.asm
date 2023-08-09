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
	la	$t1,INPUT		# loads on $t1 register the first character string address where introduced number is located
	lbu	$t0,($t1)		# reads the first character of string and stores it on $t0 register
validate: li	$t2,'\n'		# loads the value of '\n' character on $t2 register
	beq	$t0,$t2,report_value	# if character stored on $t0 register is '\n', means the end of string and must jump to report_value label
	li	$t2,'\0'		# loads the value of '\0' character on $t2 register
	beq	$t0,$t2,report_value2	# if character stored on $t0 register is '\0', means the end of string and must jump to report_value2 label
	li	$t2,'F'			# loads the value of 'F' character on $t2 register
	bgtu	$t0,$t2,error		# if character on $t0 is placed after 'F' on ASCII code, jumps to error label to print error message
	li	$t2,'0'			# loads the value of '0' character on $t2 register
	bltu	$t0,$t2,error		# if character on $t0 is placed before '0' on ASCII code, jumps to error label to print error message
	li	$t2,'A'			# loads the value of 'A' character on $t2 register
	bgeu	$t0,$t2,hexnu		# if character on $t0 is placed after 'A' on ASCII code, jumps to hexnu label to validate the next character
	li	$t2,'9'			# loads the value of '9' character on $t2 register
	bleu	$t0,$t2,hexnu		# if character on $t0 is placed before '9' on ASCII code, jumps to hexnu label to validate the next character
	j	error			# if $t0<'A' and $t0>'9' jump to error label
	
hexnu:	addi	$t1,$t1,1		# go to next character address
	lbu	$t0,($t1)		# loads on $t0 register the byte on address stored on $t1 register
	j	validate		# jump to validate label
##############################################################
# Add your code here to calculate the numeric value from INPUT 
##############################################################
report_value2: li $v0,4		# to print a '\n' in case of introducing 8 characters
	la	$a0,NEWLINE
	syscall
report_value:
	la	$t0,INPUT	# copy to $t0 the first element address of hexadecimal number string
	li	$t1,0		# copy zero to $t1 register

convL:	lb	$t2,($t0)	# copy to $t2 register the character pointed by address in $t0
	li	$t3,'9'		# copy '9' to $t3 register for comparing on next line
	ble	$t2,$t3,let9	# go to let9 label if $t2<=$t3
	addi	$t2,$t2,-55	# conversion from hexadecimal numbers from A to F to his decimal equivalent
contC:	blt	$t2,$zero,print	# if last converted character is less than 0, conversion is complete and number is ready to be printed
	li	$t4,16		# copy 16 to $t4 register
	mul	$t1,$t1,$t4	# multiply 16 by accumulated value in $t1 register
	add	$t1,$t1,$t2	# add the last hexadecimal converted character to the accumulated value in $t1 register
	addi	$t0,$t0,1	# increment in 1 to access the next character of hexadecimal string
	j	convL		# jump to convL to repeat the conversion for the next character

let9:	addi	$t2,$t2,-48	# conversion from hexadecimal numbers from 0 to 9 to his decimal equivalent
	j	contC		# jump to contC label to continue with conversion

#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################
print:	li $v0, 4		# code to print a string
	la $a0, OUTPUTMSG	# loads on $a0 register the address of null-terminated string to print
	syscall			# executes the system service
	li	$v0,34		# to print the result in hexadecimal format
	move	$a0,$t1		# move the integer to $a0
	syscall			# print
	li	$v0,4		# to print the " = " string
	la	$a0,EQUALS	# loads to $a0 register the " = " string address
	syscall			# print the string
	li	$v0,36		# to print the integer as unsigned integer
	move	$a0,$t1		# move the integer to $a0
	syscall			# print
	li $v0,4		# to print a '\n'
	la	$a0,NEWLINE	# load the address of null-terminated string on $a0 register
	syscall			# executes system service

#############################################################
# Add your code here to get two integers: start and n
#############################################################

	li $v0, 4		# code to print a string
	la $a0, INPUTSTARTMSG	# loads on $a0 register the address of null-terminated string to print ("Where to start extraction (31-MSB, 0-LSB)? ")
	syscall			# print out MSG asking for which byte to extract
	li	$v0,5		# code for read integer service
	syscall			# execute the system service
	move	$t0,$v0		# copy to $t0 register the readed integer
	li	$v0,4		# code for print string service
	la	$a0,INPUTNMSG	# load on $a0 register address of null-terminated string to print
	syscall			# execute the system service
	li	$v0,5		# code for read integer service
	syscall			# execute the system service
	move	$t2,$v0		# copy to $t2 register the readed integer
		
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

	li	$v0,4		# code to print a string
	la	$a0,BITSMSG	# copy to $a0 the address of null-terminated string to print "Extracted bits: "
	syscall			# execute the system service
	li	$t3,31		# copy 31 to $t3 register
	subu	$t0,$t3,$t0	# 31-START--->$t0
	sllv	$t1,$t1,$t0	# shift left $t0 bits the value on $t1 and copy the shifted left value on $t1 register
	addi	$t2,$t2,-1	# decrement in 1 the number of bits to extract
	subu	$t2,$t3,$t2	# $t2=31-$t2 (bits to shift right for next instruction)
	srlv	$t1,$t1,$t2	# shift right $t2 bits the value on $t1 and copy the shifted right value on $t1 register
	li	$v0,34		# code to print an integer in hexadecimal format
	move	$a0,$t1		# move to $a0 register the integer to print
	syscall			# execute the system service
	li	$v0,4		# to print the " = " string
	la	$a0,EQUALS	# loads to $a0 register the " = " string address
	syscall			# print the " = " string
	li	$v0,36		# code to print an integer as unsigned integer
	move	$a0,$t1		# move to $a0 register the integer to print
	syscall			# execute the system service

#############################################################
# Optional exit 
#############################################################
exit:	li $v0, 10		# code to exit
	syscall			# execute system service
error:	li	$v0,4		# code to print a string
	la	$a0,ERROR	# load on $a0 register the address of null-terminated string to print ("Error: Input has invalid digits!")
	syscall			# execute system service
	j	exit		# jump to exit label

# Example input	
# H: 0x 0   1    2    3    4    5    6    A
# B: 0000 0001 0010 0011 0100 0101 0110 1010
#    31   27   23   19   15   11   7    3  0 (index)
