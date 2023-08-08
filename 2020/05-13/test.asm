.globl     display

.data
	LINE:			.asciiz				"\n********************************************************\n"
	A.SPACE: 		.asciiz				  "  A="
	B.SPACE: 		.asciiz				  "  B="
	N.SPACE: 		.asciiz				  "  N="
	
.text
TEST1:

	 li		$a0, 	50        # A: 
	 li		$a1, 	10        # B:
	 li		$a2, 	6         # n: number of bits 
   jal 	ex.3.12

	 li		$a0, 	50        # A: 
	 li		$a1, 	10        # B:
	 li		$a2, 	6         # n: number of bits 
   jal 	ex.3.13

	 li		$a0, 	60        # A: 
	 li		$a1, 	17        # B:
	 li		$a2, 	6         # n: number of bits 
   jal 	ex.3.18


TEST2:
	 li		$a0, 	3        	# A: 
	 li		$a1, 	2        	# B:
	 li		$a2, 	4         # n: number of bits 
   jal 	ex.3.12


	 li		$a0, 	3        	# A: 
	 li		$a1, 	2        	# B:
	 li		$a2, 	4         # n: number of bits 
   jal 	ex.3.13

	 li		$a0, 	12        # A: 
	 li		$a1, 	5         # B:
	 li		$a2, 	3         # n: number of bits 
   jal 	ex.3.18


TEST5:									# extra credit

	 li		$a0, 	60       	# A: 
	 li		$a1, 	17        # B: 
	 li		$a2, 	7         # n: number of bits 
    #jal 	ex.3.19

	 li		$a0, 	12        # A: 
	 li		$a1, 	5         # B:
	 li		$a2, 	3         # n: number of bits 
   #jal 	ex.3.19


exit:
	li	$v0, 10
	syscall


display:
    addi  $sp,  $sp,-16
    sw    $a0,  ($sp)
    sw    $a1,  4($sp)
    sw    $a2,  8($sp)
    sw    $ra,  12($sp)
    
    la    $a0,   LINE
    li    $v0,  4
    sysCall

    la    $a0,   A.SPACE   
    li    $v0,  4
    sysCall

		move  $a0,	$t0
    li    $v0,  1
    sysCall

    la    $a0,   B.SPACE   
    li    $v0,  4
    sysCall

		move  $a0,	$a1
    li    $v0,  1
    sysCall

    la    $a0,   N.SPACE   
    li    $v0,  4
    sysCall

		move  $a0,	$a2
    li    $v0,  1
    sysCall

    la    $a0,   LINE
    li    $v0,  4
    sysCall

    lw    $a0,  ($sp)
    lw    $a1,  4($sp)
    lw    $a2,  8($sp)
    lw    $ra,  12($sp)
    addi  $sp,  $sp,16
    jr		$ra

