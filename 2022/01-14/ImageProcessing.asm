.data
filename:	.asciiz	"image.pgm"
buffer:	.space 38
open:	.asciiz	"("
colon:	.asciiz	" : "
close:	.asciiz	")\n"
enter:	.asciiz	"\n Enter a threshold (from 0 to 255): "
newfile:	.asciiz	"processed.pgm"
.text
main:
	# STEP 1
	addi $v0,$0,13	# code for open file service
	la $a0,filename	# copy the address of null-terminated string containing filename
	add $a1,$0,$0	# open for reading (flasg are 0:read, 1: write)
	add $a2,$0,$0	# mode is ignored ($a2=0)
	syscall		# execute open file service and return file descriptor on $v0

	add $a0,$0,$v0	# copy the file descriptor to $a0 register
	addi $v0,$0,14	# code for read from file service
	la $a1,buffer	# copy the address of input buffer to $a1 register
	addi $a2,$0,38	# maximum number of characters or bytes to be read
	syscall		# execute read from file service and return on $v0 the # of bytes readed (0 if end-of-file)

	# STEP 2
	add $t0,$t0,$0	# counter for '\n' characters
l2:	lbu $t1,($a1)	# load byte from header pointed by address stored on $a1 register
	addi $a1,$a1,1	# get next byte address
	beq $t1,'\n',l1	# if byte on $t1 is '\n' go to l1 label
	j l2		# else jump to l2 label

l1:	addi $t0,$t0,1	# increment the '\n' characters counter
	add $t1,$0,$0	# $t1=0
	beq $t0,2,l3	# if $t0 is 2, jump to l3 label
	j l2		# else. go to l2 label

l3:	lbu $t0,($a1)	# load byte from header pointed by address stored on $a1 register
	addi $a1,$a1,1	# get next byte address
	beq $t0,' ',l4	# if $t0 is ' ' jump to l4 label to get next dimension convertion
	addi $t0,$t0,-48# convert byte from ASCII to decimal value
	mul $t1,$t1,10	# multiply $t1 by 10
	add $t1,$t1,$t0	# add $t0 and $t1 and store the result on $t1
	j l3		# jump to l3 label

l4:	lbu $t0,($a1)	# load byte from header pointed by address stored on $a1 register
	addi $a1,$a1,1	# get next byte address
	beq $t0,'\n',l5	# if $t0 is '\n' jump to l5 label
	addi $t0,$t0,-48# convert byte from ASCII to decimal value
	mul $t2,$t2,10	# multiply $t2 by 10
	add $t2,$t2,$t0	# add $t0 and $t2 and store the result on $t2
	j l4		# jump to l4 label

l5:	mul $t0,$t1,$t2	# total number of image bytes to $t0 register (dimension 1 x dimension 2)
	sub $sp,$sp,$t0	# making space on stack to store the complete image bytes
	add $t1,$0,$sp	# copy the $sp value to $t1 register

	addi $v0,$0,14	# code for read from file service
	add $a1,$0,$sp	# input buffer has address pointed by stack pointer
	add $a2,$0,$t0	# maximum number of characters or bytes to be read
	syscall		# execute read from file service and return on $v0 the # of bytes readed (0 if end-of-file)

	add $t4,$0,$0	# set to 0 the pixels counter
	addi $sp,$sp,-1024	# making space on stack for 256 words for histogram
l7:	lbu $t2,($t1)	# read color (from 0 to 255) on address in $t1 register
	mul $t2,$t2,4	# offset for color counter word on stack
	add $t2,$sp,$t2	# color counter word address on $t2
	lw $t3,($t2)	# copy word on $t2 address to $t3 (color counter word)
	addi $t3,$t3,1	# increment the color counter word by 1
	sw $t3,($t2)	# store color counter word incremented on the same address
	addi $t1,$t1,1	# next pixel address
	addi $t4,$t4,1	# increment pixels counter
	beq $t4,$t0,l6	# if pixel counter = total pixels jump to l6 label
	j l7		# else, jump to l7 label and repeat again

	# STEP 3
l6:	add $t2,$0,$0	# set intensity counter $t2 to 0
l8:	addi $v0,$0,4	# code for print null-terminated string service
	la $a0,open	# null-terminated string address to print labeled open
	syscall		# execute print null-terminated string service

	addi $v0,$0,1	# code for print integer number service
	add $a0,$0,$t2	# integer to be printed to $a0
	syscall		# execute print integer number service
	addi $t2,$t2,1	# increment intensity counter by 1

	addi $v0,$0,4	# code for print null-terminated string service
	la $a0,colon	# null-terminated string address to print labeled colon to $a0 register
	syscall		# execute print null-terminated string service

	lw $t1,($sp)	# load the number of ocurrences for $t2 intensity on $t1 register
	addi $sp,$sp,4	# next word address on intensities vector
	addi $v0,$0,1	# code for print integer number service
	add $a0,$0,$t1	# integer to be printed to $a0
	syscall		# execute print integer number service

	addi $v0,$0,4	# code for print null-terminated string service
	la $a0,close	# null-terminated string named close address to $a0 register
	syscall		# execute print null-terminated string service

	beq $t2,256,l9	# if $t2 is 255 jump to l9 label
	j l8		# else, jump to l8 label to print another intesity pair

	# STEP 4
l9:	addi $v0,$0,4	# code for print null-terminated string service
	la $a0,enter	# null-terminated string named enter address to $ap register
	syscall		# execute print null-terminated string service

	addi $v0,$0,5	# code for read integer number service
	syscall		# execute read integer number service and store number introduced on $v0

	add $t2,$0,$0	# $t2=0, counter for pixels
l12:	lbu $t1,($sp)	# load byte or pixel
	blt $t1,$v0,l10	# if pixel is below $v0 jump to l10 label
	addi $t1,$0,0xFF# else, convert pixel to 255
	j l11		# jump to l11 label
l10:	add $t1,$0,$0	# set to 0 the pixel
l11:	sb $t1,($sp)	# store pixel on same address
	addi $sp,$sp,1	# next pixel address
	addi $t2,$t2,1	# increment the pixels counter
	beq $t0,$t2,l13	# if pixel counter is equal to total pixels, jump to l13 label
	j l12		# else, jump to l12 label to repeat

	# STEP 5
l13:	addi $v0,$0,13	# code for open file service
	la $a0,newfile	# copy the address of null-terminated string containing filename
	addi $a1,$0,1	# open for writing (flasg are 0:read, 1: write)
	add $a2,$0,$0	# mode is ignored ($a2=0)
	syscall		# execute open file service and return file descriptor on $v0
	add $t1,$0,$v0	# save $v0 (file descriptor) in $t1 register

	addi $v0,$0,15	# code for write to file service
	add $a0,$0,$t1	# file descriptor to $a0
	la $a1,buffer	# output buffer address to $a1
	addi $a2,$0,38	# number of characters to write = $a2
	syscall		# execute write to file service

	sub $sp,$sp,$t0	# return $sp to new image first byte
	addi $v0,$0,15	# code for write to file service
	add $a0,$0,$t1	# file descriptor to $a0
	add $a1,$0,$sp	# output buffer address to $a1
	add $a2,$0,$t0	# number of characters to write = $a2
	syscall		# execute write to file service

	addi $v0,$0,10	# code for exit (terminate execution) service
	syscall		# execute exit service
