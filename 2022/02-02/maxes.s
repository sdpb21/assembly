# gcc -no-pie -Wall -Werror maxes.s -o maxes
.data
	#arr: .long 5,14,8,18,20,25,5,13
	#arrlen: .long 8
	vodd: .quad 0
	veven: .quad 0
	omsg: .ascii "Max among odd indices: "
	omsgEnd: .equ omsgl,omsgEnd-omsg
	emsg: .ascii "Max among even indices: "
	emsgEnd: .equ emsgl,emsgEnd-emsg
	nextLine: .byte 10

.bss
	.lcomm res1,1

.text

.global main

main:
	movl arrlen,%ecx	# array lenght to ecx register
	mov $arr,%rsi		# array arr first element address to rsi register
l1:	mov (%rsi),%edx		# array element on rsi address to edx register
	add $4,%rsi		# next array element address
	mov %rcx,%r8		# copy rcx to r8
	and $1,%r8		# if r8 results 1 after AND operation, index is odd
	cmp $1,%r8		# compare r8 with 1
	je odd			# if r8 equals 1, index is odd and jump to odd label
	# not odd
	mov veven,%r9		# copy veven value to r9 register
	cmp %r9,%rdx		# compare actual array element with max value located on even index until now
	jb l2			# if rdx<r9 jump to l2 label
	mov %rdx,veven		# else, store actual array value on veven variable
	jmp l2			# and jump to l2 label to process next array element

odd:	mov vodd,%r9		# copy vood value to r9 register
	cmp %r9,%rdx		# compare actual array element with max value located on odd index until now
	jb l2			# if rdx<r9 jump to l2 label
	mov %rdx,vodd		# else, store actual array value on vodd variable
l2:	loop l1			# if rcx not zero go to l1 label
##############################################################
	mov $4,%rax		# system call number to write
	mov $1,%rbx		# file descriptor (stdout)
	mov $emsg,%rcx		# message to write
	mov $emsgl,%rdx		# message length
	int $0x80		# print message

	# decimal number to ASCII translation:
	mov veven,%rax	# copy veven variable value to rax register
	mov $10,%rbx	# copy 10 to rbx register
	mov $0,%rsi	# clear rsi register
l3:	mov $0,%rdx	# clear rdx register
	div %rbx	# executes division rax/rbx, store reminder on rdx register
	add $'0',%rdx	# translates reminder from decimal format to ASCII
	mov %rdx,res1(%rsi)	# stores reminder on memory
	inc %rsi	# increments rsi register to go to next byte on memory
	cmp %rbx,%rax	# compares rax with rbx
	jae l3		# if rax>rbx jumps to l3 label
	add $'0',%rax	# translates the last reminder to ASCII
	mov %rax,res1(%rsi)	# stores that last reminder on memory

	# print the max from even index on inverse order
l4:	mov $4,%rax	# system call number to write
	mov $1,%rbx	# file descriptor (stdout)
	mov $res1,%rcx	# message to write
	add %rsi,%rcx	# add rsi to the byte address
	dec %rsi	# decrement to point to previous byte
	mov $1,%rdx	# print one character
	int $0x80	# print executes
	cmp $0,%rsi	# compares rsi with zero
	jge l4		# while rsi>=0 jump to l4 label

	# prints \n
	mov $4,%rax	# system call number to write
	mov $1,%rbx	# file descriptor (stdout)
	mov $nextLine,%rcx	# message to write (\n character)
	mov $1,%rdx	# print one byte
	int $0x80	# prints \n

	mov $4,%rax	# system call number to write
	mov $1,%rbx	# file descriptor (stdout)
	mov $omsg,%rcx	# message to write
	mov $omsgl,%rdx	# message length
	int $0x80	# print message

	# decimal number to ASCII translation
	mov vodd,%rax	# copy vodd variable value to rax register
	mov $10,%rbx	# copy 10 to rbx register
	mov $0,%rsi	# clear rsi register
l5:	mov $0,%rdx	# clear rdx register
	div %rbx	# executes division rax/rbx, stores reminder on rdx register
	add $'0',%rdx	# translates reminder from decimal format to ASCII
	mov %rdx,res1(%rsi)	# stores reminder on memory
	inc %rsi	# increments rsi register to go to next byte on memory
	cmp %rbx,%rax	# compares rax with rbx
	jae l5		# if rax>=rbx jumps to l5 label
	add $'0',%rax	# translates the last reminder to ASCII
	mov %rax,res1(%rsi)	# stores that last reminder on memory

	# print the max on odd index on inverse order
l6:	mov $4,%rax	# system call number to write
	mov $1,%rbx	# file descriptor (stdout)
	mov $res1,%rcx	# message to write
	add %rsi,%rcx	# add rsi to the byte address
	dec %rsi	# decrement to point to the previous byte
	mov $1,%rdx	# print one character
	int $0x80	# print executes
	cmp $0,%rsi	# compares rsi register value with zero
	jge l6		# if rsi>=0 jumps to l6 label

	# prints \n
	mov $4,%rax	# system call number to write
	mov $1,%rbx	# file descriptor (stdout)
	mov $nextLine,%rcx	# message to write (\n)
	mov $1,%rdx	# print one character
	int $0x80	# print \n

##############################################################
exit:	mov $1,%rax	# system call number to exit
	xor %rbx,%rbx	# to exit returning zero
	int $0x80	# exit program
