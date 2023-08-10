;  Fichier : Etape1.asm

global _main
extern _printf
extern _scanf

section .data

incitation:		db "Entrer un message en clair (max 200 caracteres) : ", 0

fmt_in :		db "%s", 0
fmt_enClair:	db "Message en clair = %s", 10, 0
fmt_Encode:		db "Message encode   = %s", 10, 0


Clair_LGR : 	dd 0
fmt_Clair_LGR:	db "Clair_LGR = %u", 10, 0

Encode_LGR : 	dd 0
fmt_Encode_LGR:	db "Encode_LGR = %u", 10, 0

section .bss
;texte_enClair : resb 220
texte_Encode: 	resb 440



section .text




_main:

	push ebp	
	mov ebp, esp


;==============================================================================================================================
; Code fourni : Ne pas modifier.


	; Lecture du message en texte clair (lisible).
	push	incitation		; Point d'incitation
	call	_printf				;;;;;;;;;;;;;;;;;;Entrer un message en clair (max 200 caracteres) :
	add		esp, 4
	
	push	texte_enClair	; Lecture proprement dite
	push	fmt_in 				;%s
	call	_scanf
	add		esp, 8
	
	push	texte_enClair	; Écho
	push	fmt_enClair			;;;;;;;;;;;;;;;;;;; Message en clair = %s
	call	_printf
	add		esp, 8
	
	; Déterminer la longueur du message en clair - on suppose qu'il y a un caractère NUL à la fin.
	MOV		ECX, 220    		; Maximum d'itérations
	MOV		AL, 0				; 0 = Caractère NUL
	MOV		EDI, texte_enClair	; Recherche dans texte_enClair
	CLD							; EDI sera incémenté par un à chaque itération.
	REPNE		SCASB				; Recherche dans texte_enClair
	
	sub		EDI, texte_enClair+1  ; Position relative du caractère NUL par rapport au début de texte_enClair
								  ; Le +1 est pour corriger le fait que EDI termine sur le caractère NUL et non pas le dernier
								  ; caractère du "message".
	mov		dword[Clair_LGR], EDI
	
	add		EDI, EDI			 ; EDI = EDI * 2   Encode_LGR sera deux fois la valeur de Clair_LGR.
	mov		dword[Encode_LGR], EDI
	
	
	
	push	dword[Clair_LGR]
	push	fmt_Clair_LGR			;;;;;;;;;;;;;;;;;;,Clair_LGR = %u
	call	_printf
	add		esp, 8

	push	dword[Encode_LGR]
	push	fmt_Encode_LGR			;;;;;;;;;;;;;;;;;;Encode_LGR = %u
	call	_printf
	add		esp, 8

	
	
;==============================================================================================================================
; Votre code va ici.
	mov esi,texte_enClair	; first byte address
	mov ecx,[Clair_LGR]	; number of bytes
	mov edi,texte_Encode	; encoded text address

l1:	mov dl,[esi]		; char on esi address to dl register
	mov dh,dl		; copy dl to dh
	and dh,0xF0		; upper nibble
	shr dh,4		; upper nibble in lower bits
	and dl,0x0F		; lower nibble isolated
	or  dl,0x40		; put the upper nibble to lower nibble
	or  dh,0x40		; put the upper nibble to upper nibble
	mov [edi],dh		; first encoded character
	inc edi			; next char address
	mov [edi],dl		; second encoded char
	inc edi			; next char address
	inc esi			; next char from original string address
	dec ecx			; decrements number of bytes
	cmp ecx,0x0		; if ecx==0 (counter)
	jne l1			; repeat from l1 label

; Fin de votre code.
;==============================================================================================================================
; Code fourni : Ne pas modifier.
	push	texte_Encode
	push	fmt_Encode		;;;;;;;;;;;;;;;;;Message encode   = %s
	call	_printf
	add		esp, 8
	


;===============================================================================================================================================

	
	mov esp, ebp
	pop ebp	
	
	mov eax, 0
	
	ret
