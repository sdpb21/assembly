   .data
str1:
   .asciiz "abba"
str2:
   .asciiz "racecar"
str3:
   .asciiz "swap paws",
str4:
   .asciiz "not a palindrome"
str5:
   .asciiz "another non palindrome"
str6:
   .asciiz "almost but tsomla"

# array of char pointers = {&str1, &str2, ..., &str6}
ptr_arr:
   .word str1, str2, str3, str4, str5, str6, 0

yes_str:
   .asciiz " --> Y\n"
no_str:
   .asciiz " --> N\n"

   .text

# main(): ##################################################
#   char ** j = ptr_arr
#   while (*j != 0):
#     rval = is_palindrome(*j)
#     printf("%s --> %c\n", *j, rval ? yes_str: no_str)
#     j++
#
main:
   li   $sp, 0x7ffffffc    # initialize $sp

   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, ptr_arr        # use s0 for j. init ptr_arr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # while (*j != 0):
   move $a0, $s1           #    print_str(*j)
   li   $v0, 4
   syscall
   move $a0, $s1           #    v0 = is_palindrome(*j)
   jal  is_palindrome
   beqz $v0, main_print_no #    if v0 != 0:
   la   $a0, yes_str       #       print_str(yes_str)
   b    main_print_resp
main_print_no:             #    else:
   la   $a0, no_str        #       print_str(no_str)
main_print_resp:
   li   $v0, 4
   syscall

   addu $s0, $s0, 4       #     j++
   b    main_while        # end while
main_end:

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   jr    $ra                # return to kernel
# end main ################################################

strlen:
	# PROLOGUE
	#subu $sp,$sp,8	#subu $sp, $sp, 8	# expand stack by 8 bytes
	#sw $ra, 8($sp)	# push $ra (ret addr, 4 bytes)
	#sw $fp, 4($sp)	# push $fp (4 bytes)
	#addu $fp, $sp, 8	# set $fp to saved $ra

	# BODY
	li $t0, 0	#initializes count to 0
loop:
	lb $t1, 0($a0)
	beqz $t1, exit	#checks for null character
	addi $a0, $a0, 1	#increments pointer
	addi $t0, $t0, 1
	j loop	#returns to loop

	# EPILOGUE
exit:
	move $v0, $t0
	#move $sp, $fp
	#lw $ra, 8($sp)
	#lw $fp, 4($sp)
	#addi $sp,$sp,8
	jr $ra

is_palindrome:
    sub     $sp,    $sp,    8                   #allocate memory on stack
    sw      $ra     0($sp)                      #save return address
    sw      $a0     4($sp)                      #save argument value

    jal     strlen                              #call strlen
    move    $t0,    $v0                         #save result

    lw      $a0     4($sp)                      #load argument
    move    $t1,    $a0                         #save its value to t1

    li      $t2,    1                           #set counter to 1
    li      $v0,    1                           #return value = 1
    div     $t3,    $t0,    2                   #calculate string length / 2
    addi    $t3,    $t3,    1                   #add one more
palindrom_loop:
    bge     $t2,    $t3     palindrom_exit      #when counter reaches half of the string length - exit
    lb      $t4,    0($a0)                      #get character from beginning

    sub     $t5,    $t0,    $t2                 #subtract counter from the string length
    add     $t6,    $t5,    $t1                 #$t6 = next element beginning from the string end
    lb      $t7,    0($t6)                      #get corresponding character from the end of the string

    beq     $t4,    $t7,    palindrom_continue  #check to determine are the characters exact match
    li      $v0,    0                           #if not return 0, immediately
    j       palindrom_exit

palindrom_continue:
    addi    $a0,    $a0,    1                   #shift pointer to string one space right
    addi    $t2,    $t2,    1                   #increment counter by one
    j       palindrom_loop

palindrom_exit:
    lw      $ra     0($sp)                      #load return address
    addi    $sp,    $sp,    8                   #free stack
    jr      $ra                                 #return
