

.model small

.stack 256

.data
;========================Variables declaradas aqu?===========================
cadena db     13,10,'cadena',13,10,'$'  ; declaraci?n de variable 1
contrasena db   'f'                     ; declaraci?n de variable 2
;============================================================================
.code
main:   mov ax,@data
        mov ds,ax                   ;eax
        mov es, ax                  ;set segment register
        and sp, not 3               ;align stack to avoid AC fault
;====================================C?digo==================================  
bucle:
    mov ah,09               ; seleciono opci?n de mostrar string en pantalla
    mov dx ,offset cadena   ; obtengo la direcci?n del string
    int 21h                 ; llamado a rutina de servicio de interrupci?n 21h para imprimir string

    mov ah,01h              ; para leer el teclado con eco
    int 21h                 ; llamado a arutina de servicio de interrupci?n 21h para leer un caracter con eco

    mov dl,contrasena       ; copio el valor de la variable contrasena en el registro dl
    cmp al,dl               ; comparo al y dl para ver si son iguales, en al est? el caracter le?do por teclado
    jz fin                  ; si al y dl son iguales continuar la ejecuci?n del programa en la etiqueta fin
    jmp bucle              ; si al y dl no son iguales, saltar a la etiqueta bucle para repetir todo

fin:
;============================================================================
    mov ax,4c00h            ; terminate program
    int 21h
.exit
;================================Funciones aqu?==============================
 




;============================================================================
end main
