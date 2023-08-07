.data #data memory region
what0:  .word 0x00FF0000 #define a word with value 0xFFFF0000 (red)
#0000FFFF azul claro
#00FFFF00 amarillo
#00000000 negro
#000000FF azul
#0000F000 verde
#00FF0000 rojo
#00FFFFFF blanco

.text #memory region for the program code
main:	#main label
    li $t1, 0		#put 0 on $t1 register to increment the addres while storing in the loop
    li $t2, 4		#put 4 on $t2 (4 is the number of bytes in a word) to achieve increments in words
    mul $t3,$t2,32	#multiply 32 by 4 for the elements of one row
    mul $t3,$t3,32	#multiply 32x32, the number of rows by number of columns, to store 32x32 elements later
    lw $t4, what0($t1)	#put the word 0xFFFF0000 on $t4 to store on memory
loop:			#label for loop beginning
    sw $t4, what0($t1)	#store the value on $t4 in memory on the direction of the label what0+$t1
    addu $t1, $t1, $t2	#increment $t1 to access to the next word in memory for storing
    bne $t1, $t3, loop	#if $t1=$t3 (32x32, number of elemtens in matrix) stop the iteration
    
    li $v0, 10		#put 10 on $v0 to exit from the program correctly
    syscall		#system call
