.data  
fin: .asciiz "file.txt"      # filename for input
buffer: .space 128	#128 bytes to store the contents of the file to read
.text
# Open file for reading
li   $v0, 13       # system call for open file
la   $a0, fin      # input file name
li   $a1, 0        # flag for reading
li   $a2, 0        # mode is ignored
syscall            # open a file 
move $s0, $v0      # save the file descriptor 

# reading from file just opened
li   $v0, 14       # system call for reading from file
move $a0, $s0      # file descriptor 
la   $a1, buffer   # address of buffer to store the contents of the file
li   $a2,  128  # hardcoded buffer length
syscall            # read from file

# printinf the content of the file
li  $v0, 4          # $v0=4 to print a string to output
la  $a0, buffer     # buffer contains the values
syscall             # print int

# close the file
li $v0,16
move $a0,$s0	#file descriptor saved in $s0 move to $a0
syscall		#execute the file close