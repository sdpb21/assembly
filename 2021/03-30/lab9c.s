.data 
# TODO: What are the following 5 lines doing?
promptA: .asciiz "Please introduce N: "
promptB: .asciiz "Enter an int: "
result: .asciiz "Product: "
newline: .asciiz "\n"

.globl main
.text

main: 
	addi $t5,$0,0
	li $v0, 4		      
	la $a0, promptA
	syscall    

	li $v0, 5
	syscall 
	move $t0, $v0

	addi $t1,$0,1
l1:	li $v0, 4		      
	la $a0, promptB
	syscall    

	li $v0, 5
	syscall 
	mul $t1,$t1,$v0

	addi $t5,$t5,1
	beq $t0,$t5,ok
	j l1
ok:
	li $v0, 4		      
	la $a0, result
	syscall    
	
	li $v0, 1
	move $a0, $t1
	syscall 

end:	li $v0, 10
	syscall
