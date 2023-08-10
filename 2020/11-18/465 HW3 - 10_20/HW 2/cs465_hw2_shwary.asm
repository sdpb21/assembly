#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW2 MIPS programming part.
#		This is the only file you should change and submit.
#
# HW2  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME 
# G#. 
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
# Start
# first of all receive string in $a0, 
# initialize $v1 = 0
# while (str != null){
# load char into $t1
# check that char is equal to 0 if 0 then return integer
# else char greater than '9' then check that char is alphabatic
# else subtract '0' from that char
# if char is alphabatic then subtract 55 from that char to convert into integer
# then multiply $v1 with 4 and add $t1 into their result
# add 1 into $a0 to jump on next char
# and at the end return integer into $v0
# END 
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################
		
.globl atoi
atoi:
	addi	$sp, $sp, -4		# allocate memory on stack
	sw	$ra, 0($sp)		# store $ra on stack
	addi	$v1, $0, 0		# load 0 into $v1
atoi_Loop:
	lb	$t1, ($a0)			# load a char from $t0
	beq	$t1, 0, return_integer		# if char == 0 then jump to return_integer label
	bgt	$t1, '9', CheckAlphabatics	# if char > '9' then jump to CheckAlphabatics label
	subi	$t1, $t1, '0'			# else subtract '0' ascii value from char
	j	computeInteger			# jump to computeInteger
	
CheckAlphabatics:
	subi	$t1, $t1, 55			# subtract 55 from char
computeInteger:
	sll	$v1, $v1, 4			# multiply $t9 with 16
	add	$v1, $v1, $t1			# add char into ($t9 * 16)
	addi	$a0, $a0, 1			# add 1 into $a0 to get next char
	j	atoi_Loop			# jump to atoi_Loop

return_integer:
	#prepare return
	#report status
	addi	$a0, $0, 1			# load 1 into $a0
	jal	report				# call report (int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate memory from stack
	add	$v0, $0, $v1			# move $v1 into $v0
	jr 	$ra				# return back


#############################################################
# get_type
#############################################################
#############################################################
# DESCRIPTION  
# Start
# 26 bits shifted right to get 6 MSB to get opcode
# next check if opcode is equal to 0 then instruction is R_type so load 0 into $v1
# else check if opcode is equal to 0x23 or 0x04 or 0x08 or 0x2b then instruction is I_type so load 1 into $v1 
# else check if opcode is equal to 0x02 then instruction is J_type so load 2 into $v1
# else if opcode not equal to above then instruction is invalid so load -1 into $v1
# And at the end move $v1 into $v0
# END
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

	
.globl get_type
get_type:
	addi	$sp, $sp, -4		# allocte space on stack
	sw	$ra, 0($sp)		# store $ra on stack
	srl	$t0, $a0, 26		# shilf 26 bits right to get 6 MSB and store into $t0
	beqz	$t0, R_type		# if $t0 == 0 then jump to R_type
	beq	$t0, 0x23, I_type	# else if $t0 == 0x23 then jump to I_type
	beq	$t0, 0x04, I_type	# else if $t0 == 0x04 then jump to I_type
	beq	$t0, 0x08, I_type	# else if $t0 == 0x08 then jump to I_type
	beq	$t0, 0x2b, I_type	# else if $t0 == 0x2b then jump to I_type
	beq	$t0, 0x02, J_type	# else if $t0 == 0x02 then jump to J_type
	j	invalid_type		# else jump to invalid_type
	 
	R_type:
		addi	$v1, $0, 0 	# load 0 into $v1
		j	return_type	# jump return_type
	I_type:
		addi	$v1, $0, 1 	# load 1 into $v1
		j	return_type	# jump return_type
	J_type:
		addi	$v1, $0, 2 	# load 2 into $v1
		j	return_type	# jump return_type
	invalid_type:
		addi	$v1, $0, -1 	# load -1 into $v1
		j	return_type	# jump return_type
return_type:
	#prepare return
	#report status
	addi	$a0, $0, 2		# load 2 into $a0
	jal	report			# call report(int stage)
	lw	$ra, 0($sp)		# load $ra from stack
	addi	$sp, $sp, 4		# deallocate space from stack
	add	$v0, $0, $v1		# move $v1 into $v0
	jr 	$ra



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
# else return -1 in $v1 in case invalid instruction 
# END
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################
	
.globl get_dest_reg
get_dest_reg:
	addi	$sp, $sp, -4			# allocte space on stack
	sw	$ra, 0($sp)			# store $ra on stack
	srl	$t0, $a0, 26			# shilf 26 bits right to get 6 MSB and store into $t0
	beqz	$t0, R_type_dest		# if $t0 == 0 then jump to R_type_dest
	beq	$t0, 0x23, I_type_dest		# else if $t0 == 0x23 then jump to I_type_dest	
	beq	$t0, 0x04, no_dest		# else if $t0 == 0x04 then jump to no_dest
	beq	$t0, 0x08, I_type_dest		# else if $t0 == 0x08 then jump to I_type_dest
	beq	$t0, 0x2b, no_dest		# else if $t0 == 0x2b then jump to no_dest
	beq	$t0, 0x02, no_dest		# else if $t0 == 0x02 then jump to no_dest
	
	addi	$v1, $0, -1			# load -1 into $v1
	j	return_dest			# jump return_dest
	

R_type_dest:
	sll	$v1, $a0, 16			# shift 16 bits left and store result into $v1
	srl	$v1, $v1, 27			# shift 27 bits write to get dest register number
	j	return_dest			# jump return_dest

I_type_dest:
	sll	$v1, $a0, 11			# shift 11 bits left and store result into $v1
	srl	$v1, $v1, 27			# shift 27 bits write to get dest register number
	j	return_dest			# jump return_dest

no_dest:
	addi	$v1, $0, 32			# load 32 into $v1
	j	return_dest			# jump return_dest
	
return_dest:
	#prepare return
	#report status
	addi	$a0, $0, 3			# load 3 into $a0
	jal	report				# call report(int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate space from stack
	add	$v0, $0, $v1			# move $v1 into $v0
	jr 	$ra


#############################################################
# get_next_pc
#############################################################
#############################################################
# DESCRIPTION 
# Start
# first check instruction type
# if instruction is sequentional then PC = PC + 4
# else if instruction is J_type then multiply immediate 26 bits value with 4
# else if instruction is branch then multiply immediate 16 bits with 4 and add PC + 4 + multiplied value
# END
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

.globl get_next_pc
get_next_pc:
	addi	$sp, $sp, -4			# allocte space on stack
	sw	$ra, 0($sp)			# store $ra on stack
	add	$t8, $0, $a0			# move $a0 into $t8
	srl	$t0, $a0, 26			# shilf 26 bits right to get 6 MSB and store into $t0	
	beqz	$t0, seq_inst_Address		# if $t0 == 0 then jump to seq_inst_Address
	beq	$t0, 0x23, seq_inst_Address	# else if $t0 == 0x23 then jump to seq_inst_Address
	beq	$t0, 0x04, beq_inst_Address	# else if $t0 == 0x04 then jump to beq_inst_Address
	beq	$t0, 0x08, seq_inst_Address	# else if $t0 == 0x08 then jump to seq_inst_Address
	beq	$t0, 0x2b, seq_inst_Address	# else if $t0 == 0x2b then jump to seq_inst_Address
	beq	$t0, 0x02, j_inst_Address	# else if $t0 == 0x02 then jump to j_inst_Address
	j	invalid_inst_addr
	
invalid_inst_addr:
	addi	$a0, $0, 4			# load 4 into $a0
	jal	report				# call report (int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate space from stack
	addi	$v0, $0, -1			# load -1 into $v0
	jr	$ra				# return
	
seq_inst_Address:
	addi	$a0, $0, 4			# load 4 into $a0
	jal	report				# call report (int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate space from stack
	addi	$v0, $a1, 4			# PC = PC + 4
	addi	$v1, $0, -1			# load -1 into $v1
	jr	$ra				# return
	
j_inst_Address:
	addi	$a0, $0, 4			# load 4 into $a0
	jal	report				# call report (int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate space from stack
	sll	$v0, $t8, 6			# shift left 6 bits to get immediate value
	srl	$v0, $v0, 6			# shift right 6 bits right to set MSB 6 bits with 0
	mul	$v0, $v0, 4			# multiply that immediate value with 4 and store address into $v0
	addi	$v1, $0, -1			# load -1 into $v1
	jr	$ra				# return
	
beq_inst_Address:
	addi	$a0, $0, 4			# load 4 into $a0
	jal	report				# call report (int stage)
	lw	$ra, 0($sp)			# load $ra from stack
	addi	$sp, $sp, 4			# deallocate space from stack
	sll	$v1, $t8, 16			# shift left 16 bits to get immediate value
	srl	$v1, $v1, 16			# shift right 16 bits right to set MSB 16 bits with 0
	mul	$v1, $v1, 4			# multiply that immediate value with 4 and store address into $v1
	add	$v1, $v1, 4			# add 4 into $v1
	addi	$v0, $a1, 4			# add 4 into PC and store result into $v0
	jr	$ra				# return



#############################################################
# optional: other helper functions
#############################################################
				
