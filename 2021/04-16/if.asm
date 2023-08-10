;  Fichier : EntreeSortie.asm

; Le texte apr�s un point-virgule est un commentaire. L'assembleur n'en tient pas compte.

; 		Code C++ et son �quivalent en NASM/C.

;		int main( )
;		{
;			int N ;
; 			cout << "Entrez la valeur de N : " ;  		// Incitation
; 			cin >> N ;					// Lecture
; 			cout << "N =  " << N << endl ;			// �cho
;			return 0 ;
;		}



;  On utilisera l'assembleur NASM.

; "global _main" est une expression qui dit o� est la premi�re instruction � �tre ex�cut�e. Regarder dans la section .text pour retrouver l'�tiquette _main.
global _main
; Les deux d�clarations suivantes (extern) indiquent � l'assembleur qu'il existe deux fonctions appel�es _printf et _scanf qui ne sont pas dans ce fichier-ci.
; L'assembleur va mettre une note dans le fichier objet (.o) que ces deux fonctions seront attendues lors de l'�dition des liens (la commande gcc dans l'�tape 2).
extern _printf
extern _scanf

; Les fonctions _printf et _scanf sont des fonctions du langage C que gcc ira r�cup�rer lors de l'�tape 2 - �dition des liens.

; La section .data est la zone o� l'on r�serve nos variables et "litt�raux" (equate) que l'on veut bien d�finir. (Il n'y a pas d'exemple de equate dans ce fichier-ci.)

section .data

; Ici, les cha�nes de caract�res sont termin�es par le caract�re NULL ( 0 ). C'est une convention.

; Dans les d�clarations ci-dessous, db tient pour data byte. C'est un type de 1 byte de long. L'assembleur va regarder le contexte pour d�cider combien de bytes en tout sont n�cessaire.

; La pr�sence de "" indique une cha�ne de caract�res. Les nombres tels 0 et 10 sont des entiers. Dans cet exemple, vu qu'ils suivent un db, ils seront cod�s dans un byte chacun.

; Le mot qui pr�c�de un : est une �tiquette. Nous la voyons comme le nom d'une variable, l'assembleur la voit comme l'adresse de d�but d'un espace m�moire.



troisieme: 		db "Debut du troisieme programme - if", 10, 10, 0
inciter: 		db "Entrez deux valeurs entieres : ", 0
PlusPetit		db "%d est plus petit que %d ", 10, 0
PasPlusPetit	db "%d est plus grand ou egal a %d", 10, 0

fin3:			db "Fin du troisieme programme", 10, 10, 0






incitation:	db "Entrez la valeur de N : ", 0

format_input:	db "%d", 0  ; Cette cha�ne est utilis�e par _scanf, le %d indique que l'on veut un entier d�cimal.
						; _scanf s'attend � un param�tre adresse sur la pile. Cette adresse doit �tre l'adresse d'une cha�ne de caract�res.
						; � partir de cette cha�ne, _scanf d�termine quoi lire du clavier : 
						;  -  %d  = entier D�cimal
						;  -  %u = Unsigned entier d�cimal 
						;  -  %s  = String
						; _scanf s'attend � ce qu'il y ait d�j� une autre adresse (d�calage) sur la pile pour identifier la variable qui va recevoir la r�ponse.

format_output: db "N =  %d", 10, 0 ; newline (10 = 0Ah), null terminator ( 0 )
						; Cette cha�ne est utilis�e par _printf.
						; _printf s'attend � un param�tre adresse sur la pile. Cette adresse doit �tre l'adresse d'une cha�ne de caract�res.
						; � partir de cette cha�ne, _printf d�termine quoi afficher � l'�cran : %d = entier d�cimal, %u = unsigned, %s = string
						; _printf s'attend � ce qu'il y ait d'autres adresses ou valeurs sur la pile pour identifier ce qui va �tre affich�. 
						; Il peut y avoir plusieurs %d, %u et %s dans la premi�re chaine. Pour chacun de ces symboles, il devra y avoir un 
						; param�tre de mis sur la pile AVANT que de mettre l'adresse de la premi�re cha�ne.

; NASM a ses propres fa�ons de faire pour d�clarer des variables. Il y a des diff�rences avec MASM, TASM, YASM et autres assembleurs.
						
N: 			times 4 db 0 ; 32-bits integer = 4 bytes
M: 			times 4 db 0 ; 32-bits integer = 4 bytes


; On ne se sert pas de la section .bss mais je la laisse au cas o� ... dans le futur ...
section .bss

; La section .text contient le code.
section .text

_main:

	push ebp						; --> 1 - sauvegarder l'�tat de la pile et du record d'activation pr�sent (le contenu du ebp est mis sur la pile)
	mov ebp, esp					; Mettre la valeur du "stack pointer" dans le "base pointer".
	push ebx						; --> 2- Sauvegarder ebx et ecx vu qu'on va les utiliser pour nos calculs (le contenu du ecx est mis sur la pile)
	push ecx						; --> 3- (le contenu du ecx est mis sur la pile)
									; Ceci se veut un exemple de sauvegarde de l'�tat des registres g�n�raux.

;==============================================================================================================================

;		long N, M;
;		cout << "Debut du troisieme programme - if" << endl << endl;

;		cout << "Entrez deux valeurs entieres : ";
;		cin >> N;
;		cin >> M;

;		if (N < M)
;			cout << N << " est plus petit que " << M << endl;
;		else
;			cout << N << " est plus grand ou egal a " << M << endl;

;		cout << "Fin du troisieme programme" << endl << endl;

;================================================================================================================================================


;		cout << "Debut du troisieme programme - if" << endl << endl;
		push 	troisieme
		call 	_printf
		add 	esp,4

;		cout << "Entrez deux valeurs entieres : ";
		push 	inciter
		call 	_printf
		add 	esp,4

;		cin >> N;
		push N
		push format_input
		call _scanf
		add	esp, 8

;		cin >> M;
		push M
		push format_input
		call _scanf
		add	esp, 8



;		if (N < M)

		MOV	EAX, dword[N]		
		CMP	EAX, dword[M]	
		
		JNL else
;			cout << N << " est plus petit que " << M << endl;
		push 	dword[ M ]
		push 	dword[ N ]
		push 	PlusPetit
		call 	_printf
		add 	esp,12


		JMP	fin_si
		
;		else
else:

;			cout << N << " est plus grand ou egal a " << M << endl;
		push 	dword[ M ]
		push 	dword[ N ]
		push 	PasPlusPetit
		call 	_printf
		add 	esp,12

fin_si:
;		cout << "Fin du troisieme programme" << endl << endl;
		push 	fin3
		call 	_printf
		add 	esp,4





;===============================================================================================================================================

	
	pop ecx							; <-- 3- restauration des registres ecx et ebx.
	pop ebx							; <-- 2- Notez que les pop sont en ordre inverse des push de la sauvegarde.
	
	mov esp, ebp
	pop ebp							; <-- 1- restauration du ebp original
	
	mov eax, 0						; "return 0 ;" comme dans le main() de C++
									; � ce point-ci, vous devriez voir que le "return expression ;" du C++ veut juste dire 
									; - �valuer l'expression
									; - mettre la valeur finale de l'expression dans le EAX
									; - faire un return au sytem�me d'exploitation - le programme termine.
	ret

; Note vue sur internet dans un blogue :

; "Also, note that, at least on Windows (using MinGW), printf stomps on EAX (return value), ECX, and EDX, and modifies EFLAGS. 
;  As do all of the standard C functions, that I've used thus far, for that matter."

; Donc, faire attention de sauvegarder et restaurer les registres que vous utilisez.
; Ne pas oublier d'enlever les param�tres que vous passez. (== Faire le m�nage.)