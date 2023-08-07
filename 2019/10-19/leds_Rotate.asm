#include "p16f690.inc"
    __config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF)
    ; Config defines the configuration word
  org 0 ; org tells the assembler when to start generating code
Display equ 20h       ; declare label addresses
Delay1  equ 21h
Delay2  equ 22h
Delay3	equ 23h
ResHi equ 24h
ResLow equ 25h
Cnt equ 26h	;counter
    GOTO    START                   ; go to start
START
	BSF STATUS,RP0; select Register Page 1 (RP)
	CLRF TRISA; clear TRISA
	CLRF TRISC; make I/O PORTC all output
	BCF STATUS,RP0; Back to register page 0
	MOVLW 0x08; put 00001000 in the working register
	MOVWF Display; Moves the contents of W to Display
	MOVLW 0x30;0x30 to W
	BANKSEL ADCON1;Move to the ADCON1's bank
	MOVWF ADCON1;00110000 ADC clock from internal oscillator
	BANKSEL TRISA;Move to the TRISA's bank
	BSF TRISA,4;Configure RA4 as in
	BANKSEL ANSEL;Go to the ANSEL register's bank
	CLRF ANSEL;Configure the fist 8 analog inputs as digital I/O
	BSF ANSEL,3;Configure RA4(AN3) as analog input
	MOVLW 0x8D;Store 10001101 in W
	BANKSEL ADCON0;Go to the ADCON0 register's bank
	MOVWF ADCON0;ADFM=1,V ref =Vdd, CHS=AN3, GO=0, ADON=ON, AD configured
Loop
	CALL Catch;Capture the voltage level on RA4
	CALL Rotation;Rotate the led with a delay
	GOTO Loop;repeat from loop

Catch
	BSF ADCON0,1;GO=1 start conversion
	BTFSC ADCON0,1;Verifing if conversion is complete
	GOTO $-1;If isn't, repeat
	BANKSEL ADRESH;Go to the ADRESH register's bank
	MOVF ADRESH,W;Read the AD conversion result high register and store it in W
	MOVWF ResHi;Move it to the ResHi variable
	BANKSEL ADRESL;Go to the ADRESL register's bank
	MOVF ADRESL,W;Read the AD conversion result low register and store it in W
	BANKSEL ResLow;Go to the ResLow register's bank
	MOVWF ResLow;Move W to the ResLow variable
	RETURN;finish subroutine

Delay1ms
	MOVLW 0x5F;Move 5F to W
	MOVWF Delay1;Copy W to Delay1
	MOVLW 0x04;Move 4 to W
	MOVWF Delay2;Copy W to Delay2
	IntLoop
	DECFSZ Delay1,1;Decrement Delay1 and skip next instruction if result is 0
	GOTO IntLoop;Repeat the loop
	MOVLW 0x5F;Move 5F to W
	MOVWF Delay1;Copy W to Delay1
	DECFSZ Delay2,1;Decrement Delay2 and skip next instruction if result is 0
	GOTO IntLoop;Repeat the loop
	RETURN;Finish Delay1ms subroutine

Delay256ms
	MOVLW 0xFF;Move 0xFF to W
	MOVWF Delay3;Copy W to Delay3
	Loop256
	CALL Delay1ms;Execute Delay1ms subroutine
	DECFSZ Delay3,1;Decrement Delay3 and skip the next instruction if result is 0
	GOTO Loop256;Repeat the loop
	RETURN;Finish Delay256ms subroutine

Rotation
	BCF STATUS,C;Clear the carry bit
	BANKSEL Display;Go to the Displays register bank
	MOVF Display,w;Copy Display to W
	MOVWF PORTC;Copy W to PORTC (To the LEDs)
	RRF Display,f;Rotate Display right
	BTFSC STATUS,C;Did the bit rotate into the carry?
	GOTO Lb1;Go to Lb1 if carry=1
    Lb2	BTFSC ResHi,0;To execute the 250ms delay if Cnt>255
	GOTO Lb3;Go to execute the 250ms delay
    Lb4	BTFSC ResHi,1;To execute 2 250ms delays if Cnt>511
	GOTO Lb5;Jump to execute 2 250ms delays
    Lb6	MOVF ResLow,W;Copy ResLow to W
	MOVWF Cnt;Move W to Cnt
	RtLoop
	CALL Delay1ms;Delay 1 millisecond
	DECFSZ Cnt,f;Decrement the counter
	GOTO RtLoop;Repeat if Cnt is not 0
	RETURN;end of subroutine
    Lb1	MOVLW 0x08;Put 00001000 in the working register
	MOVWF Display; Moves the contents of W to Display
	GOTO Lb2;return to continue the program
    Lb3	CALL Delay256ms;Delay 256 millisenconds
	GOTO Lb4;return to continue the program
    Lb5	CALL Delay256ms;Delay 256 milliseconds
	CALL Delay256ms;Delay 256 milliseconds
	GOTO Lb6;return to continue the program
    END