.data
matrix5x5: 	.word 11,12,13,14,15 #define a 5x5 matrix
		.word 21,22,23,24,25
		.word 31,32,33,34,35
		.word 41,42,43,44,45
		.word 51,52,53,54,55
.text
main:
	la $t0,matrix5x5#put on $t0 first element matrix address
	li $a0,2	#first input, row index
	li $a1,3	#second input, column index
	mul $v1,$a0,5	#multiply the row index of desired element and the number of columns
	add $v1,$v1,$a1	#add the last multiplication and the column index
	mul $v1,$v1,4	#multiply the last operation and the size in bytes of a word because each matrix element is a word
	add $v1,$t0,$v1	#$v1=baseAddr+(rowIndex*colsize+colIndex)*dataSize    $t0=baseAddr
	#the desired address is o $v1
	
	li $v0,10
	syscall