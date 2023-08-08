.data

input_key:	.word 0 # input key from the player

game_score:	.word 0 # the game score
game_win_text:	.asciiz "You Win! "
game_lose_text:	.asciiz "Game Over! " #You can learn more tricks to win. 
input_target: .asciiz "Enter the target score for winning a game (in the range [64, 2048]): "


# a 16-dim array representing the 4x4 game board grid 
puzzle_map: .word
2 4 2 4
4 2 4 2
2 4 2 4
0 8 4 8
# previous puzzle map for checking the grid changes 
puzzle_map_prev: .word
0 0 0 0 
0 0 0 2
0 0 4 0
0 0 0 0 
# a temporary puzzle_map, which could be used in check_lose
puzzle_map_temp: .word
0 0 0 0 
0 0 0 0
0 0 0 0
0 0 0 0 
# an array with 4 elements 
arr4: .word
0 0 0 0
# elements in the zero_indices array are the indices of the zero elements in puzzle_map (i.e. empty spots in the game grid)
# could be used in generate_a_random_tile. 
zero_indices:  .word
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 

num_zero_tiles: .word 0
zero_ind_ind:	.word 0
X:		.word 0

# target number for winning the game
target: .word  2048

.text
		# read the input target score and store
main:		jal input_game_target_score
		# create the game screen and background	
		li $v0, 200 
		syscall
		# pass the input target to the game screen
		lw $a0, target
		li $v0, 204 
		syscall

		# initalize the 2048 game grid
game_start: 	jal generate_a_new_game_map_randomly # overwrite puzzle_map with a new map with 2 random non-zero elements
		li $v0, 201	 # refresh the screen with the new puzzle map
		la $a0, puzzle_map
		syscall
		 
		# 1. read keyboard input
game_loop:	jal get_keyboard_input
		la $t0, input_key 
		lw $t7, 0($t0) # new input key
		
		# 2. core sliding operations for valid keyboard inputs 
		li $t0, 119 # corresponds to key 'w'
		beq $t7, $t0, process_slide_operation  
		li $t0, 115 # corresponds to key 's'
		beq $t7, $t0, process_slide_operation
		li $t0, 97 # corresponds to key 'a'
		beq $t7, $t0, process_slide_operation
		li $t0, 100 # corresponds to key 'd'
		beq $t7, $t0, process_slide_operation
		
		j game_nap # sleep some ms then jump to game_loop for invalid keyboard inputs
		

		# 3. update game status after a slide operation. 
	game_update_status:		jal update_game_score # update the game score as the max number of the puzzle
		jal check_win # check whether a game is won and process it. (the game terminates if win)
		bne $v0, $zero, game_win
		
		#   check any tile moved after a slide operation. (a new number will only be generated if tiles are moveable.)
		la $a0, puzzle_map
		la $a1, puzzle_map_prev
		jal check_map_changed
		beq $v0, $zero, game_loop # no tile moved after slide, restart game_loop.
		
		# refresh the game screen, sleep for while to highlight the new generated number
		li $v0, 201 # refresh the screen with the new puzzle map
		la $a0, puzzle_map
		syscall
		li $a0, 150
		jal have_a_nap # sleep $a0 ms
		
		# 4. generate a new non-zero tile in an empty spot
		jal generate_a_random_tile
		
		# 5. check whether the game is lost and take actions. 
		jal check_lose # check after the last new tile is filled
		bne $v0, $zero, game_lose
			
		# 6. refresh the screen with the new puzzle map
		li $v0, 201 
		la $a0, puzzle_map
		syscall

	game_nap: li $a0, 30 
		jal have_a_nap 
		j game_loop
		
	game_win: jal actions_for_win
		li $v0, 10 # terminate this program
		syscall
		
	game_lose: jal actions_for_lose
		li $v0, 10 # terminate this program
		syscall
				
				
process_slide_operation: la $a0, puzzle_map
	la $a1, puzzle_map_prev
	jal copy_map0_to_map1 # save the current map for the tile movement checking, i.e., puzzle_map_prev = puzzle_map
	
	lw $t7, input_key # load key value
	
	# slide the puzzle map in a given direction
	la $a0, puzzle_map # set input param for map_slide_* procedure
	li $t0, 119 # 'w'
	beq $t7, $t0, slide_up  
	li $t0, 115 # 's'
	beq $t7, $t0, slide_down
	li $t0, 97 # 'a'
	beq $t7, $t0, slide_left
	li $t0, 100 # 'd'
	beq $t7, $t0, slide_right
	slide_up: jal map_slide_up
	  j game_update_status
	slide_down: jal map_slide_down
	  j game_update_status
	slide_left: jal map_slide_left
	  j game_update_status
	slide_right: jal map_slide_right
	  j game_update_status

#--------------------------------------------------------------------
# procedure: slide a given puzzle map in the right direction
# input: $a0, address of the puzzle map to be slided
# result: the input puzzle map will be changed. 
#--------------------------------------------------------------------
map_slide_right: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero # load the address of the puzzle map to be slided

	addi  $a0, $s0, 0	# slide 1st row
	addi  $a1, $s0, 4  
	addi  $a2, $s0, 8  
	addi  $a3, $s0, 12
	jal slide

	addi  $a0, $s0, 16	# slide 2nd row
	addi  $a1, $s0, 20  
	addi  $a2, $s0, 24  
	addi  $a3, $s0, 28
	jal slide

	addi  $a0, $s0, 32	# slide 3rd row
	addi  $a1, $s0, 36  
	addi  $a2, $s0, 40  
	addi  $a3, $s0, 44
	jal slide

	addi  $a0, $s0, 48	# slide 4th row
	addi  $a1, $s0, 52  
	addi  $a2, $s0, 56  
	addi  $a3, $s0, 60
	jal slide
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra 
	
#--------------------------------------------------------------------
# procedure: slide a given puzzle map in the left direction
# input: $a0, address of the puzzle map to be slided
# result: the input puzzle map will be changed. 
#--------------------------------------------------------------------
map_slide_left: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero 


	addi  $a0, $s0, 12	# slide 1st row
	addi  $a1, $s0, 8  
	addi  $a2, $s0, 4  
	addi  $a3, $s0, 0
	jal slide

	addi  $a0, $s0, 28	# slide 2nd row
	addi  $a1, $s0, 24  
	addi  $a2, $s0, 20  
	addi  $a3, $s0, 16
	jal slide

	addi  $a0, $s0, 44	# slide 3rd row
	addi  $a1, $s0, 40  
	addi  $a2, $s0, 36  
	addi  $a3, $s0, 32
	jal slide

	addi  $a0, $s0, 60	# slide 4th row
	addi  $a1, $s0, 56 
	addi  $a2, $s0, 52  
	addi  $a3, $s0, 48
	jal slide
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra	
		

#--------------------------------------------------------------------
# procedure: slide a given puzzle map in the down direction
# input: $a0, address of the puzzle map to be slided
# result: the input puzzle map will be changed. 
#--------------------------------------------------------------------
map_slide_down: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero 

	addi  $a0, $s0, 0	# slide 1st row
	addi  $a1, $s0, 16  
	addi  $a2, $s0, 32  
	addi  $a3, $s0, 48
	jal slide

	addi  $a0, $s0, 4	# slide 2nd row
	addi  $a1, $s0, 20  
	addi  $a2, $s0, 36  
	addi  $a3, $s0, 52
	jal slide

	addi  $a0, $s0, 8	# slide 3rd row
	addi  $a1, $s0, 24  
	addi  $a2, $s0, 40  
	addi  $a3, $s0, 56
	jal slide

	addi  $a0, $s0, 12	# slide 4th row
	addi  $a1, $s0, 28  
	addi  $a2, $s0, 44  
	addi  $a3, $s0, 60
	jal slide
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra 

#--------------------------------------------------------------------
# procedure: slide a given puzzle map in the up direction
# input: $a0, address of the puzzle map to be slided
# result: the input puzzle map will be changed. 
#--------------------------------------------------------------------
map_slide_up: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero 

	addi  $a0, $s0, 48	# slide 1st row
	addi  $a1, $s0, 32  
	addi  $a2, $s0, 16  
	addi  $a3, $s0, 0
	jal slide

	addi  $a0, $s0, 52	# slide 2nd row
	addi  $a1, $s0, 36  
	addi  $a2, $s0, 20  
	addi  $a3, $s0, 4
	jal slide

	addi  $a0, $s0, 56	# slide 3rd row
	addi  $a1, $s0, 40  
	addi  $a2, $s0, 24  
	addi  $a3, $s0, 8
	jal slide

	addi  $a0, $s0, 60	# slide 4th row
	addi  $a1, $s0, 44  
	addi  $a2, $s0, 28  
	addi  $a3, $s0, 12
	jal slide
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra 

#--------------------------------------------------------------------
# procedure: slide($a0, $a1, $a2, $a3)   (Core) 
#    slide 4 numbers in a row or column, say n0,n1,n2,n3. 
#    slide n0,n1,n2,n3 in the direction of n0->n1->n2->n3 as far as possible until they hit the boundary or a non-zero number.
# input: $a0, $a1, $a2, $a3 are the addresses of the 4 numbers of a column or row
# result: the 4 numbers will be shifted and merged in the direction of $a0 -> $a3, according to the 2048 game rules.
#--------------------------------------------------------------------
slide:	addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	lw $t0, 0($a0)	# load n1,n2,n3,n4 values
	lw $t1, 0($a1)
	lw $t2, 0($a2)
	lw $t3, 0($a3)
	
	add $t7, $zero, $zero	# t7 is used as a flag to indicate whether a merge operation is performed. 
	
	bne $t3, $zero, exit_t3ne0 # go to label if t3 not 0
	add $t3, $t2, $zero
	add $t2, $t1, $zero
	add $t1, $t0, $zero
	add $t0, $zero, $zero
	exit_t3ne0:
	#***** Task 3: slide and merge the numbers in a row or column.  
	# hint: the sliding operation can be decomposited into 3 steps
	# step 1, move non-zero tiles to the end and squeeze the intermediate zero tiles. e.g. [0,2,0,2] -> [0,0,2,2]. 
	# step 2, merge two neigboring tiles if they are equal, e.g. [2,2,2,2] -> [0,4,0,4]. 
	#        (Note: DO NOT merge them recursively, i.e., [2,2,2,2] -> [0,0,0,8], which violates the 2048 game rule).
	# step 3, repeat step 1 for alignment, [0,4,0,4] -> [0,0,4,4]
	#------ Your code starts here ------
	li $t4,0
	ori $t4,$t3,0
	or $t4,$t4,$t2
	or $t4,$t4,$t1
	or $t4,$t4,$t0
	beqz $t4,allz	# if all the values are 0 then store and exit, else:
	
t3ez:	bnez $t3,t3nz	# if $t3 is not 0, go to t3nz label
	move $t3,$t2	# move $t2 to $t3
	move $t2,$t1	# move $t1 to $t2
	move $t1,$t0	# move $t0 to $t1
	move $t0,$0	# move 0 to $t0
	j t3ez		# go to t3ez label to verify if $t3 is 0 again

t3nz:	li $t4,1	# to count iterations of this loop
t2ez:	bnez $t2,t2nz	# if $t2 is not 0 go to t2nz label
	move $t2,$t1	# move $t1 to $t2
	move $t1,$t0	# move $t0 to $t1
	move $t0,$0	# move 0 to $t0
	addi $t4,$t4,1	# increment the counter in 1
	beq $t4,4,allz	# if $t4==4 it's because there are just zeros from $t2 to $t0 and loop must finish
	j t2ez		# verify if $t2 is 0 again

t2nz:	bnez $t1,t1nz	# if $t1 is not 0, go to t1nz label
	move $t1,$t0	# move $t0 to $t1
	move $t0,$0	# move 0 to $t0

t1nz:	bnez $t7,allz	# if there are merges, go to allz label
	bne $t3,$t2,t3net2	# if $t3 is not equal to $t2 go to t3net2 label
	add $t3,$t3,$t2	# if $t3 and $t2 are equal, add them
	move $t2,$0	# place 0 on $t2
	li $t7,1	# set the flag to indicate a merge
	j t2net1	# if $t3 is equal to $t2 executes this line
t3net2:	bne $t2,$t1,t2net1	# if $t2 is not equal to $t1 go to t2net1 label
	add $t2,$t2,$t1	# if $t2 and $t3 are equal, add them
	move $t1,$0	# place 0 on $t1
	li $t7,1	# set the flag to indicate a merge
	j t2et1
t2net1:	bne $t1,$t0,t2et1	# if $t1 is not equal to $t0, go to t2et1 label
	add $t1,$t1,$t0	# if $t0 and $t1 are equal, add them
	move $t0,$0	# place 0 on $t0
	li $t7,1	# set the flag to indicate a merge

t2et1:	bnez $t7,t3ez	# if a merge was performed go to t3ez label
allz:
	#------ Your code ends here ------	
   
	sw $t0, 0($a0)	# store new values to the map
	sw $t1, 0($a1)
	sw $t2, 0($a2)
	sw $t3, 0($a3) 
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra		# return
	
#--------------------------------------------------------------------
# procedure: generate_a_new_game_map_randomly
# result: overwrite puzzle_map with a 4x4 map with two random non-zero tiles. 
#--------------------------------------------------------------------	
generate_a_new_game_map_randomly: addi $sp, $sp, -4  # push 
	sw $ra, 0($sp)
	
	la $a0, puzzle_map
	jal clear_map		   # clear the puzzle map
	jal generate_a_random_tile # generate two non-zero tiles randomly
	jal generate_a_random_tile
	
	lw $ra, 0($sp)	#pop
	addi $sp, $sp, 4
	jr $ra	

#--------------------------------------------------------------------
# procedure: clear_map($a0)
# input: $a0, address of a puzzle map
# result: set all elements in the puzzle map to be 0
#--------------------------------------------------------------------
	#***** Task 1: zero out all elements in the puzzle map. 
	# The address of the puzzle map is already loaded into $a0 as an input parameter. 
	#------ Your code starts here ------
clear_map: li $t0,0
cml:	sw $0,($a0)	# store 0 on the memory direction in $a0
	addi $a0,$a0,4	# go to the next word in memory
	addi $t0,$t0,1	# counter for the elements of the array
	beq $t0,16,cmend# finish the procedure if $t0==16
	j cml

	#------ Your code ends here ------
cmend:	jr $ra

#--------------------------------------------------------------------
# procedure: generate_a_random_tile()
# result: a zero tile in puzzle_map will be replaced by a random number (either 2 or 4).  
#--------------------------------------------------------------------
generate_a_random_tile: la $t0, puzzle_map
	la $t1, zero_indices
	
	#***** Task 2: generate a non-zero tile with the value of 2 or 4 (uniformly at random) in an empty spot in the game grid. 
	# hint: 
	# step 1: find the indices of zero tiles and save them in array zero_indices and count the number of zero tiles (named num_zero_tiles)
	# step 2: generate a random integer in range [0, num_zero_tiles) using syscall service 42, let's denote it as zero_ind_ind
	# step 3: generate a random integer among 2 and 4, let's denote it as X. 
	# step 4: set puzzle_map[zero_indices[zero_ind_ind]] = X
	#------ Your code starts here ------
	li $t2,0	# puzzle_map array index counter
	li $t4,0	# zero elements counter
grtl:	beq $t2,16,s1end# if index counter is 16, go to step 2
	lw $t3,($t0)	# store on $t3 the element on the direction stored on $t0
	bnez $t3,isnz	# if $t3 is not 0 go to isnz label
	sw $t2,($t1)	# store on memory the index of the 0 element in the puzzle_map array
	addi $t1,$t1,4	# go to the next word on the zero_indices array
	addi $t4,$t4,1	# increase in 1 the number of zero elements
isnz:	addi $t2,$t2,1	# increase index counter
	addi $t0,$t0,4	# go to the next element in the puzzle_map array
	j grtl		# repeat the loop
s1end:	sw $t4,num_zero_tiles($0)	# store the number of zeros on memory
	lw $a1,num_zero_tiles($0)
	li $v0,42
	syscall		# generates a random integer on [0,$a1) and stores it on $a0
	sw $a0,zero_ind_ind($0)	# stores $a0 on memory
	li $a1,5	# upper bound of random integer generator interval
l2or4:	syscall		# stores in $a0 a random integer in [0,5)
	beq $a0,2,s2or4	# if $a0 is 2 go to s2or4 label
	beq $a0,4,s2or4	# if $a0 is 4 go to s2or4 label
	j l2or4
s2or4:	sw $a0,X($0)
	lw $t4,zero_ind_ind($0)
	mulu $t4,$t4,4
	lw $t4,zero_indices($t4)
	mulu $t4,$t4,4
	sw $a0,puzzle_map($t4)
	#------ Your code ends here ------
	
	jr $ra		# return
	
#--------------------------------------------------------------------
# procedure: check_map_changed($a0, $a1)
# input: $a0 - map0, $a1 - map1
# return: $v0=0 if the two maps are identical, otherwise $v0=1
#--------------------------------------------------------------------	
check_map_changed: add $t0, $a0, $zero
	add $t1, $a1, $zero
	add $t7, $zero, $zero	#i, counter 
	li $t6, 16
	add $v0, $zero, $zero # return value
	
	# for (i=0;i<16;i++) {if (map_prev[i]!=map[i]) {moved=1; goto }}
	loop_compare: bne $t7, $t6, if_compareloop_not_done  # if i<16,in for (i=0;i<16;i++)
	j end_if_compareloop_not_done
	if_compareloop_not_done: lw $t3, 0($t0)
	  lw $t4, 0($t1)
	  #if (map_prev[i]!=map[i])
	  bne $t3, $t4, if_find_moved_tile  # if (map_prev[i]!=map[i])
	  j end_if_find_moved_tile
	  if_find_moved_tile: li $v0, 1
	    j end_if_compareloop_not_done # goto the end
	  end_if_find_moved_tile: addi $t0, $t0, 4 # point to next element to be copied
	  addi $t1, $t1, 4 
	  addi $t7, $t7, 1 # i++
	  j loop_compare
	end_if_compareloop_not_done: jr $ra		# return
	
#--------------------------------------------------------------------
# procedure: check_process_win()
# return: $v0=1 if win, $v0=0 if not win yet. 
#--------------------------------------------------------------------
check_win: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)

	li $v0, 0

	#***** Task 4: check game win.
	#------ Your code starts here ------
	lw $t0,target($0)	# load on $t0 the target value
	li $t1,0	# variable to access to the puzzle_map elements
cwl1:	lw $t2,puzzle_map($t1)	# store on $t2 the puzzle_map element pointed
	bge $t2,$t0,cwl2	# if an element on puzzle_map is equal or greater than $t0, go to cwl2 label
	addi $t1,$t1,4	# increment $t1 to access the next element on puzzle_map
	bne $t1,64,cwl1	# repeat the loop if $t1 is less than 64
	j nowon		# if this executes the player has not reached the target
cwl2:	li $v0,1	# to indicate that the player reached the target
nowon:
	#------ Your code ends here ------
	
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra		# return	

#--------------------------------------------------------------------
# procedure: actions_for_win 
#  perform a series of actions after winning the game
#--------------------------------------------------------------------
actions_for_win: addi $sp, $sp, -4  # push 
	sw $ra, 0($sp)
	
	la $a0, puzzle_map # refresh screen  
	li $v0, 201
	syscall
	li $a0, 4 # play the sound of passing a game level
	li $a1, 0
	li $v0, 202
	syscall
	li $a0, 120
	jal have_a_nap # sleep $a0 ms
	la $a3, game_win_text # display game winning message 
	li $a0, -2 # special ID for this text object
	addi $a1, $zero, 180 # display the message at coordinate (x=$a1, y=$a2)
	addi $a2, $zero, 300
	li $v0, 207 # create object of the game winning or losing message	
	syscall  
	li $a0, 0 # stop background sound
	li $a1, 2
	li $v0, 202
	syscall

	lw $ra, 0($sp)	#pop
	addi $sp, $sp, 4
	jr $ra		# return

#--------------------------------------------------------------------
# procedure: check_lose()
# return: $v0=1 if lose, $v0=0 otherwise. 
#--------------------------------------------------------------------
check_lose: addi $sp, $sp, -8  # push 
	sw $ra, 4($sp)
	sw $s0, 0($sp)
	
	li $v0, 0
	
	#***** Task 5: check game lose. 
	#------ Your code starts here ------
	la $t0,puzzle_map	#
	addi $t1,$t0,64		# upper limit for loop
find0:	lw $t2,($t0)		# load in $t2 the puzzle_map element to compare with 0
	beqz $t2,nolose		# if an element is 0 the player has not lose the game, then exit
	addi $t0,$t0,4		# increment to access the next element in puzzle_map
	bne $t0,$t1,find0	# if a 0 is not found on puzzle_map go to find0 label, if 0 is not found, executes next line

	la $t0,puzzle_map	# search in columns
	move $t4,$t0		# copy $t0 to $t4
	addi $t5,$t0,16		# maximum limit for columns
nextc2:	addi $t3,$t0,48		# direction of element 4 in the column
nextr:	lw $t1,($t0)		# nearest elements in a column
	lw $t2,16($t0)		# element on next row to $t2
	beq $t1,$t2,nolose	# if there are 2 equal elements, exit
	addi $t0,$t0,16		# go to the next element in the column
	beq $t0,$t3,nextc	# if reached 3rd element in column, go to the next column
	j nextr			# go to next row
nextc:	addi $t4,$t4,4		# go to the next column
	beq $t4,$t5,nextl	# finish
	move $t0,$t4		# moves the direction of the element 1 of next column to $t0
	j nextc2		# repeat all again for the next column

nextl:	la $t0,puzzle_map	# search by rows
	move $t4,$t0		# $t4 will be used to move to the next row
	addi $t5,$t0,64		# $t5 is the maximum limit for rows
nextr2:	addi $t3,$t0,12		# $t3 is the maximum limit to go from a column to the next
nextc1:	lw $t1,($t0)		# element in a row
	lw $t2,4($t0)		# next nearest element in the same row
	beq $t1,$t2,nolose	# if 2 nearest elements in a row are equal, finish
	addi $t0,$t0,4		# next column on the row
	beq $t0,$t3,nextr1	# increment the index for the next row
	j nextc1		# repeat again for the next column in the same row
nextr1:	addi $t4,$t4,16		# locate at the beginning of the next row
	beq $t4,$t5,setv0	# if t4==t5 there are not elements that can be merged, so game must finish
	move $t0,$t4		# move the direction of element 1 of next row to $t0
	j nextr2		# repeat all again for the next row

setv0: li $v0,1

	#la $t0,puzzle_map
	#li $t1,0		# column index
	#li $t3,4		# data size and number of columns
#nextc2:	li $t2,0		# row index
#nextr:	jal row_major
	#lw $t4,($v1)
	#addi $t2,$t2,1		# next row
	#beq $t2,$t3,nextc	# if row index == 4, go to next column
	#jal row_major
	#lw $t5,($v1)
	#beq $t4,$t5,nolose	# if t4 == t5 finish
	#j nextr			# go to next row
#nextc:	addi $t1,$t1,1		# next column
	#beq $t1,$t3,nolose	# end of the loops
	#j nextc2	
nolose:
	#------ Your code starts here ------
	lw $ra, 4($sp)	#pop
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
#--------------------------------------------------------------------
#row_major: addi $sp,$sp,-4
	#sw $ra,($sp)

	#mulu $v1,$t2,$t3	# row index * number of columns to $t4
	#addu $v1,$v1,$t1	# + column index
	#mulu $v1,$v1,$t3	# * data size
	#addu $v1,$v1,$t0	# + base address

	#lw $ra,($sp)	#pop
	#addi $sp,$sp,4
	#jr $ra		# return
#--------------------------------------------------------------------
# procedure: actions_for_lose
#  perform a series of actions after winning the game
#--------------------------------------------------------------------
actions_for_lose: addi $sp, $sp, -4  # push 
	sw $ra, 0($sp)
	
	la $a0, puzzle_map # refresh screen 
	li $v0, 201
	syscall
	li $a0, 3     # play the sound of losing the game
	li $a1, 0
	li $v0, 202
	syscall
	la $a3, game_lose_text # display game winning message 
	li $a0, -1 # special ID for this text object
	addi $a1, $zero, 180 # display the message at coordinate (x=$a1, y=$a2)
	addi $a2, $zero, 300
	li $v0, 207 # create object of the game winning or losing message	
	syscall 
	
	lw $ra, 0($sp)	#pop
	addi $sp, $sp, 4
	jr $ra		# return
	
#--------------------------------------------------------------------
# procedure: copy_map0_to_map1($a0, $a1)
# input: $a0 - addr of map0, $a1 - addr of map1
#--------------------------------------------------------------------
copy_map0_to_map1: add $t0, $a0, $zero
	add $t1, $a1, $zero
	
	add $t7, $zero, $zero	#i, counter 
	li $t6, 16
	# for (i=0;i<16;i++) {map_prev[i]=map[i]}
	loop_copy: bne $t7,$t6, if_copy_not_done
	j end_if_copy_not_done
	if_copy_not_done: lw $t3, 0($t0)
	  sw $t3, 0($t1)
	  addi $t0, $t0, 4 # point to next element to be copied
	  addi $t1, $t1, 4
	  addi $t7, $t7, 1 # i++
	  j loop_copy
	end_if_copy_not_done: jr $ra		# return
	
#--------------------------------------------------------------------
# procedure: update_game_score()
# Find the max number in puzzle_map and take it to update the obtained game score. 
#--------------------------------------------------------------------
update_game_score: addi $sp, $sp, -4  # push 
	sw $ra, 0($sp)
	
	la  $a0, puzzle_map
	li  $a1, 16
	jal find_max
	add $a0, $v0, $zero  # $a0=max_val
	li $v0, 203
	syscall
	
	lw $ra, 0($sp)	#pop
	addi $sp, $sp, 4
	jr $ra 

#--------------------------------------------------------------------
# procedure: find_max($a0, $a1), find the max element in an array. 
# input: $a0: array address. $a1: the length of the array. 
# return: $v0, the max element
#--------------------------------------------------------------------
find_max: add $t0, $a0, $zero
	add $t1, $a1, $zero # len
	add $t7, $zero, $zero	#i, counter
	add $v0, $zero, $zero # temp max 
	
	loop_findmax: bne $t7,$t1, if_findmax_not_done
	j end_if_findmax_not_done
	if_findmax_not_done: lw $t3, 0($t0)
	  slt $t5, $v0, $t3
	  beq $t5, $zero, exit_update_max  # if max >= arr[i], exit
	    add $v0, $t3, $zero   # max = arr[i]
	  exit_update_max: addi $t0, $t0, 4 # point to next element to be copied
	  addi $t7, $t7, 1 # i++
	  j loop_findmax
	end_if_findmax_not_done: jr $ra 

#--------------------------------------------------------------------
# procedure: have_a_nap($a0)
# The grogram sleeps for $a0 milliseconds
#--------------------------------------------------------------------
have_a_nap: li $v0, 32 # syscall: let mars java thread sleep $a0 milliseconds
	syscall
	jr $ra
	
#--------------------------------------------------------------------
# procedure: get_keyboard_input
# If an input is available, save its ASCII value in the array input_key,
# otherwise save the value 0 in input_key.
#--------------------------------------------------------------------
get_keyboard_input: add $t2, $zero, $zero
	lui $t0, 0xFFFF
	lw $t1, 0($t0)
	andi $t1, $t1, 1
	beq $t1, $zero, gki_exit
	lw $t2, 4($t0)

	gki_exit: la $t0, input_key 
	sw $t2, 0($t0) # save input key
	jr $ra

#--------------------------------------------------------------------
# procedure: input_game_target_score
# get the following information interactively from the user:
# 1) the target number for a win
# the results will be placed in $v0 and stored in target 
#--------------------------------------------------------------------
input_game_target_score: la $a0, input_target
	li $v0, 4
	syscall # print string
	li $v0, 5
	syscall # read integer
	la $t0, target
	sw $v0, 0($t0) # store
	
	jr $ra

