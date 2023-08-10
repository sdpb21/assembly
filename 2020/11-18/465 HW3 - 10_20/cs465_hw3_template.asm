#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW3 MIPS programming part.
#		This is the only file you should change and submit.
#
# CS465-001 F2020
# HW3 
#############################################################

#############################################################
# PUT YOUR TEAM INFO HERE
# NAME
# G#
# NAME 2
# G# 2
#############################################################

#############################################################
# DESCRIPTION  
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

#############################################################
# Data segment
#############################################################

.data # Start of Data Items
	INIT_INPUT: .asciiz "How many instructions to process? "
	INSTR_SEQUENCE: .asciiz "Please input instruction sequence: (one per line)\n"
	NEWLINE: .asciiz "\n"

	.align 4
	INPUT: .space 8
	
	

.text
main:
	la $a0, INIT_INPUT
	li $v0, 4
	syscall # Print out message asking for N (number of instructions to process)
	
	li $v0, 5
	syscall # read in Int 
	addi $t1, $v0, 0 
	
	
	la $a0, INSTR_SEQUENCE
	li $v0, 4
	syscall 
	
	li $t0, 0 # loop counter	
	Loop: # Read in N strings
		la $a0, INPUT
		li $a1, 9
		li $v0, 8
		syscall # read in one string and store in INPUT
		###########################################
		# Add your code here to process the input

																																				
		addi $t0, $t0, 1
		blt $t0, $t1, Loop



exit:
	li $v0, 10
	syscall