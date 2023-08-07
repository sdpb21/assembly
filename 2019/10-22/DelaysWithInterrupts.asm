;MPLAB Excercise 1 - Rotate (Move the LED)

#include "p16f690.inc"
   
	__config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF)
    
; Config defines the configuration word

  org 0 ; org tells the assembler when to start generating code
  GOTO START
  ORG 4
  GOTO TMR0_INT;to indicate the interrupt subroutine

Display equ 20h       ; declare label addresses
Delay1  equ 21h
Delay2  equ 22h
Delay3	equ 23h


START
	BSF STATUS,RP0	;select Register Page 1 (RP)

	CLRF TRISC	;make I/O PORTC all output
	BCF STATUS,RP0	;Back to register page 0
	MOVLW 0x08	;put 00001000 in the working register
	MOVWF Display	;Moves the contents of W to Display
	MOVLW d'252'	;252 to the TMR0 for 1 ms delay
	MOVWF TMR0	;copy to TMR0
	MOVLW 0x01	;
	MOVWF Delay1	;Delay1 inicialization
	MOVLW 0x05
	MOVWF Delay2	;Delay2 inicialization
	MOVLW d'10'
	MOVWF Delay3	;Delay3 inicialization
	MOVLW 0x30	;0x30 to W
	BANKSEL ADCON1	;Move to the ADCON1's bank
	MOVWF ADCON1	;00110000 ADC clock from internal oscillator
	BSF TRISA,4	;Configure RA4 as in
	MOVLW B'00000111';256 prescaler TMR0
	MOVWF OPTION_REG;timer configutation
	BANKSEL ANSEL	;
	CLRF ANSEL	;Configure the fist 8 analog inputs as digital I/O
	BSF ANSEL,3	;Configure RA4(AN3) as analog input
	MOVLW 0x8D	;Store 10001101 in W
	BANKSEL ADCON0	;
	MOVWF ADCON0	;Vdd Vref, AN3, On
	MOVLW B'10100000'
	MOVWF INTCON	;Interrupts configuration: ON & Timer0 Interrupts
	goto $		;infinite loop to achieve Timer0 overflow

TMR0_INT
	BTFSC ADRESH,0	;verify bit 0 of ADRESH to start a "250ms delay"
	GOTO Lb3	;start the "250ms delay"
	BTFSC ADRESH,1	;verify bit 1 of ADRESH to start a "500ms delay"
	GOTO Lb4	;start the "500ms delay"
	MOVLW d'252'	;
	DECFSZ Delay1,f	;countdown for the delay 1
	GOTO INT_END	;go to the last 4 interrupt instructions
	;START CATCH
	BANKSEL ADCON0	;start catch
	BSF ADCON0,1	;GO=1 start conversion
	BTFSC ADCON0,1	;Verifing if conversion is complete
	GOTO $-1	;If isn't, repeat
	;START ROTATE
	BCF STATUS,C	;Clear the carry bit
	BANKSEL Display	;Go to the Displays register bank
	MOVF Display,w	;Copy Display to W
	MOVWF PORTC	;Copy W to PORTC (To the LEDs)
	RRF Display,f	;Rotate Display right
	BTFSC STATUS,C	;Did the bit rotate into the carry?
	GOTO Lb1	;Go to Lb1 if carry=1    (RESET TO ORIGINAL STATE)
    Lb2	
	BANKSEL ADRESL	;reading the 8 low bit of the conversion
	MOVF ADRESL,w	;storing them in W
	BANKSEL Delay1	;
	MOVWF Delay1	;copying the 8 low bits to Delay1 for the variable delay
	MOVLW d'252'	;
	GOTO INT_END	;jump to the 4 last interrupt instructions
    Lb1	MOVLW 0x08	;Put 00001000 in the working register
	MOVWF Display	;Moves the contents of W to Display
	GOTO Lb2	;return to continue the program
    Lb3	MOVLW d'60'	;to copy 60 to TMR0 register to achieve a 50ms delay
	DECFSZ Delay2,f	;to repetat the 50ms delay 5 times to achieve a 250ms delay
	GOTO INT_END	;...
	BCF ADRESH,0	;clear the 0 bit of ADRESH when the 250ms delay ends
	MOVLW 0X05	;
	MOVWF Delay2	;Delay2 inicialization for the next catch
	MOVLW d'60'	;...
	GOTO INT_END	;...
    Lb4	MOVLW d'60'	;...
	DECFSZ Delay3,f	;to repeat the 50ms delay 10 times to achieve a 500ms delay
	GOTO INT_END	;
	BCF ADRESH,1	;clear the 1 bit of ADRESH when the 500ms delay finish
	MOVLW d'10'	;
	MOVWF Delay3	;inicialization of Delay3 for the next catch
	MOVLW d'60'	;...
INT_END	BCF INTCON,T0IF	;clear the Timer0 interrupt flag
	BANKSEL TMR0	;go to the bank where TMR0 is
	MOVWF TMR0	;copy W to TMR0
	RETFIE		;return from interrupt
    END