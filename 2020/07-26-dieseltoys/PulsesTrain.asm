#include "p12f683.inc"
; __config 0x3014 ; 0011 0000 0001 0100
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_ON & _CPD_ON & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF

  org 0
  GOTO START

START

  bsf	STATUS,RP0	; select bank 1
  ;bsf	OSCCON,IRCF0	; sets IRCF0 bit to get an 8MHz internal oscilator frequency
  movlw	b'00111100'
  movwf	TRISIO		; sets GPIO<5:2> as inputs and GPIO<1:0> as outputs
  clrf	ANSEL		; to use pins AN<3:0> as digital I/O, were analog inputs by default
  bcf	OPTION_REG,7	; GPIO pull-up resistors are enabled
  bcf	OPTION_REG,T0CS	; internal clock is the clock sourse for timer0
  bcf	OPTION_REG,PSA	; preescaler asigned to the timer0 module
  ;clrf	PIE1		; disables all peripheral interruptions
  bcf	STATUS,RP0	; select bank 0
  bsf	GPIO,GP1	; sets bit 1 of GPIO
  movlw	b'00000111'	
  movwf	CMCON0		; turns off comparator because it uses 3 GPIO pins
  ;clrf	INTCON		; disables interrupts and clear interrup flags
  ;clrf	PIR1		; clears all peripheral interrupt flags

  bsf	T1CON,TMR1ON
L0 bsf	GPIO,GP0
  movlw	d'45086'
  movwf	TMR1L
  movlw	b'10110000'
  movwf	TMR1H
  b	delay20
H1 bcf	GPIO,GP0
  movlw	d'24646'
  movwf	TMR1L
  movlw	b'01100000'
  movwf	TMR1H
  b	delay40
  
delay20
  btfss	PIR1,TMR1IF
  b	delay20
  bcf	PIR1,TMR1IF
  ;nop
  b	H1
delay40
  btfss	PIR1,TMR1IF
  b	delay40
  bcf	PIR1,TMR1IF
  nop
  b	L0

    END