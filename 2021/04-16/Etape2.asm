;  Fichier : Etape1.asm

global _main
extern _printf
extern _scanf

section .data

incitation:	db "Entrer un message encode (max 400 caracteres) : ", 0

fmt_in :		db "%s", 0
fmt_echo:		db "Echo = %s", 10, 0
fmt_enClair:	db "Message en clair = %s", 10, 0
fmt_Encode:		db "Message encode   = %s", 10, 0


Clair_LGR : dd 0
fmt_Clair_LGR:	db "Clair_LGR = %u", 10, 0

Encode_LGR : dd 0
fmt_Encode_LGR:	db "Encode_LGR = %u", 10, 0


section .bss
texte_enClair : resb 220
texte_Encode: 	resb 440


section .text




_main:

	push ebp	
	mov ebp, esp


;==============================================================================================================================

	; Lecture du message en texte encodé (illisible).
	push	incitation		; Point d'incitation	;;;;;;;;;;;;;;;;;;,,Entrer un message encode (max 400 caracteres) :
	call	_printf
	add		esp, 4
	
	push	texte_Encode	; Lecture proprement dite
	push	fmt_in 
	call	_scanf					;;;;;;;;;;;;;;;;;; %s
	add		esp, 8
	
	push	texte_Encode	; Écho
	push	fmt_Encode				;;;;;;;;;;;;;;;;;;;;;;; Message encode   = %s
	call	_printf
	add		esp, 8
	
	; Déterminer la longueur du message encodé - on suppose qu'il y a un caractère NUL à la fin.
	MOV		ECX,440    			; Maximum d'itérations
	MOV		AL, 0				; 0 = Caractère NUL
	MOV		EDI, texte_Encode	; Recherche dans texte_encode
	CLD							; EDI sera incrémenté par un à chaque itération.
	REPNE	SCASB				; Recherche dans texte_encode
	
	sub		EDI, texte_Encode+1  ; Position relative du caractère NUL par rapport au début de texte_encode
								  ; Le +1 est pour corriger le fait que EDI termine sur le caractère NULL et non pas le dernier
								  ; caractère du "message secret".
	mov		dword[Encode_LGR], EDI
	shr		edi, 1					; Équivalent à une division par 2.
	mov		dword[Clair_LGR], EDI
	

	
	push	dword[Clair_LGR]
	push	fmt_Clair_LGR				;;;;;;;;;;;;;;;;;;;;;;;;;;Clair_LGR = %u
	call	_printf
	add		esp, 8

	push	dword[Encode_LGR]
	push	fmt_Encode_LGR				;;;;;;;;;;;;;;;;;;;;;;;;;;; Encode_LGR = %u
	call	_printf
	add		esp, 8

	
	
;==============================================================================================================================
; Votre code commence ici.

	mov esi,texte_Encode	; first byte address of encoded text
	mov edi,texte_enClair	; first byte address to store decoded text
	mov ecx,[Encode_LGR]	; counter for bytes decoded

l1:	mov dh,[esi]		; byte with upper nibble encoded
	shl dh,4		; upper 4 dh bits store upper nibble from original number
	inc esi			; next byte address
	mov dl,[esi]		; second char encoded with lower nibble to dl register
	and dl,0x0F		; original byte lower nibble to dl register
	or  dl,dh		; original byte to dl
	inc esi			; increment esi to access the next encoded byte
	mov [edi],dl		; store the original byte on memory
	inc edi			; increment edi to store the next original byte on the next byte address
	dec ecx			; decrement the char counter
	dec ecx			; decrement char counter again
	cmp ecx,0x1		; compare with 1 for any encoded char available
	ja l1			; if there are encoded chars available go to l1 label and repeat

; Fin de votre code.
;==============================================================================================================================


	push	texte_enClair	
	push	fmt_enClair		;;;;;;;;;;;;;;;;;;;; Message en clair = %s
	call	_printf
	add		esp, 8

;===============================================================================================================================================

	
	mov esp, ebp
	pop ebp	
	
	mov eax, 0
	
	ret
