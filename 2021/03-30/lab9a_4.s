.data 
# TODO: What are the following 5 lines doing?
promptA: .asciiz "Enter an int A: "
promptB: .asciiz "Enter an int B: "
resultAdd: .asciiz "A + 42 = "
resultSub: .asciiz "B - A = "
newline: .asciiz "\n"
modd: .asciiz "THIS IS ODD\n"
meven: .asciiz "THIS IS EVEN\n"

.globl main
.text

main: 
    # TODO: Set a breakpoint here and step through. 
    # What does this block of 3 lines do?
	li $v0, 4		      
	la $a0, promptA
	syscall    

    # TODO: Set a breakpoint here and step through. 
    # What does this block of 3 lines do?
	li $v0, 5
	syscall 
	move $t0, $v0

	andi $v0,0x00000001
	beqz $v0,even
	li $v0, 4		      
	la $a0, modd
	syscall
	j next
even:
	li $v0, 4		      
	la $a0, meven
	syscall    
next:
    # TODO: What is the value of "promptB"? Hint: Check the
    # value of $a0 and see what it corresponds to.
	li $v0, 4
	la $a0, promptB
	syscall

    # TODO: Explain what happens if a non-integer is entered
    # by the user.
	li $v0, 5
	syscall 
    # TODO: t stands for "temp" -- why is the value from $v0 
    # being moved to $t1?
	move $t1, $v0
	andi $v0,0x00000001
	beqz $v0,even2
	li $v0, 4		      
	la $a0, modd
	syscall
	j done
even2:
	li $v0, 4		      
	la $a0, meven
	syscall    
done:

	# TODO: What if I want to get A + 1 and B + 42 instead
	add $t2, $t0, 42 
	sub $t3, $t1, $t0

	li $v0, 4
	la $a0, resultAdd
	syscall

    # TODO: What is the difference between "li" and "move"?
	li $v0, 1
	move $a0, $t2	
	syscall 

    # TODO: Why is the next block of three lines needed? 
    # Remove them and explain what happens.
	li $v0, 4
	la $a0, newline
	syscall 

	li $v0, 4
	la $a0, resultSub
	syscall

	move $a0, $t3	
	li $v0, 1
	syscall 

	li $v0, 4
	la $a0, newline
	syscall 

	li $v0, 10
	syscall
