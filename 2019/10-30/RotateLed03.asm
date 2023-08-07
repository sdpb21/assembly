#include <p16f690.inc>

; #include - Brings in an include file defining all the Special Function Registers available on the PIC16F690.
; Also, it defines valid memory areas. These definitions match the names used in the device data sheet.

    __config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF)

; Config Defines the Configuration Word.

    org 0 ; Org 0 Tells the assembler where to start generating code.

Display equ 20h       ; declare label addresses
Delay1  equ 21h
Delay2  equ 22h
Delay3	equ 23h

Start
	BSF STATUS, RP0 ; select memory bank 1 (RP0=1)
	CLRF TRISA	; clear TRISA
	CLRF TRISC	; make I/O PORTC all output
	BSF TRISA, 1	; set RA1 as input
	MOVLW 0x30	; literal 0x30 to W
	MOVWF ADCON1	; 00110000 ADC Frc clock, from internal oscillator
	BCF STATUS, RP0 ; back memory bank 0 (RP0=0)
	MOVLW 0x08      ; put 1000 in the working register
	MOVWF Display   ; moves the contents of Wreg to register - Display
	BANKSEL ANSEL	; go to the bank 2
	CLRF ANSEL	; set the first 8 analog inputs as Digital I/O to use PORTC as output
	BSF ANSEL,1	; set RA1 as analog input
	BANKSEL ADCON0	; go to the bank 0
	MOVLW 0x85	; 10000101 justify to the right
	MOVWF ADCON0	; Vdd ref. voltage, AN1, On
MainLoop
	CALL ReadAnalog	; read the analog input
	CALL Cycle	; rotate the led
	GOTO MainLoop	; repeat from MainLoop label

ReadAnalog
	BSF ADCON0,GO	; start conversion
	BTFSC ADCON0,GO	; conversion complete?
	GOTO $-1	; if don't, verify again
	RETURN		; return to call ReadAnalog point

Delay_256
	MOVLW d'255'	; 255 to W
	MOVWF Delay3	; copy W to Delay3
	Loop2		; beginning of the Loop2
	CALL Delay_1	; 1 millisecond delay
	DECFSZ Delay3,F	; decrement Delay3 and skip next line if it is 0
	GOTO Loop2	; go to Loop2 256 times
	RETURN		; go back where was called

Delay_1
	MOVLW d'250'	; copy 250 on W
	MOVWF Delay1	; copy 250 to Delay1
	MOVLW d'4'	; copy 4 on W
	MOVWF Delay2	; copy 4 to Delay2
	Loop1		; beginning of the loop
	DECFSZ Delay1,F	; decrement Delay1 and skip next line if it is 0
	GOTO Loop1	; go to Loop1 250 times
	MOVLW d'250'	; copy 250 to W to repeat it 4 times
	MOVWF Delay1	; 250 to Delay1
	DECFSZ Delay2,F	; decrement Delay2 and skip next line if it is 0
	GOTO Loop1	; go to Loop1 to repeat 250, 4 times to yield 1ms delay
	RETURN		; go back where was called

Cycle
	BCF STATUS,C	; ensure the carry bit is clear
	BANKSEL Display	; go to the bank 0
	MOVF Display,w 	; Copy the display to the Wreg
	MOVWF PORTC	; Copy the Wreg to Port C (to the LEDs)
	RRF Display, f	; Rotate Display right
	BTFSC STATUS, C ; Did the bit rotate into the carry?
	GOTO A		; if the 1 is on the carry go to reset display
    B1	BTFSC ADRESH,0	; go to next line if ADRESH(0) is 1
	GOTO C1		; go to C1 label for a 250ms delay
    D1	BTFSC ADRESH,1	; go to the next line if ADRESH(1) is 1
	GOTO E		; go to E for a 512 ms delay
    F1	CALL Delay_1	; delay 1 millisecond
	DECFSZ ADRESL,F	; as long as the voltage level delay
	GOTO F1		; repeat until ADRESL=0
	RETURN		; go back, Cycle ends
    A	MOVLW d'8'      ; put 00001000 in the working register
	MOVWF Display   ; moves the contents of Wreg to register - Display
	GOTO B1		; go back to B1 label
    C1	CALL Delay_256	; call Delay_256
	GOTO D1		; go back to D label
    E	CALL Delay_256	; call Delay_256
	CALL Delay_256	; call Delay_256 again
	GOTO F1		;go back to F1 label

    END