; Processor       : PIC16Cxx
; Target assembler: Microchip's MPALC

; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p12f683.inc"
; CONFIG
; __config 0x3014
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_ON & _CPD_ON & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF

  org 0 ; org tells the assembler when to start generating code
  GOTO START
  ORG 4
  GOTO interr;to indicate the interrupt subroutine

byte_DATA_0 equ 0x00
byte_DATA_20 equ 0x20
byte_DATA_21 equ 0x21
byte_DATA_22 equ 0x22
byte_DATA_23 equ 0x23
byte_DATA_24 equ 0x24
byte_DATA_25 equ 0x25
byte_DATA_26 equ 0x26
byte_DATA_27 equ 0x27
byte_DATA_28 equ 0x28
byte_DATA_2D equ 0x2D
byte_DATA_2E equ 0x2E
byte_DATA_2F equ 0x2F
byte_DATA_30 equ 0x30
byte_DATA_31 equ 0x31
byte_DATA_32 equ 0x32
byte_DATA_33 equ 0x33
byte_DATA_34 equ 0x34
byte_DATA_35 equ 0x35
byte_DATA_36 equ 0x36
byte_DATA_37 equ 0x37
byte_DATA_38 equ 0x38
byte_DATA_39 equ 0x39
byte_DATA_3A equ 0x3A
byte_DATA_3B equ 0x3B
byte_DATA_70 equ 0x70
byte_DATA_71 equ 0x71
byte_DATA_72 equ 0x72
byte_DATA_73 equ 0x73
byte_DATA_74 equ 0x74
byte_DATA_75 equ 0x75
byte_DATA_76 equ 0x76
byte_DATA_77 equ 0x77
byte_DATA_78 equ 0x78
byte_DATA_79 equ 0x79
byte_DATA_7E equ 0x7E
RESERVED008F equ 0x8F
RESERVED0015 equ 0x15
RESERVED0014 equ 0x14
RESERVED0013 equ 0x13
RESERVED0012 equ 0x12
RESERVED0092 equ 0x92
GPIO0          equ 0
GPIO1          equ 1
GPIO2          equ 2
GPIO3          equ 3
GPIO4          equ 4
GPIO5          equ 5
CMCON     equ 0x19
; ===========================================================================
; Segment type: Pure code
               ; .text (CODE)
; assume bank = 0
; assume pclath = 0
; [00000001 BYTES: COLLAPSED FUNCTION RESET. PRESS CTRL-NUMPAD+ TO EXPAND]
;                data  3FFF
;                data  3FFF
;                data  3FFF
; =============== S U B R O U T I N E =======================================
; Interrupt Vector
                ; public ISR
;ISR:
interr
; FUNCTION CHUNK AT 0176 SIZE 0000003B BYTES
		bcf	STATUS,RP0  ; pas� 1
                movwf   byte_DATA_7E	; guarda el contenido de w
                swapf   STATUS, w	; voltea STATUS
                movwf   byte_DATA_78	; guarda STATUS volteado
                movfw   PCLATH		; pclath a w
                movwf   byte_DATA_79	; guarda PCLATH
                b       loc_CODE_176	; ejecutada
; End of function ISR
START
; =============== S U B R O U T I N E =======================================
RESET_0                                ; CODE XREF: RESET�??j
; FUNCTION CHUNK AT 0097 SIZE 00000074 BYTES
                b       loc_CODE_B	; ejecutada
; ---------------------------------------------------------------------------
loc_CODE_B                             ; CODE XREF: RESET_0�??j
		BCF	STATUS,RP0	; ejecutada
                movlw   byte_DATA_70	; ejecutada
                movwf   FSR		; para limpiar los bytes desde el 0x70
                movlw   76h ; 'v'	; ejecutada
                call    sub_CODE_212	; subrutina para limpiar
                movlw   31h ; '1'	; para limpiar los bytes desde la direcci�n 0x31 hasta la 0x3b
                bcf     STATUS, 7	; ejecutada
                movwf   FSR		; ejecutada
                movlw   3Ch ; '<'	; ejecutada
                call    sub_CODE_212	; subrutina que limpia
                clrf    STATUS		; esta instrucci�n no limpi� status
                b       loc_CODE_97	; ejecutada
; End of function RESET_0


; =============== S U B R O U T I N E =======================================


sub_CODE_16                            ; CODE XREF: RESET_0+EE�??p
		BCF	STATUS,RP0	; pas�:1,2,3,4,5,6,7,8
                clrc			; ejecutada
                btfss   byte_DATA_37, 1	; ejecutada
                 setc			; ejecutada
                movlw   0		; ejecutada
                skpnc			; ejecutada
                 movlw   1		; ejecutada
                movwf   byte_DATA_23	; ejecutada
                b       loc_CODE_89	; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_1E                            ; CODE XREF: sub_CODE_16+77�??j
                                        ; CODE:0229�??j
                movfw   byte_DATA_35
                andlw   3
                bz      loc_CODE_24
                movlw   1
                b       loc_CODE_25
; ---------------------------------------------------------------------------

loc_CODE_24                            ; CODE XREF: sub_CODE_16+A�??j
                movlw   0

loc_CODE_25                            ; CODE XREF: sub_CODE_16+D�??j
                movwf   byte_DATA_20
                movfw   byte_DATA_37
                xorwf   byte_DATA_20, w
                andlw   0xFE
                xorwf   byte_DATA_20, w
                movwf   byte_DATA_37
                clrc
                rlf     byte_DATA_35, f
                rlf     byte_DATA_36, f
                movfw   byte_DATA_32
                bz      loc_CODE_33

loc_CODE_31                            ; CODE XREF: sub_CODE_16+61�??j
                                        ; sub_CODE_16+6F�??j
                decf    byte_DATA_32, f
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_33                            ; CODE XREF: sub_CODE_16+19�??j
                btfss   byte_DATA_37, 1
                 b       loc_CODE_39
                movlw   1
                movwf   byte_DATA_31
                movlw   8
                b       loc_CODE_6C
; ---------------------------------------------------------------------------

loc_CODE_39                            ; CODE XREF: sub_CODE_16+1E�??j
                movlw   1
                movwf   byte_DATA_35
                clrf    byte_DATA_36
                movlw   2
                b       loc_CODE_6C
; ---------------------------------------------------------------------------

loc_CODE_3E                            ; CODE XREF: CODE:022A�??j
                bcf     byte_DATA_37, 0
                decfsz  byte_DATA_32, f
                 b       loc_CODE_94
                movlw   2
                movwf   byte_DATA_31
                movlw   10
                movwf   byte_DATA_32
                movlw   80
                movwf   byte_DATA_36
                clrf    byte_DATA_35
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_49                            ; CODE XREF: CODE:022B�??j
                bsf     byte_DATA_37, 0
                movlw   3
                b       loc_CODE_73
; ---------------------------------------------------------------------------

loc_CODE_4C                            ; CODE XREF: CODE:022C�??j
                bcf     byte_DATA_37, 0
                movlw   4
                b       loc_CODE_73
; ---------------------------------------------------------------------------

loc_CODE_4F                            ; CODE XREF: CODE:022D�??j
                decf    byte_DATA_32, f
                movfw   byte_DATA_33
                andwf   byte_DATA_35, w
                movwf   byte_DATA_20
                movfw   byte_DATA_34
                andwf   byte_DATA_36, w
                movwf   byte_DATA_21
                iorwf   byte_DATA_20, w
                bz      loc_CODE_5B
                movlw   1
                b       loc_CODE_5C
; ---------------------------------------------------------------------------

loc_CODE_5B                            ; CODE XREF: sub_CODE_16+41�??j
                movlw   0

loc_CODE_5C                            ; CODE XREF: sub_CODE_16+44�??j
                movwf   byte_DATA_22
                movfw   byte_DATA_37
                xorwf   byte_DATA_22, w
                andlw   0xFE
                xorwf   byte_DATA_22, w
                movwf   byte_DATA_37
                clrc
                rrf     byte_DATA_36, f
                rrf     byte_DATA_35, f
                movfw   byte_DATA_35
                iorwf   byte_DATA_36, w
                bnz     loc_CODE_6E
                movlw   5
                movwf   byte_DATA_31
                movlw   1

loc_CODE_6C                            ; CODE XREF: sub_CODE_16+22�??j
                                        ; sub_CODE_16+27�??j
                movwf   byte_DATA_32
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_6E                            ; CODE XREF: sub_CODE_16+51�??j
                movfw   byte_DATA_32
                andlw   3
                bnz     loc_CODE_94
                movlw   2

loc_CODE_73                            ; CODE XREF: sub_CODE_16+35�??j
                                        ; sub_CODE_16+38�??j
                movwf   byte_DATA_31
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_75                            ; CODE XREF: CODE:022E�??j
                bsf     byte_DATA_37, 0
                movfw   byte_DATA_32
                bnz     loc_CODE_31
                bcf     byte_DATA_37, 1
                movlw   6
                movwf   byte_DATA_31
                movlw   10h
                movwf   byte_DATA_32
                clrf    byte_DATA_23
                incf    byte_DATA_23, f
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_81                            ; CODE XREF: CODE:022F�??j
                bsf     byte_DATA_37, 0
                clrf    byte_DATA_23
                incf    byte_DATA_23, f
                movfw   byte_DATA_32
                bnz     loc_CODE_31
                call    sub_CODE_1FA
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_89                            ; CODE XREF: sub_CODE_16+7�??j
		BCF	STATUS,RP0	; pas�:1,2,3,4,5,6,7,8
                movfw   byte_DATA_31	; ejecutada
                movwf   FSR		; ejecutada
                movlw   7		; ejecutada
                subwf   FSR, w		; ejecutada
                bc      loc_CODE_1E	; ejecutada
                movlw   2		; ejecutada
                movwf   PCLATH		; ejecutada
; assume pclath = 2
                movlw   29h ; ')'	; ejecutada
                addwf   FSR, w		; ejecutada
                movwf   PCL		; ejecutada
; ---------------------------------------------------------------------------
; assume pclath = 0

loc_CODE_94                            ; CODE XREF: sub_CODE_16+1C�??j
                                        ; sub_CODE_16+2A�??j ...
                bcf     byte_DATA_37, 2
                movfw   byte_DATA_23
                return
; End of function sub_CODE_16

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR RESET_0

loc_CODE_97                            ; CONFIGURACI�N DEL PIC CODE XREF: RESET_0+B�??j 
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                bsf     RESERVED008F, 6	; OSCCON bits 6,5 y 4 a 1 para seleccionar la frecuencia del oscilador interno
                bsf     RESERVED008F, 5	; ejecutada
                bsf     RESERVED008F, 4	; ejecutada
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                clrf    GPIO		; aqu� comienza la inicializaci�n de las entradas/salidas de prop�sito general
                bsf     GPIO, GPIO0	; en la simulaci�n no se vuelve 1
                bcf     GPIO, GPIO1	; ejecutada
                bcf     GPIO, GPIO4	; ejecutada
                bcf     GPIO, GPIO5	; ejecutada
                movlw   7		; contin�a la inicializaci�n
                movwf   CMCON		; apaga el comparador
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                clrf    ANSEL		; ans3:ans0 configuradas como I/O digitales
                movlw   0xFC		; 0b11111100
                movwf   TRISIO		; trisio<5:2> entradas, trisio<1:0> salidas GP0 Y GP1 SON SALIDAS, GP2, GP4 Y GP5 SON ENTRADAS
                bcf     OPTION_REG,7	; resistencias de pull-up del gpio habilitadas
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                clrf    TMR1L		; ejecutada
                clrf    TMR1H		; ejecutada
                clrf    T1CON		; timer1 apagado
                bsf     T1CON, T1CKPS1	; configura el timer1 en 1:8 prescale value
                bsf     T1CON, T1CKPS0	; ejecutada
                clrf    INTCON		; interrupciones deshabilitadas
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                clrf    PIE1		; interrupciones de todos los perif�ricos deshabilitadas
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                clrf    PIR1		; coloca todas las banderas de interrupci�n a 0
                bsf     INTCON, PEIE	; habilita interrupciones de los perif�ricos
                movlw   0x0A		; ejecutada
                movwf   RESERVED0015	; CCP1CON=0xA modo comparaci�n, genera interrupci�n por software si CCPR1==TMR1
                movlw   0x3F ; '?'	; ejecutada
                movwf   RESERVED0014	; CCPR1H registro del byte alto del m�dulo CCP1
                movlw   0xC0		; ejecutada
                movwf   RESERVED0013	; CCPR1L parte baja del registro donde se almacenan los resultados del m�dulo CCP1
                bcf     PIR1, 5		; puesta a cero por software del bit bandera de interrupci�n de CCP1
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                bsf     PIE1, 5		; habilita las interrupciones del m�dulo CCP1
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                clrf    RESERVED0012	; T2CON configuraci�n del Timer2
                bsf     RESERVED0012, 3	; bits del 6 al 3 para seleccionar el postscaler de la salida
                bsf     RESERVED0012, 4	; ejecutada
                bsf     RESERVED0012, 5	; ejecutada
                bsf     RESERVED0012, 6	; ejecutada
                bsf     RESERVED0012, 1	; bit 1 y 0 para seleccionar el prescaler del reloj del timer2, en este caso es 16
                movlw   0xFF		; ejecutada
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                movwf   RESERVED0092	; PR2 registro de per�odo del Timer2
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                bcf     PIR1, 1		; 0 a la bandera de interrupci�n del Timer2
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                bcf     OPTION_REG, INTEDG  ; habilita la interrupci�n en el flanco de bajada de la se�al en el pin INT/GP2
                bcf     INTCON, INTF	; puesta a 0 en software de la bandera de interrupci�n externa, se debe hacer despu�s de ocurrir una interrupci�n externa
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                bcf     RESERVED0012, 2	; deshabilita el Timer2, lo apaga
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                bcf     PIE1, 1		; deshabilita la interrupci�n del Timer2
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                bcf     PIR1, 1		; vuelve 0 la bandera de interrupci�n del Timer2
                bcf     INTCON, INTF	; puesta a 0 en software de la bandera de interrupci�n externa
                bsf     INTCON, INTE	; habilita la interrupci�n externa por el pin INT/GP2
                clrf    byte_DATA_70	; ejecutada
                movlw   8		; ejecutada
                movwf   byte_DATA_73	; ejecutada
                bcf     byte_DATA_74, 1	; ejecutada
                bcf     byte_DATA_74, 2	; ejecutada
                bcf     byte_DATA_74, 0	; ejecutada
                b       loc_CODE_DB	; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_DB                            ; CODE XREF: RESET_0+D0�??j
                call    sub_CODE_222	; ejecutada
                call    sub_CODE_237	; ejecutada
		BCF	STATUS,RP0	; ejecutada
                bsf     T1CON, TMR1ON	; enciende el timer1
                bsf     INTCON, GIE	; habilita todas las interrupciones
                bsf     GPIO, GPIO1	; vuelve 1 a GP1

loc_CODE_E0                            ; CODE XREF: RESET_0+EC�??j
                                        ; RESET_0+F0�??j ...
                call    sub_CODE_247	; pas�:1,2,3,4,5,6,7,8 PRINCIPIO DEL LOOP?
                xorlw   0		; ejecutada
                bz      loc_CODE_F4	; ejecutada
                call    sub_CODE_10B	; ejecutada
                xorlw   0		; ejecutada
                bnz     loc_CODE_F4	; ejecutada
                call    sub_CODE_24C
                movfw   byte_DATA_21
                movwf   byte_DATA_2E
                movfw   byte_DATA_20
                movwf   byte_DATA_2D
                movfw   byte_DATA_2E
                movwf   byte_DATA_28
                movfw   byte_DATA_2D
                movwf   byte_DATA_27
                call    sub_CODE_207
		BCF	STATUS,RP0
                movlw   2
                xorwf   GPIO, f

loc_CODE_F4                            ; CODE XREF: RESET_0+D8�??j
                                        ; RESET_0+DC�??j
                call    sub_CODE_23D	; pas�:1,2,3,4,5,6,7,8
                xorlw   0		; ejecutada
                bz      loc_CODE_E0	; ejecutada
                call    sub_CODE_16	; ejecutada
                xorlw   1		; ejecutada
                bnz     loc_CODE_E0	; ejecutada
                call    sub_CODE_251
                xorlw   0
                bz      loc_CODE_E0
                call    sub_CODE_21A
                movfw   byte_DATA_21
                movwf   byte_DATA_30
                movfw   byte_DATA_20
                movwf   byte_DATA_2F
                movfw   byte_DATA_30
                movwf   byte_DATA_21
                movfw   byte_DATA_2F
                movwf   byte_DATA_20
                call    sub_CODE_1D9
                b       loc_CODE_E0
; END OF FUNCTION CHUNK FOR RESET_0

; =============== S U B R O U T I N E =======================================


sub_CODE_10B                           ; CODE XREF: RESET_0+DA�??p
                clrf    byte_DATA_20	;pas�
                incf    byte_DATA_20, f	; ejecutada
                b       loc_CODE_167	; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_10E                           ; CODE XREF: sub_CODE_10B+60�??j
                                        ; CODE:0242�??j
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_11B
                decfsz  byte_DATA_73, f
                 b       loc_CODE_172
                movlw   1
                movwf   byte_DATA_70
                clrf    byte_DATA_71
                clrf    byte_DATA_72
                movlw   10h
                movwf   byte_DATA_73

loc_CODE_118                           ; CODE XREF: sub_CODE_10B:loc_CODE_12A�??j
                bcf     STATUS, RP0
                bcf     GPIO, GPIO4
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_11B                           ; CODE XREF: sub_CODE_10B+4�??j
                                        ; sub_CODE_10B+57�??j ...
                bcf     STATUS, RP0
                bcf     RESERVED0012, 2
                bsf     STATUS, RP0
; assume bank = 1
                bcf     PIE1, 1
                bcf     STATUS, RP0
; assume bank = 0
                bcf     PIR1, 1
                bcf     INTCON, INTF
                bsf     INTCON, INTE
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       loc_CODE_12A
; ---------------------------------------------------------------------------

loc_CODE_12A                           ; CODE XREF: sub_CODE_10B+1E�??j
                b       loc_CODE_118
; ---------------------------------------------------------------------------

loc_CODE_12B                           ; CODE XREF: CODE:0243�??j
		BCF	STATUS,RP0
                bsf     GPIO, GPIO5
                btfss   byte_DATA_74, 0
                 b       loc_CODE_133
                movlw   2
                movwf   byte_DATA_70
                bcf     INTCON, INTF
                bsf     INTCON, INTE
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_133                           ; CODE XREF: sub_CODE_10B+22�??j
                                        ; sub_CODE_10B+3C�??j
                clrf    byte_DATA_20
                incf    byte_DATA_20, f
                bcf     STATUS, RP0
                bcf     RESERVED0012, 2
                bsf     STATUS, RP0
; assume bank = 1
                bcf     PIE1, 1
                bcf     STATUS, RP0
; assume bank = 0
                bcf     PIR1, 1
                bcf     INTCON, INTF
                bsf     INTCON, INTE
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       loc_CODE_144
; ---------------------------------------------------------------------------

loc_CODE_144                           ; CODE XREF: sub_CODE_10B+38�??j
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_145                           ; CODE XREF: CODE:0244�??j
		BCF	STATUS,RP0
                bcf     GPIO, GPIO5
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_133
                movlw   3
                b       loc_CODE_15B
; ---------------------------------------------------------------------------

loc_CODE_14A                           ; CODE XREF: CODE:0245�??j
                clrc
                rlf     byte_DATA_71, f
                rlf     byte_DATA_72, f
                movfw   byte_DATA_74
                andlw   1
                iorwf   byte_DATA_71, f
                decfsz  byte_DATA_73, f
                 b       loc_CODE_156
                movlw   2
                movwf   byte_DATA_73
                movlw   4
                b       loc_CODE_15B
; ---------------------------------------------------------------------------

loc_CODE_156                           ; CODE XREF: sub_CODE_10B+46�??j
                movfw   byte_DATA_73
                andlw   3
                bnz     loc_CODE_172
                movlw   1

loc_CODE_15B                           ; CODE XREF: sub_CODE_10B+3E�??j
                                        ; sub_CODE_10B+4A�??j
                movwf   byte_DATA_70
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_15D                           ; CODE XREF: CODE:0246�??j
		BCF	STATUS,RP0
                bsf     GPIO, GPIO4
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_163
                clrf    byte_DATA_20
                incf    byte_DATA_20, f
                b       loc_CODE_11B
; ---------------------------------------------------------------------------

loc_CODE_163                           ; CODE XREF: sub_CODE_10B+54�??j
                decfsz  byte_DATA_73, f
                 b       loc_CODE_172
                clrf    byte_DATA_20
                b       loc_CODE_11B
; ---------------------------------------------------------------------------

loc_CODE_167                           ; CODE XREF: sub_CODE_10B+2�??j
		BCF	STATUS,RP0	; pas�
                movfw   byte_DATA_70	; ejecutada
                movwf   FSR		; ejecutada
                movlw   5		; ejecutada
                subwf   FSR, w		; ejecutada
                bc      loc_CODE_10E	; ejecutada
                movlw   2		; ejecutada
                movwf   PCLATH		; ejecutada
; assume pclath = 2
                movlw   42h ; 'B'	; ejecutada
                addwf   FSR, w		; ejecutada
                movwf   PCL		; ejecutada
; ---------------------------------------------------------------------------
; assume pclath = 0

loc_CODE_172                           ; CODE XREF: sub_CODE_10B+6�??j
                                        ; sub_CODE_10B+F�??j ...
                bcf     byte_DATA_74, 2
                bcf     STATUS, RP0
                movfw   byte_DATA_20
                return
; End of function sub_CODE_10B

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR ISR

loc_CODE_176                           ; CODE XREF: ISR+5�??j
                bsf     STATUS, RP0	;pas� 1
; assume bank = 1
                btfsc   PIE1, 5		; ver si est�n habilitadas las interrupciones del CCP1
                 b       loc_CODE_17C	; si est�n habilitadas ejecuta esta l�nea
; assume bank = 0

loc_CODE_179                           ; CODE XREF: ISR+17A�??j
                                        ; ISR+184�??j
                btfss   INTCON, INTE	; verifica si las interrupciones externas est�n habilitadas, si es as� salta la siguiente l�nea pas� 1
                 b       loc_CODE_18B	; ejecutada
                b       loc_CODE_189	; ejecutada
; ---------------------------------------------------------------------------
; assume bank = 1

loc_CODE_17C                           ; CODE XREF: ISR+174�??j
                bcf     STATUS, RP0 ;pas� 1
; assume bank = 0
                btfss   PIR1, 5		; ver si la bandera de interrupci�n del CCP1 es 1, si es as� salta la siguiente l�nea
                 b       loc_CODE_179	; ejecutada
                bcf     PIR1, 5		; coloca en 0 la bandera de interrupci�n del CCP1
                movlw   3		; ejecutada
                addwf   RESERVED0013, f	; suma 3 al contenido de CCPR1L
                addcf   RESERVED0014, f	; suma el carry bit y CCPR1H
                movlw   14h		; ejecutada
                addwf   RESERVED0014, f	; le suma 0x14 a CCPR1H
                bcf     PIR1, 5		; coloca en 0 la bandera de interrupci�n del CCP1 again
                call    sub_CODE_230	; ejecutada
                b       loc_CODE_179	; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_189                           ; CODE XREF: ISR+177�??j
                btfsc   INTCON, INTF	; revisa la bandera de interrupci�n externa, si es 0 salta la siguiente l�nea pas� 1
                 b       loc_CODE_18F	; se ejecuta cuando la interrupci�n es externa

loc_CODE_18B                           ; CODE XREF: ISR+176�??j
                                        ; ISR+198�??j
                bsf     STATUS, RP0 ;pas� 1
; assume bank = 1
                btfss   PIE1, 1	    ; revisa si est� habilitada la interrupci�n del Timer2, si es 1 salta la pr�xima l�nea
                 b       loc_CODE_1A0	; ejecutada
                b       loc_CODE_19D	; ejecutada
; ---------------------------------------------------------------------------
; assume bank = 0

loc_CODE_18F                           ; CODE XREF: ISR+186�??j
                bcf     INTCON, INTF	; 0 a bandera interrupci�n externa - pas� 1
                movlw   50h ; 'P'	; ejecutada
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                movwf   RESERVED0092	; 0x50 a registro del per�odo del m�dulo del Timer2
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                bcf     PIR1, 1		; 0 a la bandera de interrupci�n del Timer2
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                bsf     PIE1, 1		; habilita interrupci�n del Timer2
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                bsf     RESERVED0012, 2	; T2CON enciende Timer2
                bcf     INTCON, INTE	; deshabilita interrupci�n externa
                bcf     INTCON, INTF	; limpia bandera de interrupci�n externa
                bsf     GPIO, GPIO4	; 1 a GP4, configurada como entrada no hace efecto
                b       loc_CODE_18B	; ejecutada
; ---------------------------------------------------------------------------
; assume bank = 1

loc_CODE_19D                           ; CODE XREF: ISR+18A�??j
                bcf     STATUS, RP0	;pas� 1
; assume bank = 0
                btfsc   PIR1, 1		; revisa bandera interrupci�n Timer2, si es 0 salta la siguiente l�nea
                 b       loc_CODE_1A7	; ejecutada

loc_CODE_1A0                           ; CODE XREF: ISR+189�??j
                                        ; ISR+1AC�??j
                movfw   byte_DATA_79	;pas� 1
                movwf   PCLATH		; devuelve a PCLATH el valor guardado al inicio de la subrutina de interrupci�n
                swapf   byte_DATA_78, w	; ejecutada
                movwf   STATUS		; devuelve a STATUS el valor guardado al inicio de la subrutina de interrupci�n
                swapf   byte_DATA_7E, f	; ejecutada
                swapf   byte_DATA_7E, w	; devuelve a w el valor guardado al inicio de la subrutina de interrupci�n
                retfie			; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_1A7                           ; CODE XREF: ISR+19B�??j
		BCF	STATUS,RP0	;pas� 1
                bcf     PIR1, 1		; limpia la bandera de interrupci�n del Timer2
                movlw   0xA0		; ejecutada
                bsf     STATUS, RP0	; ejecutada
; assume bank = 1
                movwf   RESERVED0092	; PR2 = 0xA
                movlw   0		; ejecutada
                bcf     STATUS, RP0	; ejecutada
; assume bank = 0
                btfsc   GPIO, GPIO2	; si GP2=0 w se queda igual a 0
                 movlw   1		; si GP2=1 w es 1
                call    sub_CODE_1EB	; ejecutada
                b       loc_CODE_1A0	; ejecutada
; END OF FUNCTION CHUNK FOR ISR

; =============== S U B R O U T I N E =======================================


sub_CODE_1B1                           ; CODE XREF: sub_CODE_207+7�??p
                movlw   93h
                clrf    byte_DATA_25
                clrf    byte_DATA_26
                xorwf   byte_DATA_38, w
                movwf   byte_DATA_23
                movlw   0xCE
                xorwf   byte_DATA_39, w
                movwf   byte_DATA_24
                movfw   byte_DATA_23
                movwf   byte_DATA_26
                movfw   byte_DATA_24
                movwf   byte_DATA_25
                btfsc   byte_DATA_26, 0
                 b       loc_CODE_1C1
                clrf    byte_DATA_20
                b       loc_CODE_1C3
; ---------------------------------------------------------------------------

loc_CODE_1C1                           ; CODE XREF: sub_CODE_1B1+D�??j
                movlw   80h
                movwf   byte_DATA_20

loc_CODE_1C3                           ; CODE XREF: sub_CODE_1B1+F�??j
                clrf    byte_DATA_21
                movfw   byte_DATA_20
                movwf   byte_DATA_22
                clrc
                rrf     byte_DATA_26, f
                bcf     byte_DATA_26, 7
                clrc
                rrf     byte_DATA_25, f
                bcf     byte_DATA_25, 7
                movfw   byte_DATA_22
                iorwf   byte_DATA_25, f
                movfw   byte_DATA_25
                movwf   byte_DATA_3A
                clrf    byte_DATA_3B
                movwf   byte_DATA_3B
                movlw   0xFF
                clrf    byte_DATA_3A
                clrf    byte_DATA_3A
                andwf   byte_DATA_3B, f
                movfw   byte_DATA_26
                iorwf   byte_DATA_3A, f
                return
; End of function sub_CODE_1B1


; =============== S U B R O U T I N E =======================================


sub_CODE_1D9                           ; CODE XREF: RESET_0+FF�??p
                movfw   byte_DATA_31
                bz      loc_CODE_1E0
                movlw   6
                xorwf   byte_DATA_31, w
                skpz
                 return

loc_CODE_1E0                           ; CODE XREF: sub_CODE_1D9+1�??j
                movfw   byte_DATA_21
                movwf   byte_DATA_34
                movfw   byte_DATA_20
                movwf   byte_DATA_33
                bsf     byte_DATA_37, 1
                bsf     byte_DATA_37, 2
                movlw   1
                movwf   byte_DATA_31
                movlw   8
                movwf   byte_DATA_32
                return
; End of function sub_CODE_1D9


; =============== S U B R O U T I N E =======================================


sub_CODE_1EB                           ; CODE XREF: ISR+1AB�??p
                movwf   byte_DATA_77	;pas� 1
                movfw   byte_DATA_77	; ejecutada
                bz      loc_CODE_1F1	; si w=0 se ejecuta �sta l�nea
                movlw   1
                b       loc_CODE_1F2
; ---------------------------------------------------------------------------

loc_CODE_1F1                           ; CODE XREF: sub_CODE_1EB+2�??j
                movlw   0		;pas� 1

loc_CODE_1F2                           ; CODE XREF: sub_CODE_1EB+5�??j
                movwf   byte_DATA_76	;pas� 1
                movfw   byte_DATA_74	; ejecutada
                xorwf   byte_DATA_76, w	; ejecutada
                andlw   0xFE		; ejecutada
                xorwf   byte_DATA_76, w	; ejecutada
                movwf   byte_DATA_74	; si GP2=0 data_74=4, si GP2=1 data_74=5
                bsf     byte_DATA_74, 2	; la primera vez que se ejecuta pone 4 en DATA_74
                return			; ejecutada
; End of function sub_CODE_1EB


; =============== S U B R O U T I N E =======================================


sub_CODE_1FA                           ; CODE XREF: sub_CODE_16+71�??p
                                        ; sub_CODE_222+6�??j
                bcf     STATUS, RP0	; ejecutada
                clrf    byte_DATA_31	; ejecutada
                movlw   1		; ejecutada
                movwf   byte_DATA_35	; ejecutada
                clrf    byte_DATA_36	; ejecutada
                bsf     byte_DATA_37, 0	; ejecutada
                movlw   2		; ejecutada
                movwf   byte_DATA_32	; ejecutada
                clrf    byte_DATA_33	; ejecutada
                clrf    byte_DATA_34	; ejecutada
                bcf     byte_DATA_37, 1	; ejecutada
                bsf     byte_DATA_37, 2	; ejecutada
                return			; ejecutada
; End of function sub_CODE_1FA


; =============== S U B R O U T I N E =======================================


sub_CODE_207                           ; CODE XREF: RESET_0+E7�??p
                movfw   byte_DATA_75
                skpz
                 return
                movfw   byte_DATA_28
                movwf   byte_DATA_39
                movfw   byte_DATA_27
                movwf   byte_DATA_38
                call    sub_CODE_1B1
                clrf    byte_DATA_75
                incf    byte_DATA_75, f
                return
; End of function sub_CODE_207


; =============== S U B R O U T I N E =======================================


sub_CODE_212                           ; CODE XREF: RESET_0+4�??p
                                        ; RESET_0+9�??p
                clrwdt			; ejecutada

loc_CODE_213                           ; CODE XREF: sub_CODE_212+7�??j
		BCF	STATUS,RP0	; este segmento es para limpiar lo apuntado por fsr (direccionamiento indirecto)
                clrf    byte_DATA_0	; bytes no implementados desde la direcci�n 0x70 a la 0x76
                incf    FSR, f		; ejecutada
                xorwf   FSR, w		; ejecutada
                skpnz			; ejecutada
                 retlw   0		; ejecutada
                xorwf   FSR, w		; ejecutada
                b       loc_CODE_213	; ejecutada
; End of function sub_CODE_212


; =============== S U B R O U T I N E =======================================


sub_CODE_21A                           ; CODE XREF: RESET_0+F6�??p
                movfw   byte_DATA_75
                skpz
                 decf    byte_DATA_75, f ; pas�:1,2,3,4,5,6,7,8
                movfw   byte_DATA_3B	; ejecutada
                movwf   byte_DATA_21	; ejecutada
                movfw   byte_DATA_3A	; ejecutada
                movwf   byte_DATA_20	; ejecutada
                return			; ejecutada
; End of function sub_CODE_21A


; =============== S U B R O U T I N E =======================================


sub_CODE_222                           ; CODE XREF: RESET_0:loc_CODE_DB�??p
                clrf    byte_DATA_70	; ejecutada
                movlw   8		; ejecutada
                movwf   byte_DATA_73	; ejecutada
                bcf     byte_DATA_74, 1	; ejecutada
                bcf     byte_DATA_74, 2	; ejecutada
                bcf     byte_DATA_74, 0	; ejecutada
                b       sub_CODE_1FA	; ejecutada
; End of function sub_CODE_222

; ---------------------------------------------------------------------------
                b       loc_CODE_1E
; ---------------------------------------------------------------------------
                b       loc_CODE_3E
; ---------------------------------------------------------------------------
                b       loc_CODE_49
; ---------------------------------------------------------------------------
                b       loc_CODE_4C
; ---------------------------------------------------------------------------
                b       loc_CODE_4F
; ---------------------------------------------------------------------------
                b       loc_CODE_75
; ---------------------------------------------------------------------------
                b       loc_CODE_81

; =============== S U B R O U T I N E =======================================


sub_CODE_230                           ; CODE XREF: ISR+183�??p
		BCF	STATUS,RP0  ;pas� 1,2,3,4
                btfss   byte_DATA_37, 0	; ejecutada
                 b       loc_CODE_234
                bcf     GPIO, GPIO0	; coloca a 0 GP0, una de las salidas
                b       loc_CODE_235	; ejecutada
; ---------------------------------------------------------------------------

loc_CODE_234                           ; CODE XREF: sub_CODE_230+1�??j
		BCF	STATUS,RP0	;pas�
                bsf     GPIO, GPIO0	; ejecutada

loc_CODE_235                           ; CODE XREF: sub_CODE_230+3�??j
                bsf     byte_DATA_37, 2	;pas� 1,2,3,4
                return			; ejecutada
; End of function sub_CODE_230


; =============== S U B R O U T I N E =======================================


sub_CODE_237                           ; CODE XREF: RESET_0+D2�??p
                clrf    byte_DATA_38	; ejecutada
                clrf    byte_DATA_39	; ejecutada
                clrf    byte_DATA_3A	; ejecutada
                clrf    byte_DATA_3B	; ejecutada
                clrf    byte_DATA_75	; ejecutada
                return			; ejecutada
; End of function sub_CODE_237


; =============== S U B R O U T I N E =======================================


sub_CODE_23D                           ; CODE XREF: RESET_0:loc_CODE_F4�??p
                rrf     byte_DATA_37, w	; pas�:1,2,3,4,5,6,7,8
                movwf   byte_DATA_20	; ejecutada
                rrf     byte_DATA_20, w	; ejecutada
                andlw   1		; ejecutada
                return			; ejecutada
; End of function sub_CODE_23D

; ---------------------------------------------------------------------------
                b       loc_CODE_10E
; ---------------------------------------------------------------------------
                b       loc_CODE_12B
; ---------------------------------------------------------------------------
                b       loc_CODE_145
; ---------------------------------------------------------------------------
                b       loc_CODE_14A
; ---------------------------------------------------------------------------
                b       loc_CODE_15D

; =============== S U B R O U T I N E =======================================


sub_CODE_247                           ; CODE XREF: RESET_0:loc_CODE_E0�??p
                rrf     byte_DATA_74, w	; 1,2,3,4,5,6,8
                movwf   byte_DATA_20	; ejecutada
                rrf     byte_DATA_20, w	; ejecutada
                andlw   1		; ejecutada
                return			; ejecutada
; End of function sub_CODE_247


; =============== S U B R O U T I N E =======================================


sub_CODE_24C                           ; CODE XREF: RESET_0+DE�??p
                movfw   byte_DATA_72
                movwf   byte_DATA_21
                movfw   byte_DATA_71
                movwf   byte_DATA_20
                return
; End of function sub_CODE_24C


; =============== S U B R O U T I N E =======================================


sub_CODE_251                           ; CODE XREF: RESET_0+F2�??p
                movfw   byte_DATA_75
                return
; End of function sub_CODE_251

; ---------------------------------------------------------------------------
	END
; en el c�digo de la interrupci�n, cuando la interrupci�n es del CCP1 por software, se coloca a 0 la bandera de interrupci�n del
; CCP1, luego se pone a 0 la salida GP0. Fuera de la subrutina de interrupci�n GP0 vuelve a ser 1

; Cuando la interrupci�n es externa primero se desactiva la bandera de interrupci�n externa
; luego se configura el Timer2 y se enciende, deber�a poner 1 en GP4, verifica si est�n habilitadas las interrupciones del Timer2
; luego termina la subrutina de interrupci�n y vuelve al loop raro en espera de las condiciones para otra interrupci�n pero esta
; vez con el Timer2 encendido y su interrupci�n habilitada. 

; Cuande se activa la interrupci�n del Timer2 primero se limpia la
; bandera de interrupci�n del Timer2 y luego se cambia el valor de PR2 a 0xA0, luego se revisa el GP2 a ver si es 0, si GP2=0
; data_74=4, si GP2=1 data_74=5

; Despu�s que se deshabilitan las interrupciones externas se alternan las interrupciones del CCP1 y del Timer2, dentro de la
; subrutina de interrupci�n del CCP1 GP0 se va a 0, despu�s de finalizada la subrutina de interrupci�n vuelve a 1 y luego se
; activa la subrutina de interrupci�n del Timer2 que evalua el estado de GP2, revisa si es 0 � 1 pero aparentemente no hay
; ning�n cambio si GP2 es 0 � 1, en ambos casos se ejecuta una interrupci�n del CCP1 y una del Timer2

; INICIALIZACI�N: habilita interrupciones de perif�ricos, inicializa el valor de CCPR1, se configura el prescaler y postscaler
; del Timer2 y el per�odo, se habilita la interrupci�n en el flanco de bajada de la se�al en el pin INT/GP2, se deshabilita la
; interrupci�n del Timer2, se habilita la interrupci�n externa por el pin INT/GP2, se enciende el Timer1, se habilitan todas
; las interrupciones.

; DESPU�S DE LA INICIALIZACI�N: se entra en un loop en el que s�lo se activa la interrupci�n del CCP1, es decir cada vez que
; CCPR1==TMR1 se genera una interrupci�n por software y se ejecuta el c�digo de la interrupci�n
; Cuando se genera una interrupci�n por un flanco de bajada en el pin INT/GP2, primero se pone a 0 la bandera de interrupci�n
; externa, luego se guarda 0x50 en PR2, luego se pone a 0 la bandera de interrupci�n del Timer2, luego se habilita la interrup-
; ci�n del Timer2, luego se enciende el Timer2, luego se deshabilita la interrupci�n externa por el pin INT, se pone a cero la
; bandera de interrupci�n externa, se coloca 1 en GP4 aunque en la simulaci�n no tiene efecto ya que ese pin est� configurado
; como entrada (revisar con proteus), luego revisa si esta activada la interrupci�n del Timer2 y si la bandera de interrupci�n
; del Timer2 es 1, luego termina la subrutina de interrupci�n