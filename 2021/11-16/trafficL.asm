#include "p18f45k22.inc"
; CONFIG1H
  CONFIG  FOSC = INTIO67        ; Oscillator Selection bits (Internal oscillator block)
  CONFIG  PLLCFG = OFF          ; 4X PLL Enable (Oscillator used directly)
  CONFIG  PRICLKEN = OFF        ; Primary clock enable bit (Primary clock can be disabled by software)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRTEN = OFF          ; Power-up Timer Enable bit (Power up timer disabled)
  CONFIG  BOREN = OFF           ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 190            ; Brown Out Reset Voltage bits (VBOR set to 1.90 V nominal)

; CONFIG2H
  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (Watch dog timer is always disabled. SWDTEN has no effect.)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC1       ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as digital I/O on Reset)
  CONFIG  CCP3MX = PORTB5       ; P3A/CCP3 Mux bit (P3A/CCP3 input/output is multiplexed with RB5)
  CONFIG  HFOFST = OFF          ; HFINTOSC Fast Start-up (HFINTOSC output and ready status are delayed by the oscillator stable status)
  CONFIG  T3CMX = PORTC0        ; Timer3 Clock input mux bit (T3CKI is on RC0)
  CONFIG  P2BMX = PORTD2        ; ECCP2 B output mux bit (P2B is on RD2)
  CONFIG  MCLRE = INTMCLR       ; MCLR Pin Enable bit (RE3 input pin enabled; MCLR disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = ON              ; Code Protection Block 0 (Block 0 (000800-001FFFh) code-protected)
  CONFIG  CP1 = ON              ; Code Protection Block 1 (Block 1 (002000-003FFFh) code-protected)
  CONFIG  CP2 = ON              ; Code Protection Block 2 (Block 2 (004000-005FFFh) code-protected)
  CONFIG  CP3 = ON              ; Code Protection Block 3 (Block 3 (006000-007FFFh) code-protected)

; CONFIG5H
  CONFIG  CPB = ON              ; Boot Block Code Protection bit (Boot block (000000-0007FFh) code-protected)
  CONFIG  CPD = ON              ; Data EEPROM Code Protection bit (Data EEPROM code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)

RES_VECT  CODE    0x0000            ; processor reset vector
 delay1 equ 00h
 delay2 equ 01h
 delay3	equ 02h
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START

    movlb   0x0f    ; select bank 15 to work with SFR
    clrf    TRISB,1 ; configure all PORTB bits as outputs
    clrf    ANSELB,1; digital input buffer enabled

;When north is green south is red (60 seconds)
;Then north is yellow for short time south is also yellow for short time (5 seconds)
;Then north is red south is green(60 second)
;Then north is yellow for short time south is also yellow for short time (5 seconds) again
    ; north green, south red
loop:
    movlw   b'10000001'
    movwf   PORTB,1 ; north green on, south red on
    call    delayB
    movlw   b'01000010'
    movwf   PORTB,1 ; north yellow on, south yellow on, both green and red off
    call    delayB
    movlw   b'00100100'
    movwf   PORTB,1 ; north red on, south green on
    call    delayB
    movlw   b'01000010'
    movwf   PORTB,1  ; north yellow on, south yellow on, both green and red off
    call    delayB
    goto loop
delayA
    movlw   0x5f
    movwf   delay1,1
    movlw   0x08
    movwf   delay2,1
    loop1
    decfsz  delay1,1,1
    goto    loop1
    movlw   0x05f
    movwf   delay1,1
    decfsz  delay2,1,1
    goto    loop1
    return

delayB
    movlw   0xFF
    movlb   0x00
    movwf   delay3,1
    loop2
    call    delayA
    decfsz  delay3,1,1
    goto    loop2
    movlb   0x0f
    return
    END
