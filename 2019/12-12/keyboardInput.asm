    .data
strn: .asciiz "Please enter a character"
    .eqv    MMIOBASE    0xffff0000

    # Receiver Control Register (Ready Bit)
    .eqv    RCR_        0x0000
    .eqv    RCR         RCR_($s0)

    # Receiver Data Register (Key Pressed - ASCII)
    .eqv    RDR_        0x0004
    .eqv    RDR         RDR_($s0)

    # Transmitter Control Register (Ready Bit)
    .eqv    TCR_        0x0008
    .eqv    TCR         TCR_($s0)

    # Transmitter Data Register (Key Displayed- ASCII)
    .eqv    TDR_        0x000c
    .eqv    TDR         TDR_($s0)

    .text
    .globl  main
main:
    li      $s0,MMIOBASE            # get base address of MMIO area

keyWait:
    lw      $t0,RCR                 # get control reg
    andi    $t0,$t0,1               # isolate ready bit
    beq     $t0,$zero,keyWait       # is key available? if no, loop

    lbu     $a0,RDR                 # get key value
    
displayWait:
    lw      $t1,TCR                 # get control reg
    andi    $t1,$t1,1               # isolate ready bit
    beq     $t1,$zero,displayWait   # is display ready? if no, loop

    sb      $a0,TDR                 # send key to display

    li      $v0,11
    syscall
	li $v0,32	#delay op-code
	li $a0,2000	#number in milliseconds to $a0
	syscall

    j       keyWait
