;yasm -g dwarf2 -f elf64 example.asm -l example.lst
;ld -g -o example example.o

section .data
	limiteInferior equ 1
	limiteSuperior equ 100
	intervalos equ 10
	total dd 0
	salto db 0xa
section .bss
	a resb 1
	b resb 1
	dif resb 1
section .text
	global _start

_start:
	mov edx,limiteInferior	; copia el valor de la constante en edx
	mov byte[a],dl		; copia el valor de edx en la dirección de memoria a

	xor rdx,rdx		; rdx = 0, inicializa rdx
	mov eax,limiteSuperior	; copia el valor limiteSuperior en eax
	mov ecx,intervalos	; copia el número de intervalos a ebx
	div ecx			; para obtener el número de intervalos
	mov byte[dif],al	; guarda la diferencia entre límites de cada sub-intervalo
	mov byte[b],al		; guarda el límite superior del primer sub-intervalo

	; f(a)
inicio:	xor eax,eax		; inicializa eax
	mov al,byte[a]		; copia el valor a  en eax
	cvtsi2ss xmm0,eax	; convierte eax entero a punto flotante
	mulss xmm0,xmm0		; f(a)=a²
	movss xmm1,xmm0		; almacena el resultado f(a) en xmm1

	; f(b)
	xor eax,eax		; inicializa eax
	mov al,byte[b]		; copia el valor b en eax
	cvtsi2ss xmm0,eax	; convierte eax entero a punto flotante
	mulss xmm0,xmm0		; f(b)=b²
	addss xmm1,xmm0		; xmm1 = f(a)+f(b)

	;4*f((a+b)/2)
	xor eax,eax		; eax = 0, para inicializar eax
	mov al,byte[a]		; copia el valor en la dirección a en eax
	add al,byte[b]		; eax = eax + b = a + b
	cvtsi2ss xmm0,eax	; convierte eax entero a punto flotante
	mov ebx,2		; copia la constante 2 en ebx
	cvtsi2ss xmm2,ebx	; convierte ebx entero a punto flotante
	divss xmm0,xmm2		; xmm0 = xmm0/xmm2 = (a+b)/2
	mulss xmm0,xmm0		; xmm0 = f((a+b)/2)
	mov edx,4		; copia la constante 4 en edx
	cvtsi2ss xmm2,edx	; convierte edx entero a punto flotante
	mulss xmm0,xmm2		; xmm0 = 4*f((a+b)/2)
	addss xmm1,xmm0		; xmm1 = f(a)+f(b)+4*f((a+b)/2)

	xor eax,eax		; eax = 0, para inicializar eax
	mov al,byte[b]		; copia el valor de b en eax
	sub al,byte[a]		; eax = b-a
	cvtsi2ss xmm0,eax	; convierte eax entero a punto flotante
	mov ebx,6		; copia la constante 6 en ebx
	cvtsi2ss xmm2,ebx	; convierte ebx entero a punto flotante
	divss xmm0,xmm2		; xmm0 = xmm0/xmm2 = (b-a)/6
	mulss xmm0,xmm1		; xmm0 = xmm0*xmm1
	addss xmm0,dword[total]	; acumulador de resultados
	movss dword[total],xmm0	; almacena en memoria el total

	xor edx,edx		; inicializa edx
	mov dl,byte[b]		; copia el límite superior a edx
	mov byte[a],dl		; el nuevo límite inferior es el superior anterior
	add dl,byte[dif]	; suma el tamaño del sub-intervalo al nuevo inferior
	mov byte[b],dl		; nuevo límite superior para la siguiente iteración

	dec ecx			; decrementa el contador
	cmp ecx,0		; compara el contador con 0
	je fin			; si el contador es 0, finaliza
	jmp inicio		; si el contador no es 0, salta al inicio

fin:	cvtss2si eax,xmm0	; convierte de punto flotante a entero
	mov ebx,10		; copia 10 en ebx
	mov esi,dif		; copia la dirección del byte dif en registro esi
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
	cmp esi,dif		; compara esi con la dirección del último caracter
	jge eti2		; salta a eti2 si esi >= a la dirección de dif

	mov eax,4		; para imprimir un salto de línea en pantalla
	mov ebx,1
	mov ecx,salto
	mov edx,1
	int 80H

	mov eax,1		; copia 1 en eax
	xor ebx,ebx		; inicializa ebx
	int 80H			; finaliza el programa
