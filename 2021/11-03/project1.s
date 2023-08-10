# Howard ID: 02846337
.data
input:	.asciiz "Input: "
output:	.asciiz	"\nOutput: "
.set noat
.text
main:
	la $a0,input	# load input string address on $a0
	addi $v0,$0,4	# $v0=4 to print a string
	syscall		# print the string "Input: "
	addi $t0,$0,10	# counter for 10 characters
	#addi $t1,$0,12345678	# $t1=X
	#addi $t1,$0,2846337	# $t1=X
	lui $at,0x2b
	ori $at,$at,0x6e81
	add $t1,$0,$at	# $t1=X=2846337
	addiu $t2,$0,11	# $t2=11
	div $t1,$t2	# X/11
	mfhi $t3	# $t3=X%11
	addi $t6,$t3,26	# $t6=N
	addi $t7,$t6,-10# $t7=M=N-10
	addi $t1,$t7,'A'# $t1='A'+M
	addi $t2,$t7,'a'# $t2='a'+M

read:	addi $v0,$0,12	# $v0=12 to read a character
	syscall		# read a character from keyboard and stores it to $v0
	bge $v0,'a',lowerc	# brach to lowerc label if lower case character was introduced
	bge $v0,'A',cap	# branch to cap label if a capital letter was introduced
	bge $v0,'0',num	# branch to num label if a number was introduced
	blt $v0,'0',inv	# branch to inv label if there is an invalid character

lowerc:	bge $v0,$t2,inv	# branch to inv label if character is >= than 'a'+M
	addi $t4,$0,'a'	# else, $t4='a'
	#subi $t4,$t4,10	# $t4='a'-10
	addi $at,$0,10
	sub $t4,$t4,$at	# $t4='a'-10
	j subs		# jump to subs label to get decimal value

cap:	bge $v0,$t1,inv	# branch to inv label if character is >= than 'A'+M
	addi $t4,$0,'A'	# else $t4='A'
	#subi $t4,$t4,10	# $t4='A'-10
	addi $at,$0,10
	sub $t4,$t4,$at	# $t4='A'-10
	j subs		# jump to subs label to get decimal value

num:	bgt $v0,'9',inv	# branch to inv label if character is between '9' and 'A' (invalid)
	addi $t4,$0,0x30# else, $t4=0x30
subs:	sub $v0,$v0,$t4	# decimal value of character to $v0
	add $t5,$t5,$v0	# accumulates in $t5 the sum of all decimal values of characters introduced
inv:	addi $t0,$t0,-1	# countdown for the 10 characters
	bne $t0,$0,read	# if $t0=0, 10 characters has been readed

	la $a0,output	# load output string address on $a0
	addi $v0,$0,4	# $v0=4 to print a string
	syscall		# print the string "Output: "
	add $a0,$0,$t5	# $a0=integer to be printed
	addi $v0,$0,1	# $v0=1 to print an integer number
	syscall		# prints the integer on $t5

	jr $ra
