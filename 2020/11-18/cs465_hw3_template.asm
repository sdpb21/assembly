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
	CTRLSIGN:	.asciiz	": Control signals: "
	DEP:		.asciiz	"\nDependences: "
	NONE:		.asciiz	"None"
	OPAR:		.asciiz	" ("
	ILETTER:	.asciiz	", I"
	CPAR:		.asciiz	") "
	SEPARATOR: .asciiz "\n-----------------------------------\n"
	NEWLINE: .asciiz "\n"

	.align 4
	INPUT: .space 8
	.align 4
	INSTRUCTIONS:	.space	40
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
	la	$t2,INSTRUCTIONS
	Loop: # Read in N strings
		la $a0, INPUT
		li $a1, 9
		li $v0, 8
		syscall # read in one string and store in INPUT
		###########################################
		# Add your code here to process the input
######### Step 1: atoi ##########
	jal	atoi		# string to int conversion
	sw	$v0,($t2)	# store instruction in memory
	addi	$t2,$t2,4	# increment address for next instruction word
	jal	print_newline	# print a '\n'
######## end of Step 1 #################
########################################	
		addi $t0, $t0, 1	# increment loop counter
		blt $t0, $t1, Loop	# repeat if counter is below the total instructions

	la	$t2,INSTRUCTIONS	# instruction words address to $t2 register
	li	$t0,0			# loop counter to 0 again
######### Step 2: get control signals ##########
# addi control signals
# RegDst=0[00]	destination register will be rt field
# ALUOp=00	00 indicates an ALU add operation
# ALUSrc=1	the second ALU operand is the sign-extended
# Branch=0	not a branch operation
# MemRead=0	memory will not be readed
# MemWrite=0	memory will not be writed
# RegWrite=1	the register on the write register input is written
# MemtoReg=0[00] write data input comes from ALUs output

controlSignals:	lw $t3,($t2)		# copy instruction word in $t3 register
	srl	$a0, $t3, 26		# shift 26 bits right to get 6 MSB and store into $a0
	beqz	$a0, R_type		# if $a0 == 0 then jump to R_type
	beq	$a0, 0x23, I_lw		# else if $a0 == 0x23 then jump to I_lw
	beq	$a0, 0x04, I_beq	# else if $a0 == 0x04 then jump to I_beq
	beq	$a0, 0x08, I_addi	# else if $a0 == 0x08 then jump to I_addi
	beq	$a0, 0x2b, I_sw		# else if $a0 == 0x2b then jump to I_sw
	 
R_type:	addi	$t4,$0,0x00000304	# RegDst=1[01] ALUOp=10 ALUSrc=0 Branch=0 MemRead=0 MemWrite=0 RegWrite=1 MemtoReg=0[00] 011 0000 0100=0x304
	j	printCS			# jump printCS
I_lw:	addi	$t4,$0,0x00000055	# RegDst=0[00] ALUOp=00 ALUSrc=1 Branch=0 MemRead=1 MemWrite=0 RegWrite=1 MemtoReg=1[01] 000 0101 0101=0x055
	j	printCS			# jump printCS
I_beq:	addi	$t4,$0,0x000006A3	# RegDst=x[11] ALUOp=01 ALUSrc=0 Branch=1 MemRead=0 MemWrite=0 RegWrite=0 MemtoReg=x[11] 110 1010 0011=0x6A3
	j	printCS			# jump printCS
I_addi:	addi	$t4,$0,0x00000044	# RegDst=0[00] ALUOp=00 ALUSrc=1 Branch=0 MemRead=0 MemWrite=0 RegWrite=1 MemtoReg=0[00] 000 0100 0100=0x044
	j	printCS			# jump printCS
I_sw:	addi	$t4,$0,0x0000064B	# RegDst=x[11] ALUOp=00 ALUSrc=1 Branch=0 MemRead=0 MemWrite=1 RegWrite=0 MemtoReg=x[11] 110 0100 1011=0x64B
	#j	printCS			# jump printCS

printCS:addi	$a0,$0,'I'
	li	$v0,11
	syscall			# prints char I
	add	$a0,$0,$t0
	li	$v0,1
	syscall			# print integer on $t0 register
	la	$a0,CTRLSIGN
	li	$v0,4
	syscall			# prints ": Control signals: "
	add	$a0,$0,$t4
	li	$v0,34
	syscall			# prints $t4 in hexadecimal format
	la	$a0,DEP
	li	$v0,4
	syscall			# prints "Dependences: "
######## end of Step 2 #################
########################################
######### Step 3: get dependences ##########
	add	$t8,$0,$0	# $t8=0 dependences loop counter
	la	$s0,INSTRUCTIONS# instructions vector address to $s0
	add	$s1,$0,$0	# $s1 will be used to determine if there were dependencies and if "None" must be printed
	beq	$t0,$0,t0_0	# if $t0 is 0, go to t0_0 label
	j	t0not0		# else, go to t0not0 label

t0_0:	j	enddep		# jump to enddep label

t0not0:	mul	$t9,$t8,4	# copy in $t9 $t8 multipied by 4
	add	$t5,$s0,$t9	# previus instruction address to $t5
	lw	$t6,($t5)	# previus instruction to $t6
	# get previus instruction destination register
	add	$a0,$0,$t6	# previus instruction as parameter for get_dest_reg
	jal	get_dest_reg	# get previus instruction destination register
	beq	$v0,32,nexti	# if no destination register, jumps to nexti label
	# else, get registers used by actual instruction ($t3)
	add	$t7,$0,$v0	# previus instruction destination register copied to $t7
	add	$a0,$0,$t3	# actual instruction as parameter for get_RtAndRs
	jal	get_RtAndRs	# get rt and rs registers from actual instruction ($t3)
	# verify if rt or rs are the destination register of the previus instruction
	srl	$a0, $t3, 26		# shift 26 bits right of actual instuction to get opcode and store into $a0
	beqz	$a0, rtrs		# if $a0 == 0 then jump to rtrs
	beq	$a0, 0x23, rs		# else if $a0 == 0x23 then jump to rs 		lw
	beq	$a0, 0x04, rtrs		# else if $a0 == 0x04 then jump to rtrs 	beq
	beq	$a0, 0x08, rs		# else if $a0 == 0x08 then jump to rs 		addi
	beq	$a0, 0x2b, rtrs		# else if $a0 == 0x2b then jump to rtrs 	sw

rtrs:	beq	$t7,$v0,equals	# compare previus instruction destination register with rt, if equals, jump
	beq	$t7,$v1,equals	# compare previus instruction destination regiater wirh rs, if equals, jump
	j	noteq		# if previus instruction destination register is not equal to rs or rt, there is no dependency
rs:	beq	$t7,$v1,equals	# compare previus instruction destination register with rs, if equals, jump
	j	noteq		# if previus instruction destination register is not equal to rs, there is no dependency
	# print the dependencies ( register , producer , consumer )
equals:	addi	$s1,$s1,1	# if $s1!=0 "None" will not be printed
	la	$a0,OPAR
	addi	$v0,$0,4
	syscall			# prints " ("
	add	$a0,$0,$t7
	addi	$v0,$0,1
	syscall			# prints the integer stored in $t7
	la	$a0,ILETTER
	addi	$v0,$0,4
	syscall			# prints ", I"
	add	$a0,$0,$t8
	addi	$v0,$0,1
	syscall			# prints the number of the previus instruction
	la	$a0,ILETTER
	addi	$v0,$0,4
	syscall			# prints ", I"
	add	$a0,$0,$t0
	addi	$v0,$0,1
	syscall			# prints the number of the actual instruction
	la	$a0,CPAR
	addi	$v0,$0,4
	syscall			# prints ") "

noteq:
nexti:	addi	$t8,$t8,1	# internal loop to look for dependencies
	beq	$t8,$t0,enddep	# if the search for dependencies finished, go to enddep label
	j	t0not0		# else, repeat dependence loop
######## end of Step 3 #################
########################################
enddep:	bne	$s1,$0,endde	# if $s1!=0 "None" must not be printed
	la	$a0,NONE
	li	$v0,4
	syscall			# prints "None"
endde:	la	$a0,SEPARATOR
	li	$v0,4
	syscall			# prints the separator
	addi	$t0,$t0,1	# increment counter
	addi	$t2,$t2,4	# next instruction stored
	blt	$t0,$t1,controlSignals	# if counter is less than total instructions, go to controlSignals label
	
exit:
	li $v0, 10
	syscall

#############################################################
# atoi
#############################################################
#############################################################
# DESCRIPTION  
# Start
# first of all receive string in $a0, 
# initialize $v1 = 0
# while (str != null){
# load char into $s1
# check that char is equal to 0 if 0 then return integer
# else char greater than '9' then check that char is alphabatic
# else subtract '0' from that char
# if char is alphabatic then subtract 55 from that char to convert into integer
# then multiply $v1 with 4 and add $s1 into their result
# add 1 into $a0 to jump on next char
# and at the end return integer into $v0
# END 
#############################################################
atoi:	addi	$v1, $0, 0		# load 0 into $v1
atoi_Loop:
	lb	$s1, ($a0)			# load a char from $t0
	beq	$s1, 0, return_integer		# if char == 0 then jump to return_integer label
	bgt	$s1, '9', CheckAlphabatics	# if char > '9' then jump to CheckAlphabatics label
	subi	$s1, $s1, '0'			# else subtract '0' ascii value from char
	j	computeInteger			# jump to computeInteger
	
CheckAlphabatics:
	subi	$s1, $s1, 55			# subtract 55 from char
computeInteger:
	sll	$v1, $v1, 4			# multiply $t9 with 16
	add	$v1, $v1, $s1			# add char into ($t9 * 16)
	addi	$a0, $a0, 1			# add 1 into $a0 to get next char
	j	atoi_Loop			# jump to atoi_Loop

return_integer:
	#prepare return
	#report status
	add	$v0, $0, $v1			# move $v1 into $v0
	jr 	$ra				# return back
#############################################################
# get_dest_reg
#############################################################
#############################################################
# DESCRIPTION  
# Start
# first check instruction type
# if instruction is R_type then shift 16 bits left and shift right 27 bits of that result to get dest register and store into
# $v0
# else if instruction is branch type then no dest register and return 32 into $v0
# else instruction is I_type then shift 11 bits left and shift right 27 bits of that result to get dest register and store into
# $v0
# else return -1 in $v0 in case invalid instruction
# END
#############################################################
get_dest_reg:
	addi	$sp,$sp,-4
	sw	$s0,($sp)
	srl	$s0, $a0, 26			# shift 26 bits right to get 6 MSB and store into $s0
	beqz	$s0, R_type_dest		# if $s0 == 0 then jump to R_type_dest
	beq	$s0, 0x23, I_type_dest		# else if $s0 == 0x23 then jump to I_type_dest
	beq	$s0, 0x04, no_dest		# else if $s0 == 0x04 then jump to no_dest
	beq	$s0, 0x08, I_type_dest		# else if $s0 == 0x08 then jump to I_type_dest
	beq	$s0, 0x2b, no_dest		# else if $s0 == 0x2b then jump to no_dest
	beq	$s0, 0x02, no_dest		# else if $s0 == 0x02 then jump to no_dest
	addi	$v0, $0, -1			# load -1 into $v0
	j	return_dest			# jump return_dest

R_type_dest:
	sll	$v0, $a0, 16			# shift 16 bits left and store result into $v0
	srl	$v0, $v0, 27			# shift 27 bits write to get dest register number
	j	return_dest			# jump return_dest

I_type_dest:
	sll	$v0, $a0, 11			# shift 11 bits left and store result into $v0
	srl	$v0, $v0, 27			# shift 27 bits write to get dest register number
	j	return_dest			# jump return_dest

no_dest:
	addi	$v0, $0, 32			# load 32 into $v0
	
return_dest:lw	$s0,($sp)
	addi	$sp,$sp,4
	jr 	$ra
#############################################################
# get_RtAndRs
#############################################################
#############################################################
# DESCRIPTION  
# Start
# shift right instruction word 16 bits to get rt value
# copy rt in $v0
# shift right instruction word 21 bits to get rs value
# copy rs to $v1 register
# END
#############################################################
get_RtAndRs:addi $sp,$sp,-4
	sw	$s0,($sp)		# get in $s0 in stack
	srl	$s0,$a0,16		# shift right 16 bits to get rt
	andi	$v0,$s0,0x0000001F	# copy rt to $v0 (output)
	srl	$s0,$a0,21		# shift right 21 bits to get rs
	andi	$v1,$s0,0x0000001F	# copy rs to $v1 (second output)
	lw	$s0,($sp)		# get out $s0 from stack
	addi	$sp,$sp,4
	jr 	$ra
#############################################################
# subroutine: print_newline
#############################################################
print_newline: la $a0, NEWLINE
	li $v0, 4
	syscall	
	jr $ra
