; Processor       : PIC16Cxx
; Target assembler: Microchip's MPALC

; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p12f683.inc"
; CONFIG
; __config 0x3014
 __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_ON & _CPD_ON & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF

  org 0 ; org tells the assembler when to start generating code
  GOTO START
  addlw 0xff
  addlw 0xff
  addlw 0xff
  ORG 4
  ;GOTO interr;to indicate the interrupt subroutine
; =============== S U B R O U T I N E =======================================

; Interrupt Vector

                ; public ISR
ISR

; FUNCTION CHUNK AT 0176 SIZE 0000003B BYTES

                movwf   byte_DATA_7E
                swapf   BANK0_STATUS, w
                movwf   byte_DATA_78
                movfw   BANK0_PCLATH
                movwf   byte_DATA_79
                b       loc_CODE_176
; End of function ISR


; =============== S U B R O U T I N E =======================================

START
RESET_0                                ; CODE XREF: RESET?j

; FUNCTION CHUNK AT 0097 SIZE 00000074 BYTES

                b       loc_CODE_B
; ---------------------------------------------------------------------------

loc_CODE_B                             ; CODE XREF: RESET_0?j
                movlw   byte_DATA_70
                movwf   BANK0_FSR
                movlw   76 ; 'v'
                call    sub_CODE_212
                movlw   31 ; '1'
                bcf     BANK0_STATUS, 7
                movwf   BANK0_FSR
                movlw   3C ; '<'
                call    sub_CODE_212
                clrf    BANK0_STATUS
                b       loc_CODE_97
; End of function RESET_0


; =============== S U B R O U T I N E =======================================


sub_CODE_16                            ; CODE XREF: RESET_0+EE?p
                clrc
                btfss   byte_DATA_37, 1
                 setc
                movlw   0
                skpnc
                 movlw   1
                movwf   byte_DATA_23
                b       loc_CODE_89
; ---------------------------------------------------------------------------

loc_CODE_1E                            ; CODE XREF: sub_CODE_16+77?j
                                        ; CODE:0229?j
                movfw   byte_DATA_35
                andlw   3
                bz      loc_CODE_24
                movlw   1
                b       loc_CODE_25
; ---------------------------------------------------------------------------

loc_CODE_24                            ; CODE XREF: sub_CODE_16+A?j
                movlw   0

loc_CODE_25                            ; CODE XREF: sub_CODE_16+D?j
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

loc_CODE_31                            ; CODE XREF: sub_CODE_16+61?j
                                        ; sub_CODE_16+6F?j
                decf    byte_DATA_32, f
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_33                            ; CODE XREF: sub_CODE_16+19?j
                btfss   byte_DATA_37, 1
                 b       loc_CODE_39
                movlw   1
                movwf   byte_DATA_31
                movlw   8
                b       loc_CODE_6C
; ---------------------------------------------------------------------------

loc_CODE_39                            ; CODE XREF: sub_CODE_16+1E?j
                movlw   1
                movwf   byte_DATA_35
                clrf    byte_DATA_36
                movlw   2
                b       loc_CODE_6C
; ---------------------------------------------------------------------------

loc_CODE_3E                            ; CODE XREF: CODE:022A?j
                bcf     byte_DATA_37, 0
                decfsz  byte_DATA_32, f
                 b       loc_CODE_94
                movlw   2
                movwf   byte_DATA_31
                movlw   0x10
                movwf   byte_DATA_32
                movlw   0x80
                movwf   byte_DATA_36
                clrf    byte_DATA_35
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_49                            ; CODE XREF: CODE:022B?j
                bsf     byte_DATA_37, 0
                movlw   3
                b       loc_CODE_73
; ---------------------------------------------------------------------------

loc_CODE_4C                            ; CODE XREF: CODE:022C?j
                bcf     byte_DATA_37, 0
                movlw   4
                b       loc_CODE_73
; ---------------------------------------------------------------------------

loc_CODE_4F                            ; CODE XREF: CODE:022D?j
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

loc_CODE_5B                            ; CODE XREF: sub_CODE_16+41?j
                movlw   0

loc_CODE_5C                            ; CODE XREF: sub_CODE_16+44?j
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

loc_CODE_6C                            ; CODE XREF: sub_CODE_16+22?j
                                        ; sub_CODE_16+27?j
                movwf   byte_DATA_32
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_6E                            ; CODE XREF: sub_CODE_16+51?j
                movfw   byte_DATA_32
                andlw   3
                bnz     loc_CODE_94
                movlw   2

loc_CODE_73                            ; CODE XREF: sub_CODE_16+35?j
                                        ; sub_CODE_16+38?j
                movwf   byte_DATA_31
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_75                            ; CODE XREF: CODE:022E?j
                bsf     byte_DATA_37, 0
                movfw   byte_DATA_32
                bnz     loc_CODE_31
                bcf     byte_DATA_37, 1
                movlw   6
                movwf   byte_DATA_31
                movlw   0x10
                movwf   byte_DATA_32
                clrf    byte_DATA_23
                incf    byte_DATA_23, f
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_81                            ; CODE XREF: CODE:022F?j
                bsf     byte_DATA_37, 0
                clrf    byte_DATA_23
                incf    byte_DATA_23, f
                movfw   byte_DATA_32
                bnz     loc_CODE_31
                call    sub_CODE_1FA
                b       loc_CODE_94
; ---------------------------------------------------------------------------

loc_CODE_89                            ; CODE XREF: sub_CODE_16+7?j
                movfw   byte_DATA_31
                movwf   BANK0_FSR
                movlw   7
                subwf   BANK0_FSR, w
                bc      loc_CODE_1E
                movlw   2
                movwf   BANK0_PCLATH
; assume pclath = 2
                movlw   0x29 ; ')'
                addwf   BANK0_FSR, w
                movwf   BANK0_PCL
; ---------------------------------------------------------------------------
; assume pclath = 0

loc_CODE_94                            ; CODE XREF: sub_CODE_16+1C?j
                                        ; sub_CODE_16+2A?j ...
                bcf     byte_DATA_37, 2
                movfw   byte_DATA_23
                return
; End of function sub_CODE_16

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR RESET_0

loc_CODE_97                            ; CODE XREF: RESET_0+B?j
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bsf     BANK1_RESERVED008F, 6
                bsf     BANK1_RESERVED008F, 5
                bsf     BANK1_RESERVED008F, 4
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                clrf    BANK0_GPIO
                bsf     BANK0_GPIO, GPIO0
                bcf     BANK0_GPIO, GPIO1
                bcf     BANK0_GPIO, GPIO4
                bcf     BANK0_GPIO, GPIO5
                movlw   7
                movwf   BANK0_CMCON
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                clrf    BANK1_ANSEL
                movlw   0xFC
                movwf   BANK1_TRISIO
                bcf     BANK1_OPTION, GPPU
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                clrf    BANK0_TMR1L
                clrf    BANK0_TMR1H
                clrf    BANK0_T1CON
                bsf     BANK0_T1CON, T1CKPS1
                bsf     BANK0_T1CON, T1CKPS0
                clrf    BANK0_INTCON
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                clrf    BANK1_PIE1
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                clrf    BANK0_PIR1
                bsf     BANK0_INTCON, PEIE
                movlw   0xA
                movwf   BANK0_RESERVED0015
                movlw   0x3F ; '?'
                movwf   BANK0_RESERVED0014
                movlw   0xC0
                movwf   BANK0_RESERVED0013
                bcf     BANK0_PIR1, 5
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bsf     BANK1_PIE1, 5
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                clrf    BANK0_RESERVED0012
                bsf     BANK0_RESERVED0012, 3
                bsf     BANK0_RESERVED0012, 4
                bsf     BANK0_RESERVED0012, 5
                bsf     BANK0_RESERVED0012, 6
                bsf     BANK0_RESERVED0012, 1
                movlw   0xFF
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                movwf   BANK1_RESERVED0092
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_PIR1, 1
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bcf     BANK1_OPTION, INTEDG
                bcf     BANK1_INTCON, INTF
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_RESERVED0012, 2
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bcf     BANK1_PIE1, 1
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_PIR1, 1
                bcf     BANK0_INTCON, INTF
                bsf     BANK0_INTCON, INTE
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       loc_CODE_DB
; ---------------------------------------------------------------------------

loc_CODE_DB                            ; CODE XREF: RESET_0+D0?j
                call    sub_CODE_222
                call    sub_CODE_237
                bsf     BANK0_T1CON, TMR1ON
                bsf     BANK0_INTCON, GIE
                bsf     BANK0_GPIO, GPIO1

loc_CODE_E0                            ; CODE XREF: RESET_0+EC?j
                                        ; RESET_0+F0?j ...
                call    sub_CODE_247
                xorlw   0
                bz      loc_CODE_F4
                call    sub_CODE_10B
                xorlw   0
                bnz     loc_CODE_F4
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
                movlw   2
                xorwf   BANK0_GPIO, f

loc_CODE_F4                            ; CODE XREF: RESET_0+D8?j
                                        ; RESET_0+DC?j
                call    sub_CODE_23D
                xorlw   0
                bz      loc_CODE_E0
                call    sub_CODE_16
                xorlw   1
                bnz     loc_CODE_E0
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


sub_CODE_10B                           ; CODE XREF: RESET_0+DA?p
                clrf    byte_DATA_20
                incf    byte_DATA_20, f
                b       loc_CODE_167
; ---------------------------------------------------------------------------

loc_CODE_10E                           ; CODE XREF: sub_CODE_10B+60?j
                                        ; CODE:0242?j
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_11B
                decfsz  byte_DATA_73, f
                 b       loc_CODE_172
                movlw   1
                movwf   byte_DATA_70
                clrf    byte_DATA_71
                clrf    byte_DATA_72
                movlw   0x10
                movwf   byte_DATA_73

loc_CODE_118                           ; CODE XREF: sub_CODE_10B:loc_CODE_12A?j
                bcf     BANK0_STATUS, RP0
                bcf     BANK0_GPIO, GPIO4
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_11B                           ; CODE XREF: sub_CODE_10B+4?j
                                        ; sub_CODE_10B+57?j ...
                bcf     BANK0_STATUS, RP0
                bcf     BANK0_RESERVED0012, 2
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bcf     BANK1_PIE1, 1
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_PIR1, 1
                bcf     BANK0_INTCON, INTF
                bsf     BANK0_INTCON, INTE
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       loc_CODE_12A
; ---------------------------------------------------------------------------

loc_CODE_12A                           ; CODE XREF: sub_CODE_10B+1E?j
                b       loc_CODE_118
; ---------------------------------------------------------------------------

loc_CODE_12B                           ; CODE XREF: CODE:0243?j
                bsf     BANK0_GPIO, GPIO5
                btfss   byte_DATA_74, 0
                 b       loc_CODE_133
                movlw   2
                movwf   byte_DATA_70
                bcf     BANK0_INTCON, INTF
                bsf     BANK0_INTCON, INTE
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_133                           ; CODE XREF: sub_CODE_10B+22?j
                                        ; sub_CODE_10B+3C?j
                clrf    byte_DATA_20
                incf    byte_DATA_20, f
                bcf     BANK0_STATUS, RP0
                bcf     BANK0_RESERVED0012, 2
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bcf     BANK1_PIE1, 1
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_PIR1, 1
                bcf     BANK0_INTCON, INTF
                bsf     BANK0_INTCON, INTE
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       loc_CODE_144
; ---------------------------------------------------------------------------

loc_CODE_144                           ; CODE XREF: sub_CODE_10B+38?j
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_145                           ; CODE XREF: CODE:0244?j
                bcf     BANK0_GPIO, GPIO5
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_133
                movlw   3
                b       loc_CODE_15B
; ---------------------------------------------------------------------------

loc_CODE_14A                           ; CODE XREF: CODE:0245?j
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

loc_CODE_156                           ; CODE XREF: sub_CODE_10B+46?j
                movfw   byte_DATA_73
                andlw   3
                bnz     loc_CODE_172
                movlw   1

loc_CODE_15B                           ; CODE XREF: sub_CODE_10B+3E?j
                                        ; sub_CODE_10B+4A?j
                movwf   byte_DATA_70
                b       loc_CODE_172
; ---------------------------------------------------------------------------

loc_CODE_15D                           ; CODE XREF: CODE:0246?j
                bsf     BANK0_GPIO, GPIO4
                btfsc   byte_DATA_74, 0
                 b       loc_CODE_163
                clrf    byte_DATA_20
                incf    byte_DATA_20, f
                b       loc_CODE_11B
; ---------------------------------------------------------------------------

loc_CODE_163                           ; CODE XREF: sub_CODE_10B+54?j
                decfsz  byte_DATA_73, f
                 b       loc_CODE_172
                clrf    byte_DATA_20
                b       loc_CODE_11B
; ---------------------------------------------------------------------------

loc_CODE_167                           ; CODE XREF: sub_CODE_10B+2?j
                movfw   byte_DATA_70
                movwf   BANK0_FSR
                movlw   5
                subwf   BANK0_FSR, w
                bc      loc_CODE_10E
                movlw   2
                movwf   BANK0_PCLATH
; assume pclath = 2
                movlw   0x42 ; 'B'
                addwf   BANK0_FSR, w
                movwf   BANK0_PCL
; ---------------------------------------------------------------------------
; assume pclath = 0

loc_CODE_172                           ; CODE XREF: sub_CODE_10B+6?j
                                        ; sub_CODE_10B+F?j ...
                bcf     byte_DATA_74, 2
                bcf     BANK0_STATUS, RP0
                movfw   byte_DATA_20
                return
; End of function sub_CODE_10B

; ---------------------------------------------------------------------------
; START OF FUNCTION CHUNK FOR ISR

loc_CODE_176                           ; CODE XREF: ISR+5?j
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                btfsc   BANK1_PIE1, 5
                 b       loc_CODE_17C
; assume bank = 0

loc_CODE_179                           ; CODE XREF: ISR+17A?j
                                        ; ISR+184?j
                btfss   BANK0_INTCON, INTE
                 b       loc_CODE_18B
                b       loc_CODE_189
; ---------------------------------------------------------------------------
; assume bank = 1

loc_CODE_17C                           ; CODE XREF: ISR+174?j
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                btfss   BANK0_PIR1, 5
                 b       loc_CODE_179
                bcf     BANK0_PIR1, 5
                movlw   3
                addwf   BANK0_RESERVED0013, f
                addcf   BANK0_RESERVED0014, f
                movlw   14
                addwf   BANK0_RESERVED0014, f
                bcf     BANK0_PIR1, 5
                call    sub_CODE_230
                b       loc_CODE_179
; ---------------------------------------------------------------------------

loc_CODE_189                           ; CODE XREF: ISR+177?j
                btfsc   BANK0_INTCON, INTF
                 b       loc_CODE_18F

loc_CODE_18B                           ; CODE XREF: ISR+176?j
                                        ; ISR+198?j
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                btfss   BANK1_PIE1, 1
                 b       loc_CODE_1A0
                b       loc_CODE_19D
; ---------------------------------------------------------------------------
; assume bank = 0

loc_CODE_18F                           ; CODE XREF: ISR+186?j
                bcf     BANK0_INTCON, INTF
                movlw   0x50 ; 'P'
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                movwf   BANK1_RESERVED0092
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bcf     BANK0_PIR1, 1
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                bsf     BANK1_PIE1, 1
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                bsf     BANK0_RESERVED0012, 2
                bcf     BANK0_INTCON, INTE
                bcf     BANK0_INTCON, INTF
                bsf     BANK0_GPIO, GPIO4
                b       loc_CODE_18B
; ---------------------------------------------------------------------------
; assume bank = 1

loc_CODE_19D                           ; CODE XREF: ISR+18A?j
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                btfsc   BANK0_PIR1, 1
                 b       loc_CODE_1A7

loc_CODE_1A0                           ; CODE XREF: ISR+189?j
                                        ; ISR+1AC?j
                movfw   byte_DATA_79
                movwf   BANK0_PCLATH
                swapf   byte_DATA_78, w
                movwf   BANK0_STATUS
                swapf   byte_DATA_7E, f
                swapf   byte_DATA_7E, w
                retfie
; ---------------------------------------------------------------------------

loc_CODE_1A7                           ; CODE XREF: ISR+19B?j
                bcf     BANK0_PIR1, 1
                movlw   0xA0
                bsf     BANK0_STATUS, RP0
; assume bank = 1
                movwf   BANK1_RESERVED0092
                movlw   0
                bcf     BANK1_STATUS, RP0
; assume bank = 0
                btfsc   BANK0_GPIO, GPIO2
                 movlw   1
                call    sub_CODE_1EB
                b       loc_CODE_1A0
; END OF FUNCTION CHUNK FOR ISR

; =============== S U B R O U T I N E =======================================


sub_CODE_1B1                           ; CODE XREF: sub_CODE_207+7?p
                movlw   0x93
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

loc_CODE_1C1                           ; CODE XREF: sub_CODE_1B1+D?j
                movlw   80
                movwf   byte_DATA_20

loc_CODE_1C3                           ; CODE XREF: sub_CODE_1B1+F?j
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
                movlw   0FF
                clrf    byte_DATA_3A
                clrf    byte_DATA_3A
                andwf   byte_DATA_3B, f
                movfw   byte_DATA_26
                iorwf   byte_DATA_3A, f
                return
; End of function sub_CODE_1B1


; =============== S U B R O U T I N E =======================================


sub_CODE_1D9                           ; CODE XREF: RESET_0+FF?p
                movfw   byte_DATA_31
                bz      loc_CODE_1E0
                movlw   6
                xorwf   byte_DATA_31, w
                skpz
                 return

loc_CODE_1E0                           ; CODE XREF: sub_CODE_1D9+1?j
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


sub_CODE_1EB                           ; CODE XREF: ISR+1AB?p
                movwf   byte_DATA_77
                movfw   byte_DATA_77
                bz      loc_CODE_1F1
                movlw   1
                b       loc_CODE_1F2
; ---------------------------------------------------------------------------

loc_CODE_1F1                           ; CODE XREF: sub_CODE_1EB+2?j
                movlw   0

loc_CODE_1F2                           ; CODE XREF: sub_CODE_1EB+5?j
                movwf   byte_DATA_76
                movfw   byte_DATA_74
                xorwf   byte_DATA_76, w
                andlw   0FE
                xorwf   byte_DATA_76, w
                movwf   byte_DATA_74
                bsf     byte_DATA_74, 2
                return
; End of function sub_CODE_1EB


; =============== S U B R O U T I N E =======================================


sub_CODE_1FA                           ; CODE XREF: sub_CODE_16+71?p
                                        ; sub_CODE_222+6?j
                bcf     BANK0_STATUS, RP0
                clrf    byte_DATA_31
                movlw   1
                movwf   byte_DATA_35
                clrf    byte_DATA_36
                bsf     byte_DATA_37, 0
                movlw   2
                movwf   byte_DATA_32
                clrf    byte_DATA_33
                clrf    byte_DATA_34
                bcf     byte_DATA_37, 1
                bsf     byte_DATA_37, 2
                return
; End of function sub_CODE_1FA


; =============== S U B R O U T I N E =======================================


sub_CODE_207                           ; CODE XREF: RESET_0+E7?p
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


sub_CODE_212                           ; CODE XREF: RESET_0+4?p
                                        ; RESET_0+9?p
                clrwdt

loc_CODE_213                           ; CODE XREF: sub_CODE_212+7?j
                clrf    byte_DATA_0
                incf    BANK0_FSR, f
                xorwf   BANK0_FSR, w
                skpnz
                 retlw   0
                xorwf   BANK0_FSR, w
                b       loc_CODE_213
; End of function sub_CODE_212


; =============== S U B R O U T I N E =======================================


sub_CODE_21A                           ; CODE XREF: RESET_0+F6?p
                movfw   byte_DATA_75
                skpz
                 decf    byte_DATA_75, f
                movfw   byte_DATA_3B
                movwf   byte_DATA_21
                movfw   byte_DATA_3A
                movwf   byte_DATA_20
                return
; End of function sub_CODE_21A


; =============== S U B R O U T I N E =======================================


sub_CODE_222                           ; CODE XREF: RESET_0:loc_CODE_DB?p
                clrf    byte_DATA_70
                movlw   8
                movwf   byte_DATA_73
                bcf     byte_DATA_74, 1
                bcf     byte_DATA_74, 2
                bcf     byte_DATA_74, 0
                b       sub_CODE_1FA
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


sub_CODE_230                           ; CODE XREF: ISR+183?p
                btfss   byte_DATA_37, 0
                 b       loc_CODE_234
                bcf     BANK0_GPIO, GPIO0
                b       loc_CODE_235
; ---------------------------------------------------------------------------

loc_CODE_234                           ; CODE XREF: sub_CODE_230+1?j
                bsf     BANK0_GPIO, GPIO0

loc_CODE_235                           ; CODE XREF: sub_CODE_230+3?j
                bsf     byte_DATA_37, 2
                return
; End of function sub_CODE_230


; =============== S U B R O U T I N E =======================================


sub_CODE_237                           ; CODE XREF: RESET_0+D2?p
                clrf    byte_DATA_38
                clrf    byte_DATA_39
                clrf    byte_DATA_3A
                clrf    byte_DATA_3B
                clrf    byte_DATA_75
                return
; End of function sub_CODE_237


; =============== S U B R O U T I N E =======================================


sub_CODE_23D                           ; CODE XREF: RESET_0:loc_CODE_F4?p
                rrf     byte_DATA_37, w
                movwf   byte_DATA_20
                rrf     byte_DATA_20, w
                andlw   1
                return
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


sub_CODE_247                           ; CODE XREF: RESET_0:loc_CODE_E0?p
                rrf     byte_DATA_74, w
                movwf   byte_DATA_20
                rrf     byte_DATA_20, w
                andlw   1
                return
; End of function sub_CODE_247


; =============== S U B R O U T I N E =======================================


sub_CODE_24C                           ; CODE XREF: RESET_0+DE?p
                movfw   byte_DATA_72
                movwf   byte_DATA_21
                movfw   byte_DATA_71
                movwf   byte_DATA_20
                return
; End of function sub_CODE_24C


; =============== S U B R O U T I N E =======================================


sub_CODE_251                           ; CODE XREF: RESET_0+F2?p
                movfw   byte_DATA_75
                return
; End of function sub_CODE_251

; ---------------------------------------------------------------------------
; ===========================================================================

; Segment type: Internal processor memory & SFR
                ; .data (DATA)
; assume bank = 0
; assume pclath = 0
byte_DATA_0     equ 0                   ; DATA XREF: sub_CODE_212:loc_CODE_213?w
BANK0_TMR0      equ 1
BANK0_PCL       equ 2                   ; DATA XREF: sub_CODE_16+7D?w
                                        ; sub_CODE_10B+66?w
BANK0_STATUS    equ 3                   ; DATA XREF: ISR+1?w
                                        ; RESET_0+6?w ...
C              equ 0
DC             equ 1
Z              equ 2
PD             equ 3
TO             equ 4
RP0            equ 5

BANK0_FSR       equ 4                   ; DATA XREF: RESET_0+2?w
                                        ; RESET_0+7?w ...
BANK0_GPIO      equ 5                   ; DATA XREF: RESET_0+92?w
                                        ; RESET_0+93?w ...
GPIO0          equ 0
GPIO1          equ 1
GPIO2          equ 2
GPIO3          equ 3
GPIO4          equ 4
GPIO5          equ 5

BANK0_RESERVED0006 equ 6
BANK0_RESERVED0007 equ 7
BANK0_RESERVED0008 equ 8
BANK0_RESERVED0009 equ 9
BANK0_PCLATH    equ 0A                  ; DATA XREF: ISR+3?r
                                        ; sub_CODE_16+7A?w ...
PCLATH0        equ 0
PCLATH1        equ 1
PCLATH2        equ 2
PCLATH3        equ 3
PCLATH4        equ 4

BANK0_INTCON    equ 0xB                  ; DATA XREF: RESET_0+A4?w
                                        ; RESET_0+A9?w ...
GPIF           equ 0
INTF           equ 1
T0IF           equ 2
GPIE           equ 3
INTE           equ 4
T0IE           equ 5
PEIE           equ 6
GIE            equ 7

BANK0_PIR1      equ 0xC                  ; DATA XREF: RESET_0+A8?w
                                        ; RESET_0+B0?w ...
TMR1IF         equ 0
CMIF           equ 3
ADIF           equ 6
EEIF           equ 7

BANK0_RESERVED000D equ 0xD
BANK0_TMR1L     equ 0xE                  ; DATA XREF: RESET_0+9F?w
BANK0_TMR1H     equ 0xF                  ; DATA XREF: RESET_0+A0?w
BANK0_T1CON     equ 0x10                  ; DATA XREF: RESET_0+A1?w
                                        ; RESET_0+A2?w ...
TMR1ON         equ 0
TMR1CS         equ 1
T1SYNC         equ 2
T1OSCEN        equ 3
T1CKPS0        equ 4
T1CKPS1        equ 5
TMR1GE         equ 6

BANK0_RESERVED0011 equ 0x11
BANK0_RESERVED0012 equ 0x12               ; DATA XREF: RESET_0+B4?w
                                        ; RESET_0+B5?w ...
BANK0_RESERVED0013 equ 0x13               ; DATA XREF: RESET_0+AF?w
                                        ; ISR+17D?w
BANK0_RESERVED0014 equ 0x14               ; DATA XREF: RESET_0+AD?w
                                        ; ISR+17E?w ...
BANK0_RESERVED0015 equ 0x15               ; DATA XREF: RESET_0+AB?w
BANK0_RESERVED0016 equ 0x16
BANK0_RESERVED0017 equ 0x17
BANK0_RESERVED0018 equ 0x18
BANK0_CMCON     equ 0x19                  ; DATA XREF: RESET_0+98?w
CM0            equ 0
CM1            equ 1
CM2            equ 2
CIS            equ 3
CINV           equ 4
COUT           equ 6

BANK0_RESERVED001A equ 0x1A
BANK0_RESERVED001B equ 0x1B
BANK0_RESERVED001C equ 0x1C
BANK0_RESERVED001D equ 0x1D
BANK0_ADRESH    equ 0x1E
BANK0_ADCON0    equ 0x1F
ADON           equ 0
GO_DONE        equ 1
CHS0           equ 2
CHS1           equ 3
VCFG           equ 6
ADFM           equ 7

byte_DATA_20    equ 0x20                  ; DATA XREF: sub_CODE_16:loc_CODE_25?w
                                        ; sub_CODE_16+11?r ...
byte_DATA_21    equ 0x21                  ; DATA XREF: sub_CODE_16+3F?w
                                        ; RESET_0+DF?r ...
byte_DATA_22    equ 0x22                  ; DATA XREF: sub_CODE_16:loc_CODE_5C?w
                                        ; sub_CODE_16+48?r ...
byte_DATA_23    equ 0x23                  ; DATA XREF: sub_CODE_16+6?w
                                        ; sub_CODE_16+68?w ...
byte_DATA_24    equ 0x24                  ; DATA XREF: sub_CODE_1B1+7?w
                                        ; sub_CODE_1B1+A?r
byte_DATA_25    equ 0x25                  ; DATA XREF: sub_CODE_1B1+1?w
                                        ; sub_CODE_1B1+B?w ...
byte_DATA_26    equ 0x26                  ; DATA XREF: sub_CODE_1B1+2?w
                                        ; sub_CODE_1B1+9?w ...
byte_DATA_27    equ 0x27                  ; DATA XREF: RESET_0+E6?w
                                        ; sub_CODE_207+5?r
byte_DATA_28    equ 0x28                  ; DATA XREF: RESET_0+E4?w
                                        ; sub_CODE_207+3?r

byte_DATA_2D    equ 0x2D                  ; DATA XREF: RESET_0+E2?w
                                        ; RESET_0+E5?r
byte_DATA_2E    equ 0x2E                  ; DATA XREF: RESET_0+E0?w
                                        ; RESET_0+E3?r
byte_DATA_2F    equ 0x2F                  ; DATA XREF: RESET_0+FA?w
                                        ; RESET_0+FD?r
byte_DATA_30    equ 0x30                  ; DATA XREF: RESET_0+F8?w
                                        ; RESET_0+FB?r
byte_DATA_31    equ 0x31                  ; DATA XREF: sub_CODE_16+20?w
                                        ; sub_CODE_16+2C?w ...
byte_DATA_32    equ 0x32                  ; DATA XREF: sub_CODE_16+18?r
                                        ; sub_CODE_16:loc_CODE_31?w ...
byte_DATA_33    equ 0x33                  ; DATA XREF: sub_CODE_16+3A?r
                                        ; sub_CODE_1D9+A?w ...
byte_DATA_34    equ 0x34                  ; DATA XREF: sub_CODE_16+3D?r
                                        ; sub_CODE_1D9+8?w ...
byte_DATA_35    equ 0x35                  ; DATA XREF: sub_CODE_16:loc_CODE_1E?r
                                        ; sub_CODE_16+16?w ...
byte_DATA_36    equ 0x36                  ; DATA XREF: sub_CODE_16+17?w
                                        ; sub_CODE_16+25?w ...
byte_DATA_37    equ 0x37                  ; DATA XREF: sub_CODE_16+1?r
                                        ; sub_CODE_16+10?r ...
byte_DATA_38    equ 0x38                  ; DATA XREF: sub_CODE_1B1+3?r
                                        ; sub_CODE_207+6?w ...
byte_DATA_39    equ 0x39                  ; DATA XREF: sub_CODE_1B1+6?r
                                        ; sub_CODE_207+4?w ...
byte_DATA_3A    equ 0x3A                  ; DATA XREF: sub_CODE_1B1+1E?w
                                        ; sub_CODE_1B1+22?w ...
byte_DATA_3B    equ 0x3B                  ; DATA XREF: sub_CODE_1B1+1F?w
                                        ; sub_CODE_1B1+20?w ...

byte_DATA_70    equ 0x70                  ; DATA XREF: RESET_0:loc_CODE_B?o
                                        ; RESET_0+CA?w ...
byte_DATA_71    equ 0x71                  ; DATA XREF: sub_CODE_10B+9?w
                                        ; sub_CODE_10B+40?w ...
byte_DATA_72    equ 0x72                  ; DATA XREF: sub_CODE_10B+A?w
                                        ; sub_CODE_10B+41?w ...
byte_DATA_73    equ 0x73                  ; DATA XREF: RESET_0+CC?w
                                        ; sub_CODE_10B+5?w ...
byte_DATA_74    equ 0x74                  ; DATA XREF: RESET_0+CD?w
                                        ; RESET_0+CE?w ...
byte_DATA_75    equ 0x75                  ; DATA XREF: sub_CODE_207?r
                                        ; sub_CODE_207+8?w ...
byte_DATA_76    equ 0x76                  ; DATA XREF: sub_CODE_1EB:loc_CODE_1F2?w
                                        ; sub_CODE_1EB+9?r ...
byte_DATA_77    equ 0x77                  ; DATA XREF: sub_CODE_1EB?w
                                        ; sub_CODE_1EB+1?r
byte_DATA_78    equ 0x78                  ; DATA XREF: ISR+2?w
                                        ; ISR+19E?w
byte_DATA_79    equ 0x79                  ; DATA XREF: ISR+4?w
                                        ; ISR:loc_CODE_1A0?r
byte_DATA_7E    equ 0x7E                  ; DATA XREF: ISR?w
                                        ; ISR+1A0?w ...

BANK1_OPTION    equ 0x81                  ; DATA XREF: RESET_0+9D?w
                                        ; RESET_0+C0?w
PS0            equ 0
PS1            equ 1
PS2            equ 2
PSA            equ 3
T0SE           equ 4
T0CS           equ 5
INTEDG         equ 6
GPPU           equ 7

BANK1_PCL       equ 0x82
BANK1_STATUS    equ 0x83                  ; DATA XREF: RESET_0+91?w
                                        ; RESET_0+9E?w ...
C              equ 0
DC             equ 1
Z              equ 2
PD             equ 3
TO             equ 4
RP0            equ 5

BANK1_FSR       equ 0x84
BANK1_TRISIO    equ 0x85                  ; DATA XREF: RESET_0+9C?w
TRIS0          equ 0
TRIS1          equ 1
TRIS2          equ 2
TRIS3          equ 3
TRIS4          equ 4
TRIS5          equ 5

BANK1_RESERVED0086 equ 0x86
BANK1_RESERVED0087 equ 0x87
BANK1_RESERVED0088 equ 0x88
BANK1_RESERVED0089 equ 0x89
BANK1_PCLATH    equ 0x8A
PCLATH0        equ 0
PCLATH1        equ 1
PCLATH2        equ 2
PCLATH3        equ 3
PCLATH4        equ 4

BANK1_INTCON    equ 0x8B                  ; DATA XREF: RESET_0+C1?w
GPIF           equ 0
INTF           equ 1
T0IF           equ 2
GPIE           equ 3
INTE           equ 4
T0IE           equ 5
PEIE           equ 6
GIE            equ 7

BANK1_PIE1      equ 0x8C                  ; DATA XREF: RESET_0+A6?w
                                        ; RESET_0+B2?w ...
TMR1IE         equ 0
CMIE           equ 3
ADIE           equ 6
EEIE           equ 7

BANK1_RESERVED008D equ 0x8D
BANK1_PCON      equ 0x8E
BOD            equ 0
POR            equ 1

BANK1_RESERVED008F equ 0x8F               ; DATA XREF: RESET_0+8E?w
                                        ; RESET_0+8F?w ...
BANK1_OSCCAL    equ 0x90
CAL0           equ 2
CAL1           equ 3
CAL2           equ 4
CAL3           equ 5
CAL4           equ 6
CAL5           equ 7

BANK1_RESERVED0091 equ 0x91
BANK1_RESERVED0092 equ 0x92               ; DATA XREF: RESET_0+BC?w
                                        ; ISR+18E?w ...
BANK1_RESERVED0093 equ 0x93
BANK1_RESERVED0094 equ 0x94
BANK1_WPU       equ 0x95
WPU0           equ 0
WPU1           equ 1
WPU2           equ 2
WPU4           equ 4
WPU5           equ 5

BANK1_IOCB      equ 0x96
IOCB0          equ 0
IOCB1          equ 1
IOCB2          equ 2
IOCB3          equ 3
IOCB4          equ 4
IOCB5          equ 5

BANK1_RESERVED0097 equ 0x97
BANK1_RESERVED0098 equ 0x98
BANK1_VRCON     equ 0x99
VR0            equ 0
VR1            equ 1
VR2            equ 2
VR3            equ 3
VRR            equ 5
VREN           equ 7

BANK1_EEDATA    equ 0x9A
EEDATA0        equ 0
EEDATA1        equ 1
EEDATA2        equ 2
EEDATA3        equ 3
EEDATA4        equ 4
EEDATA5        equ 5
EEDATA6        equ 6
EEDATA7        equ 7

BANK1_EEADR     equ 0x9B
EEADR0         equ 0
EEADR1         equ 1
EEADR2         equ 2
EEADR3         equ 3
EEADR4         equ 4
EEADR5         equ 5
EEADR6         equ 6

BANK1_EECON1    equ 0x9C
RD             equ 0
WR             equ 1
WREN           equ 2
WRERR          equ 3
BANK1_EECON2    equ 0x9D
BANK1_ADRESL    equ 0x9E
BANK1_ANSEL     equ 0x9F                  ; DATA XREF: RESET_0+9A?w
ANS0           equ 0
ANS1           equ 1
ANS2           equ 2
ANS3           equ 3
ADCS0          equ 4
ADCS1          equ 5
ADCS2          equ 6

                end ;
