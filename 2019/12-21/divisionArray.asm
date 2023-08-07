#include <p16f690.inc>
    __config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOD_OFF & _IESO_OFF & _FCMEN_OFF)
    org 0

arr0	equ 20h	; nine elements array declaration
arr1	equ 21h
arr2	equ 22h
arr3	equ 23h
arr4	equ 24h
arr5	equ 25h
arr6	equ 26h
arr7	equ 27h
arr8	equ 28h
result	equ 29h	; other variables
counter	equ 30h
arrayE	equ 31h
number	equ 32h

START
    movlw d'69'	    ; move decimal 69 to w register
    movwf arr0	    ; move value stored on w to arr0
    movlw d'17'	    ; move decimal 17 to w register
    movwf arr1	    ; move value stored on w to arr1
    movlw d'29'	    ; move decimal 29 to w register
    movwf arr2	    ; move value stored on w to arr2
    movlw d'126'    ; move decimal 126 to w register
    movwf arr3	    ; move value stored on w to arr3
    movlw d'13'	    ; move decimal 13 to w register
    movwf arr4	    ; move value stored on w to arr4
    movlw d'20'	    ; move decimal 20 to w register
    movwf arr5	    ; move value stored on w to arr5
    movlw d'28'	    ; move decimal 28 to w register
    movwf arr6	    ; move value stored on w to arr6
    movlw d'15'	    ; move decimal 15 to w register
    movwf arr7	    ; move value stored on w to arr7
    movlw d'21'	    ; move decimal 21 to  w register
    movwf arr8	    ; move value stored on w to arr8
loop
    movlw d'9'	    ; store 9 on w register
    movwf arrayE    ; arrayE: number of array elements=9
    movlw d'0'
    movwf counter   ; counter=0 to count the divisions with reminder equals to 5
    movlw arr0	    ; store the direction on memory of arr0, the first array element
    movwf FSR	    ; copy to FSR the direction on memory of arr0
    call subRo	    ; call to the subroutine
    goto loop	    ; repeat all again from loop label

subRo		    ; subroutine start
    movlw d'0'
    movwf result    ; result=0, result stores how many times is the divider on the dividend
    movf INDF,0	    ; stores on w the value pointed by FSR, the value on the direction contained in FSR is on INDF
    movwf number    ; stores on number the value pointed by FSR
    movlw d'8'	    ; store the divider 8 on w
l1  subwf number,1  ; number = number - 8
    btfsc STATUS,C  ; if 8(w) is more than the reminder, do not execute the next line
    goto quotient   ; go to where quotient label is
    goto remainder  ; go to where remainder label is
quotient
    incf result,1   ; increase in 1 for each time the divider is contained in the dividend
    goto l1	    ; go where l1 label is
remainder
    addwf number,1  ; add 8 to number to obtain the reminder of the division
    movlw d'5'	    ; store 5 on w
    subwf number,1  ; to compare the reminder with 5, substracting 5 from number
    btfss STATUS,Z  ; if the result is 0, do not execute the next line
    goto isNot5	    ; go where isNot5 label is
    goto is5	    ; go where is5 label is
isNot5		    ; isNot5 label
    incf FSR,1	    ; increment the direction to point to the next element in the array
    decfsz arrayE,1 ; decrement the number of array elements, if it's 0 don't execute the next line
    goto subRo	    ; go where subRo label is
    return	    ; return to the next line where subroutine was called
is5		    ; is5 label
    incf FSR,1	    ; increment the direction to point to the next element in the array
    incf counter,1  ; increments the counter of divisions with reminder equals to 5
    decfsz arrayE,1 ; decrement the number of array elements, if it's 0 don't execute the next line
    goto subRo	    ; go where subRo label is
    return	    ; return to the next line where subroutine was called

    END