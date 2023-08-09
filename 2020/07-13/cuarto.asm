;yasm -g dwarf2 -f elf64 example.asm -l example.lst
;ld -g -o example example.o

section .data
	array dd 0x34,0x36,0x31,0x37,0x32,0x38,0x35,0x33
	n equ 8
	menor db "Menor: "
	menorl equ $-menor
	mayor db " Mayor: "
	mayorl equ $-mayor
	salto db 10

section .text
	global _start

_start:
	mov ecx,n	; almaceno el número de elementos del array en el registro contador
	dec ecx		; decremento en 1 el registro contador

lazoExterno: mov ebx,ecx; copio ecx a ebx
	mov esi,array	; copio la dirección del primer elemento del array al registro esi

lazoInterno: mov eax,dword[esi] ; copio en eax primer elemento a comparar
	mov edx,dword[esi+4]	; copio en edx el siguiente elemento a comparar
	cmp eax,edx		; comparo eax con edx
	jl esMenor		; si eax es menor a edx salta a esMenor
	mov dword[esi],edx	; si edx es menor, ponerlo donde estaba eax
	mov dword[esi+4],eax	; copiar eax(mayor) a donde estaba edx(menor)
esMenor: add esi,4		; incrementa a la dirección del siguiente elemento del array
	dec ebx			; decrementa en 1 ebx
	jnz lazoInterno		; si ebx no es 0 salta a la etiqueta lazoInterno

	loop lazoExterno	; si ecx no es 0 salta a la etiqueta lazoExterno

	mov eax,4		; copia 4 en eax para escribir en pantalla
	mov ebx,1		; copia 1 en ebx, indica stdout
	mov ecx,menor		; copia a ecx dirección de la primera letra del mensaje a imprimir
	mov edx,menorl		; copia en edx la cantidad de caracteres a imprimir
	int 80H			; imprime en pantalla

	mov eax,4		; copia 4 en eax para escribir en pantalla
	mov ebx,1		; copia 1 en ebx, indica stdout
	mov ecx,array		; copia a ecx dirección del primer elemento del array
	mov edx,4		; copia en edx la cantidad de bytes a imprimir (4 bytes=32bits)
	int 80H			; imprime en pantalla

	mov eax,4		; copia 4 en eax para escribir en pantalla
	mov ebx,1		; copia 1 en ebx, indica stdout
	mov ecx,mayor		; copia a ecx dirección de la primera letra del mensaje a imprimir
	mov edx,mayorl		; copia en edx la cantidad de caracteres a imprimir
	int 80H			; imprime en pantalla

	mov eax,4		; copia 4 en eax para escribir en pantalla
	mov ebx,1		; copia 1 en ebx, indica stdout
	mov ecx,(array+(n-1)*4)	; copia a ecx dirección del último elemento del array
	mov edx,4		; copia en edx la cantidad de bytes a imprimir (4 bytes=32bits)
	int 80H			; imprime en pantalla

	mov eax,4		; copia 4 en eax para escribir en pantalla
	mov ebx,1		; copia 1 en ebx, indica stdout
	mov ecx,salto		; copia a ecx dirección de la variable salto
	mov edx,1		; copia en edx la cantidad de caracteres a imprimir
	int 80H			; imprime en pantalla

	mov eax,1		; copia 1 en eax
	xor ebx,ebx		; iguala ebx a 0
	int 80H			; llamado a interrupción
