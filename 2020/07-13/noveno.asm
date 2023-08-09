;yasm -g dwarf2 -f elf64 example.asm -l example.lst
;ld -g -o example example.o

section .data
	h equ 1
	x equ 50
	salto db 0xa
section .bss
	num resb 1
section .text
	global _start

_start:
	; f(x0-2h)
	mov eax,2	; copia 2 en eax
	mov edx,h	; copia la constante h en edx
	mul edx		; edx:eax = eax*2 = 2h
	mov edx,x	; copia la constante x en edx
	sub edx,eax	; edx = edx - eax = x0-2h
	mov eax,edx	; eax = x0-2h
	mul eax		; f(x0-2h)=eax²
	push rax	; almaceno en la pila rax²
	; 8f(x0-h)
	xor rax,rax	; inicializar rax
	mov eax,x	; eax = x0
	sub eax,h	; eax = eax-h = x0-h
	mul eax		; f(x0-h) = eax²
	mov edx,8	; copia 8 en edx
	mul edx		; edx:eax = eax*edx = f(x0-h)*8
	pop rdx		; guarda f(x0-2h) en rdx
	sub edx,eax	; edx = edx-eax = f(x0-2h)-8f(x0-h)
	; 8f(x0+h)
	xor rax,rax	; inicializa rax
	mov eax,x	; copia la constante x a eax
	add eax,h	; eax = eax+h = x0+h
	push rdx	; guarda rdx en el tope de la pila
	mul eax		; edx:eax = eax² = f(x0+h)
	mov edx,8	; copia 8 en edx
	mul edx		; edx:eax = eax*edx = f(x0+h)*8
	pop rdx		; guarda en rdx elemento del tope de la pila
	add edx,eax	; edx = edx+eax = f(x0-2h)-8f(x0-h)+8f(x0+h)
	; f(x0+2h)
	push rdx	; guarda rdx en el tope de la pila
	mov edx,h	; copia la constante h en edx
	mov eax,2	; copia 2 en eax
	mul edx		; edx:eax = eax*edx = 2*h
	add eax,x	; eax = eax+x = 2h+x0
	mul eax		; edx:eax = eax² = f(x0+2h)
	pop rdx		; guarda en rdx el elemento en el tope de la pila
	sub edx,eax	; edx = edx-eax = f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)

	push rdx	; guarda a rdx en el tope de la pila
	mov edx,h	; copia la constante h en edx
	mov eax,12	; copia 12 en eax
	mul edx		; edx:eax = eax*edx = 12h
	mov ebx,eax	; ebx = 12h
	pop rax		; guarda en rax el elemento en el tope de la pila
	div ebx		; eax -> f'(a)

	mov ebx,10		; copia 10 en ebx
	mov esi,num		; copia la dirección del byte num en registro esi
eti1:	xor edx,edx		; inicializa edx
	div ebx			; divide eax entre 10
	add edx,'0'		; convierte el residuo en su equivalente ascii
	mov [esi],edx		; guarda el ascii del número en la dirección en esi
	inc esi			; apunta a la dirección del siguiente byte
	cmp eax,ebx		; compara eax con ebx (10)
	jae eti1		; si eax >= 10 saltar a eti1
	add eax,'0'		; convierte el valor en eax al equivalente ascii
	mov [esi],eax		; guarda el último número convertido

eti2:	mov eax,4		; copia 4 en eax para imprimir por pantalla
	mov ebx,1		; copia 1 en ebx
	mov ecx,esi		; copia en ecx dirección del caracter a imprimir
	dec esi			; apunta al caracter anterior
	mov edx,1		; copia en edx cantidad de bytes a imprimir
	int 80H			; imprime caracter
	cmp esi,num		; compara esi con la dirección del último caracter
	jge eti2		; salta a eti2 si esi >= a la dirección de dif

	mov eax,4		; para imprimir un salto de línea en pantalla
	mov ebx,1
	mov ecx,salto
	mov edx,1
	int 80H

	mov eax,1	; copia 1 en eax
	xor ebx,ebx	; inicializa ebx
	int 80H		; finaliza el programa
