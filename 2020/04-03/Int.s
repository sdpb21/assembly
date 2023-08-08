.ktext  0x80000180
move	$k0,$at # $k0 = $at
sw	$k0,k0	# save $at
sw	$v0,v0	# save $v0 
sw	$a0,a0	# save $a0
sw 	$t0,t0	# save $t0
sw	$t1,t1	# save $t1

mfc0	$a0,$13		# $a0 = cause
srl	$a0,$a0,2	# shift right by 2 bits 
andi	$a0,$a0,31	# $a0 = exception code
beqz	$a0,interr	# if $a0==0 is an interruption

la	$a0,msg1	# $a0 = address of msg1 (Trap )
li	$v0,4		# $v0 = service 4
syscall			# Print "Trap "

mfc0	$a0,$13		# $a0 = cause
srl	$a0,$a0,2	# shift right by 2 bits
andi	$a0,$a0,31	# $a0 = exception code
li	$v0,1		# $v0 = service 1
syscall 		# Print exception code

la	$a0,msg2	# $a0 = address of msg2 ( ocurred at )
li	$v0,4		# $v0 = service 4
syscall 		# Print " ocurred at "

mfc0	$a0,$14		# $a0 = EPC
li	$v0,34		# $v0 = service 34
syscall			# print EPC in hexadecimal

mtc0	$zero,$8	# clear vaddr
mfc0	$k0,$14		# $k0 = EPC
addiu	$k0,$k0,4	# Increment $k0 by 4
mtc0	$k0,$14		# EPC = point to next instruction
j	exit		# go to exit label

interr: mfc0   $a0, $13 # $a0 = cause
andi	$a0,$a0,0x00000200	# if bit 9 is clear $a0==0
bnez	$a0,exit		# if bit 9 is set, go to exit label
li	$t0,0xffff0000		# address of the keyboard control register to $t0
lw	$t1,($t0)		# store the value of the keyboard control register on $t1
andi	$t1,$t1,1		# check if the ready bit is set
beqz	$t1,exit		# return if it is not ready
lw	$a0,4($t0)		# get character from keyboard
lw	$t1,8($t0)		# store the value of the display control register on $t1
ori	$t1,$t1,1		# set the ready bit
sw	$t1,8($t0)		# store $t1 on the display control register
blt	$a0,48,exit		# if character is less than '0' then exit
bgt	$a0,57,cap		# if character is greater than '9' go to cap label
j	pch			# if character is within '0' and '9' print it
cap: blt $a0,65,exit		# if character is within '9' and 'A' then exit
bgt	$a0,90,low		# if character is greater than 'Z' go to low label
j	pch			# if character is within 'A' and 'Z' print it
low: blt $a0,97,exit		# if character is within 'Z' and 'a' then exit
bgt	$a0,122,exit		# if character is greater than 'z' then exit

pch: sw	$a0,12($t0)		# send character to display

exit:	lw	$k0,k0		# restore $at
lw	$v0,v0	# restore $v0
lw	$a0,a0	# restore $a0
lw	$t0,t0	# restore $t0
lw	$t1,t1	# restore $t1
move	$at,$k0	# restore $at

eret    # exception return: PC = EPC 

.kdata 
msg1: .asciiz   "\nTrap "
msg2: .asciiz   " ocurred at "
k0: .word 0 	# to store $k0 on memory
v0: .word 0	# to store $v0 on memory
a0: .word 0	# to store $a0 on memory
t0: .word 0	# to store $t0 on memory
t1: .word 0	# to store $t1 on memory
