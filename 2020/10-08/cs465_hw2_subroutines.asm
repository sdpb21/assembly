#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW2 MIPS programming part.
#		This is the only file you should change and submit.
#
# Author: Yutao Zhong
# CS465-001 F2020
# HW2  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME
# G#
# NAME 2
# G# 2
#############################################################

#############################################################
# Data segment
#############################################################

.data


#############################################################
# Code segment
#############################################################

.text

#############################################################
# atoi
#############################################################
#############################################################
# DESCRIPTION  
#
# a- $s1 = 8
# b- Get an ascii coded hexa decimal digit
# c- Convert it to corresponding decimal value and save it in $s0
# d- Left shift $s2 by 4 bits
# e- Take bitwise OR of $s2 with the $s0
# f- goto step b- if there are still ascii coded hexa decimal digits that needs to be processed
# g- $s2 has the converted value
#############################################################
		
.globl atoi
atoi:	addi	$sp,$sp,-32		# making space on the stack
	sw	$ra,28($sp)		# storing the return address on the stack

	li $s1, 8			# Hexadecimal string character counter
conversion_loop:
	lbu $s0, ($a0)			# get a hexadecimal string character
	ble $s0, '9', decimal_digit	# if its a ascii coded decimal digit, convert it to its corresponding decimal value
	sub $s0, $s0, 'A'		# convert the current ascii coded hexadecimal digit that is greater than 9 by first subtracting ascii code of 'A' from it 
	add $s0, $s0, 10		# and then add 10 to it
	b continue			
decimal_digit:
	sub $s0, $s0, '0'		# convert the current ascii coded decimal digit to its corresponding decimal value
continue:
	sll $s2, $s2, 4			# shift the already placed hex digits to left
	or $s2, $s2, $s0		# place the current hexa decimal digit in $s2
	addi $a0, $a0, 1		# move on to the next hexadecimal string character
	addi $s1, $s1, -1		# decrement loop counter
	bnez $s1, conversion_loop	# keep processing characters untill all of them get processed

	la $a0, NEWLINE
	li $v0, 4
	syscall				# put the cursor in a new line

	addi	$a0,$0,1		# argument for report procedure
	jal	report			# call to report procedure
	addu	$v0,$s2,$0		# conversion result to $v0 (atoi output)

	lw	$ra,28($sp)		# restore return address to $ra register from stack
	addi	$sp,$sp,32		# restore stack pointer value
	jr $ra				# jump to instruction after atoi call


#############################################################
# get_type
#############################################################
#############################################################
# DESCRIPTION  
#
# a- get the instruction word opcode
# b- compare the opcode with valid opcodes
# c- if opcode is 0, get the function 6 bits
# d- if the function 6 bits are from a valid instruction word, set the return value to 0 and return
# e- if ipcode not 0 search for the other valid opcodes
# f- if non zero opcodes are valid opcodes set the return value according to the instruction type and return
# g- if the instruction word has an invalid opcode, set the output to -1 and return
#############################################################
	
.globl get_type
get_type: addi	$sp,$sp,-32	# making space on the stack
	sw	$ra,28($sp)	# storing the return address on the stack
	sw	$s0,24($sp)	# storing the instruction word in decimal format, on the stack

	andi	$s0,$a0,0xFC000000	# copy the instruction word opcode to $s0
	beq	$s0,$0,opc0		# if opcode is zero jump to opc0 label
	beq	$s0,0x08000000,Jtype	# 0x02=0000 0010 ---- 00 0010 --> 0000 1000 if opcode is 0x02 jump to Jtype label
	beq	$s0,0x10000000,Itype	# 0x04=0000 0100 ---- 00 0100 --> 0001 0000 if opcode is 0x04 jump to Itype label
	beq	$s0,0x20000000,Itype	# 0x08=0000 1000 ---- 00 1000 --> 0010 0000 if opcode is 0x08 jump to Itype label
	beq	$s0,0x8C000000,Itype	# 0x23=0010 0011 ---- 10 0011 --> 1000 1100 if opcode is 0x23 jump to Itype label
	beq	$s0,0xAC000000,Itype	# 0x2B=0010 1011 ---- 10 1011 --> 1010 1100 if opcode is 0x2B jump to Itype label
	j	inv			# if no valid opcode is found, there is an invalid code, jump to inv label
opc0:	andi	$s0,$a0,0x0000003F	# get the function 6 bits on $s0 register in case of a 0 opcode instruction word
	beq	$s0,0x20,Rtype		# if the function 6 bits are 10 0000, jump to Rtype label
	beq	$s0,0x24,Rtype		# if the function 6 bits are 10 0100, jump to Rtype label
	beq	$s0,0x2A,Rtype		# if the function 6 bits are 10 1010, jump to Rtype label
	j	inv			# if no valid function is found, jump to inv label to indicate an invalid instruction
Rtype:	addi	$s1,$0,0		# $s1==0 indicates Rtype instruction
	j	gtend			# jump to gtend label to execute the final instructions of the procedure
Itype:	addi	$s1,$0,1		# $s1==1 indicates Itype instruction
	j	gtend			# jump to gtend label to execute the final instructions of the procedure
Jtype:	addi	$s1,$0,2		# $s1==2 indicates Jtype instruction
	j	gtend			# jump to gtend label to execute the final instructions of the procedure
inv:	addi	$s1,$0,-1		# $s1==-1 indicates an invalid instruction

gtend:	addi	$a0,$0,2		# argument for report procedure
	jal	report			# call to report procedure
	addu	$v0,$s1,$0		# get_type procedure output to $v0

	lw	$s0,24($sp)	# getting the instruction word in decimal format out from the stack
	lw	$ra,28($sp)	# getting the return address out from the stack
	addi	$sp,$sp,32	# restore the stack pointer value
	jr $ra			# jump to instruction after get_type call

#############################################################
# get_dest_reg
#############################################################
#############################################################
# DESCRIPTION  
#
# a- get the opcode from instruction word
# b- if the opcode is from an instruction that updates a register, get the register number and return it
# c- if the opcode is from an instruction that don't updates any register, return 32
# d- if the opcode is from an invalid instruction, return -1
#############################################################
	
.globl get_dest_reg
get_dest_reg: addi $sp,$sp,-32	# making space on the stack
	sw	$ra,28($sp)	# storing the return address on the stack
	sw	$s0,24($sp)	# storing the instruction word in decimal format, on the stack

	andi	$s0,$a0,0xFC000000	# copy the instruction word opcode to $s0
	beq	$s0,$0,opc02		# if opcode is zero jump to opc02 label
	beq	$s0,0x08000000,ret32	# if opcode is 0x02, no register gets updated by the instruction, jump to ret32 label to return 32
	beq	$s0,0x10000000,ret32	# if opcode is 0x04, no register gets updated by the instruction, jump to ret32 label to return 32
	beq	$s0,0x20000000,Itype2	# if opcode is 0x08 jump to Itype2 label to get the register number
	beq	$s0,0x8C000000,Itype2	# if opcode is 0x23 jump to Itype2 label to get the register number
	beq	$s0,0xAC000000,ret32	# if opcode is 0x2B, no register gets updated by the instruction, jump to ret32 label to return 32
	j	inv2			# if no valid opcode is found, there is an invalid code, jump to inv2 label
opc02:	andi	$s0,$a0,0x0000003F	# get the function 6 bits on $s0 register in case of a 0 opcode instruction word
	beq	$s0,0x20,Rtype2		# if the function 6 bits are 10 0000, jump to Rtype2 label
	beq	$s0,0x24,Rtype2		# if the function 6 bits are 10 0100, jump to Rtype2 label
	beq	$s0,0x2A,Rtype2		# if the function 6 bits are 10 1010, jump to Rtype2 label
	j	inv2			# if no valid function is found, jump to inv2 label to indicate an invalid instruction
Rtype2:	srl	$s1,$a0,11		# shift right instruction word 11 bits to get the destination register number on least significant bits
	andi	$s1,$s1,0x0000001F	# isolate the destination register number 5 bits on $s1 register
	j	gdrend			# jump to gdrend label to execute the final instructions of the procedure
Itype2:	srl	$s1,$a0,16		# shift right instruction word 16 bits to get the destination register number on least significant bits
	andi	$s1,$s1,0x0000001F	# isolate the destination register number 5 bits on $s1 register
	j	gdrend			# jump to gdrend label to execute the final instructions of the procedure
ret32:	addi	$s1,$0,32		# $s1==32 indicates no register update
	j	gdrend			# jump to gdrend label to execute the final instructions of the procedure
inv2:	addi	$s1,$0,-1		# $s1==-1 indicates an invalid instruction

gdrend:	addi	$a0,$0,3		# argument for report procedure
	jal	report			# call to report procedure
	addu	$v0,$s1,$0		# get_dest_reg procedure output to $v0

	lw	$s0,24($sp)	# getting the instruction word in decimal format out from the stack
	lw	$ra,28($sp)	# getting the return address out from the stack
	addi	$sp,$sp,32	# restore the stack pointer value
	jr $ra			# jump to instruction after get_dest_reg call

#############################################################
# get_next_pc
#############################################################
#############################################################
# DESCRIPTION 
#
# a- get the opcode from instruction word
# b- if opcode is 0x00:
#	b.1- verify that function is valid
#	b.2- if function is valid return PC+4 on $v0 and -1 on $v1
#	b.3- if function is invalid return -1 on $v0
# c- if opcode is 0x02:
#	c.1- get the 26 bits address from istruction word
#	c.2- place 2 zero bits at this 26 bits right
#	c.3- get the 4 most significant bits of PC+4 and isolate them
#	c.4- place the 4 most significant PC+4 bits at the left of the 26 bits address with the 2 zeros added
#	c.5- return this 32 bits on $v0 and -1 on $v1
# d- if opcode is 0x04:
#	d.1- set $v0 to PC+4
#	d.2- get the 16 least significant bits of instruction word
#	d.3- isolate that 16 bits and multiply the value by 4
#	d.4- add the result of d.3 operation to PC+4, the result is the PC value when branch is taken, return it on $v1
#	d.5- return $v0
# e- if opcode is another valid opcode:
#	e.1- set $v0 to PC+4 and return it
#	e.2- set $v1 to -1 and return it
# f- if ipcode is invalid set $v0 to -1 and return it
#############################################################

.globl get_next_pc
get_next_pc: addi $sp,$sp,-32	# making space on the stack
	sw	$ra,28($sp)	# storing the return address on the stack

	andi	$s0,$a0,0xFC000000	# copy the instruction word opcode to $s0
	beq	$s0,$0,opc03		# if opcode is zero jump to opc03 label
	beq	$s0,0x08000000,jump	# if opcode is 0x02 jump to jump label
	beq	$s0,0x10000000,breq	# if opcode is 0x04 jump to breq label
	beq	$s0,0x20000000,PCp4	# if opcode is 0x08 jump to PCp4 label
	beq	$s0,0x8C000000,PCp4	# if opcode is 0x23 jump to PCp4 label
	beq	$s0,0xAC000000,PCp4	# if opcode is 0x2B jump to PCp4 label
	j	inv3			# if no valid opcode is found, there is an invalid code, jump to inv3 label
opc03:	andi	$s0,$a0,0x0000003F	# get the function 6 bits on $s0 register in case of a 0 opcode instruction word
	beq	$s0,0x20,PCp4		# if the function 6 bits are 10 0000, jump to PCp4 label
	beq	$s0,0x24,PCp4		# if the function 6 bits are 10 0100, jump to PCp4 label
	beq	$s0,0x2A,PCp4		# if the function 6 bits are 10 1010, jump to Pcp4 label
	j	inv3			# if no valid function is found, jump to inv3 label to indicate an invalid instruction
PCp4:	addi	$s1,$a1,4		# $s1 = PC + 4
	addi	$v1,$0,-1		# $v1 = -1, sequential instruction
	j	gnpend			# jump to gnpend label to execute the final instructions of the procedure
breq:	addi	$s1,$a1,4		# $s1 = PC + 4, branch not taken
	andi	$s2,$a0,0x0000FFFF	# copy the immediate to $s2
	mulu	$v1,$s2,4		# $v1 = 4*immediate
	add	$v1,$s1,$v1		# $v1 = PC + 4 + 4*immediate, next PC address if brach is taken
	j	gnpend			# jump to gnpend label to execute the final instructions of the procedure
jump:	andi	$s0,$a0,0x03FFFFFF	# get the 26 least significant bits of instruction word on $s0 register
	sll	$s0,$s0,2		# shift left 2 places the 26 bits address
	addi	$s1,$a1,4		# $s1 = PC + 4
	andi	$s1,$s1,0xF0000000	# get the 4 most significant bits of PC+4 on $s1
	or	$s1,$s0,$s1		# concatenate the bits in $s1 and $s0, new PC address is on $s1
	addi	$v1,$0,-1		# $v1 = -1 for jump instruction too
	j	gnpend			# jump to gnpend label to execute the final instructions of the procedure
inv3:	addi	$s1,$0,-1		# $s1==-1 indicates an invalid instruction

gnpend:	addi	$a0,$0,4		# argument for report procedure
	jal	report			# call to report procedure
	addu	$v0,$s1,$0		# get_next_pc procedure output to $v0

	lw	$ra,28($sp)	# getting the return address out from the stack
	addi	$sp,$sp,32	# restore the stack pointer value
	jr $ra			# jump to instruction after get_next_pc call

#############################################################
# optional: other helper functions
#############################################################
