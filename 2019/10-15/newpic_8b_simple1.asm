; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p16f690.inc"
; CONFIG
; __config 0x3011
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_ON & _CPD_ON & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF

    ;__config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF)
;RES_VECT  CODE    0x0000            ; processor reset vector
  org 0 ; Org 0 Tells the assembler where to start generating code.

Display equ 20h       ; declare label addresses
Delay1  equ 21h		  ; allocated after ports 19 spaces on register
Delay2  equ 22h
Delay3	equ 23h
RESULTHI equ 24h
RESULTLO equ 25h
Number equ 26h	;variable for a final delay

    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

;MAIN_PROG CODE                      ; let linker place main program

START
	BSF STATUS,RP0	; select Register Page 1 (RP)
	CLRF TRISB	;clear TRISB, all pins are output
	CLRF TRISA	; clear TRISA
	BCF STATUS,RP0	; back to memory bank 0
	MOVLW 0x10      ; put 00010000 in the working register, literal value 10
	MOVWF Display   ; moves the contents of Wreg to register - Display
	;;;;;;
	;SFR ADCON0 B'00001101'; analog to digital conversion control register configuration
	;;;;;;
	BANKSEL ADCON1	;move to the bank where ADCON1 is
	MOVLW 0x38	;literal 0x38 to W
	MOVWF ADCON1	;00111000 ADC Frc clock, from internal oscillator
	BANKSEL TRISA	;move to the bank where TRISA is
	BSF TRISA,0	;Set RA0 to input
	BANKSEL ANSEL	;move to the bank where ANSEL register is
	BSF ANSEL,0	;Set RA0 to analog input
	BANKSEL ADCON0	;move to the bank where ADCON0 is
	MOVLW 0x81	;10000001 Right justify
	MOVWF ADCON0	;Vdd Vref,AN0, On
MainLoop
	CALL SampleTime	;call to subroutine where is taken the data from analog input
	CALL Rotate	;call to subroutine where rotate the on led
	GOTO MainLoop	;infinite loop

SampleTime
	BSF ADCON0,GO	;Start conversion cycle
	BTFSC ADCON0,GO	;Is conversion done?
	GOTO $-1	;No, test again
	BANKSEL ADRESH	;move to where the ADC result register high is
	MOVF ADRESH,W	;Read upper two bits of the conversion result and store it in W
	MOVWF RESULTHI	;store in GPR space
	BANKSEL ADRESL	;move to where the ADC result register low is
	MOVF ADRESL,W	;Read lower 8 bits
	BANKSEL RESULTLO;move to the bank where RESULTLO is
	MOVWF RESULTLO	;Store in GPR space
	RETURN		;end of the subroutine

Delay_1ms		;one milisecond delay subroutine
;///////////////////////////////////////////////////////////////////////////////
;///one loop that takes 250 microseconds to execute is repeated four times...///
;///////////////////////////////////////////////////////////////////////////////
	MOVLW 0x5F	;move 250 to W register
	MOVWF Delay1	;move W to Delay1
	MOVLW 0x04	;move 4 to W register
	MOVWF Delay2	;move W to Delay2
	InternalLoop	;label at the beginning of the loop
	DECFSZ Delay1,f	;decrement Delay1 and skip if it is 0
	GOTO InternalLoop;go to the beginning of the loop to repeat it
	MOVLW 0x5F	;move 250 to W register for the next iterarion
	MOVWF Delay1	;move W to Delay1
	DECFSZ Delay2,f	;decrement Delay2 and skip if it is 0
	GOTO InternalLoop; go to repeat the loop
	RETURN		;end of this subroutine, return to the point where was called

Delay_256ms		;256 miliseconds delay loop subroutine
	MOVLW 0xFF	;0xFF=255 at 10 base or decimal, 255 to W
	MOVWF Delay3	;move W to Delay3
	Loop100		;label to countdown from 255 to 0
	CALL Delay_1ms	;call to Delay_1ms subroutine
	DECFSZ Delay3,f	;decrement Delay1 and skip if it is 0
	GOTO Loop100	;go to Loop100 label for another iterarion
	RETURN		;end of this subroutine, return to the point where was called

Rotate
	BCF STATUS,C	;ensure the carry bit is clear
	BANKSEL Display	;move to the bank where Display is
	MOVF Display,w 	;Copy the display to the Wreg
	MOVWF PORTB     ;Copy the Wreg to Port B (to the LEDs)
	RLF Display,f	;Rotate the 1 to the left
	BTFSC STATUS,C  ;Did the bit rotate into the carry?
	GOTO L1		;if the 1 is on the carry go to L1
    L2	BTFSC RESULTHI,0;if the 0 bit of RESULTHI is 1, execute a 250ms delay
	GOTO L3		;go to L3 to execute a 250ms delay
    L4	BTFSC RESULTHI,1;if the 1 bit of RESULTHI is 1, execute two 250ms delays
	GOTO L5		;go to L5 to execute two 250ms delays
    L6	MOVF RESULTLO,W	;move RESULTLO to W
	MOVWF Number	;move W to Number variable
	RotateLoop	;beginning of part of the delay proportional to the analog input value
	CALL Delay_1ms	;call to Delay_1ms subroutine
	DECFSZ Number,f	;countdown of the proportional delay
	GOTO RotateLoop	;go to repeat the loop
	RETURN		;end of the subroutine Rotate
    L1	MOVLW 0x10      ; put 00010000 in the working register, literal value 10
	MOVWF Display   ; moves the contents of Wreg to register - Display
	GOTO L2		;go to L2 to continue
    L3	CALL Delay_256ms;call to Delay_256ms subroutine
	GOTO L4		;go to L4 to continue with the program
    L5	CALL Delay_256ms;call to Delay_256ms subroutine
	CALL Delay_256ms;call to Delay_256ms subroutine
	GOTO L6		;go to L6 to continue with the program execution

    END