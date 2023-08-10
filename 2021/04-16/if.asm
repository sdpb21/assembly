;  Fichier : EntreeSortie.asm

; Le texte après un point-virgule est un commentaire. L'assembleur n'en tient pas compte.

; 		Code C++ et son équivalent en NASM/C.

;		int main( )
;		{
;			int N ;
; 			cout << "Entrez la valeur de N : " ;  		// Incitation
; 			cin >> N ;					// Lecture
; 			cout << "N =  " << N << endl ;			// Écho
;			return 0 ;
;		}



;  On utilisera l'assembleur NASM.

; "global _main" est une expression qui dit où est la première instruction à être exécutée. Regarder dans la section .text pour retrouver l'étiquette _main.
global _main
; Les deux déclarations suivantes (extern) indiquent à l'assembleur qu'il existe deux fonctions appelées _printf et _scanf qui ne sont pas dans ce fichier-ci.
; L'assembleur va mettre une note dans le fichier objet (.o) que ces deux fonctions seront attendues lors de l'édition des liens (la commande gcc dans l'étape 2).
extern _printf
extern _scanf

; Les fonctions _printf et _scanf sont des fonctions du langage C que gcc ira récupérer lors de l'étape 2 - édition des liens.

; La section .data est la zone où l'on réserve nos variables et "littéraux" (equate) que l'on veut bien définir. (Il n'y a pas d'exemple de equate dans ce fichier-ci.)

section .data

; Ici, les chaînes de caractères sont terminées par le caractère NULL ( 0 ). C'est une convention.

; Dans les déclarations ci-dessous, db tient pour data byte. C'est un type de 1 byte de long. L'assembleur va regarder le contexte pour décider combien de bytes en tout sont nécessaire.

; La présence de "" indique une chaîne de caractères. Les nombres tels 0 et 10 sont des entiers. Dans cet exemple, vu qu'ils suivent un db, ils seront codés dans un byte chacun.

; Le mot qui précède un : est une étiquette. Nous la voyons comme le nom d'une variable, l'assembleur la voit comme l'adresse de début d'un espace mémoire.



troisieme: 		db "Debut du troisieme programme - if", 10, 10, 0
inciter: 		db "Entrez deux valeurs entieres : ", 0
PlusPetit		db "%d est plus petit que %d ", 10, 0
PasPlusPetit	db "%d est plus grand ou egal a %d", 10, 0

fin3:			db "Fin du troisieme programme", 10, 10, 0






incitation:	db "Entrez la valeur de N : ", 0

format_input:	db "%d", 0  ; Cette chaîne est utilisée par _scanf, le %d indique que l'on veut un entier décimal.
						; _scanf s'attend à un paramètre adresse sur la pile. Cette adresse doit être l'adresse d'une chaîne de caractères.
						; À partir de cette chaîne, _scanf détermine quoi lire du clavier : 
						;  -  %d  = entier Décimal
						;  -  %u = Unsigned entier décimal 
						;  -  %s  = String
						; _scanf s'attend à ce qu'il y ait déjà une autre adresse (décalage) sur la pile pour identifier la variable qui va recevoir la réponse.

format_output: db "N =  %d", 10, 0 ; newline (10 = 0Ah), null terminator ( 0 )
						; Cette chaîne est utilisée par _printf.
						; _printf s'attend à un paramètre adresse sur la pile. Cette adresse doit être l'adresse d'une chaîne de caractères.
						; À partir de cette chaîne, _printf détermine quoi afficher à l'écran : %d = entier décimal, %u = unsigned, %s = string
						; _printf s'attend à ce qu'il y ait d'autres adresses ou valeurs sur la pile pour identifier ce qui va être affiché. 
						; Il peut y avoir plusieurs %d, %u et %s dans la première chaine. Pour chacun de ces symboles, il devra y avoir un 
						; paramètre de mis sur la pile AVANT que de mettre l'adresse de la première chaîne.

; NASM a ses propres façons de faire pour déclarer des variables. Il y a des différences avec MASM, TASM, YASM et autres assembleurs.
						
N: 			times 4 db 0 ; 32-bits integer = 4 bytes
M: 			times 4 db 0 ; 32-bits integer = 4 bytes


; On ne se sert pas de la section .bss mais je la laisse au cas où ... dans le futur ...
section .bss

; La section .text contient le code.
section .text

_main:

	push ebp						; --> 1 - sauvegarder l'état de la pile et du record d'activation présent (le contenu du ebp est mis sur la pile)
	mov ebp, esp					; Mettre la valeur du "stack pointer" dans le "base pointer".
	push ebx						; --> 2- Sauvegarder ebx et ecx vu qu'on va les utiliser pour nos calculs (le contenu du ecx est mis sur la pile)
	push ecx						; --> 3- (le contenu du ecx est mis sur la pile)
									; Ceci se veut un exemple de sauvegarde de l'état des registres généraux.

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
									; À ce point-ci, vous devriez voir que le "return expression ;" du C++ veut juste dire 
									; - évaluer l'expression
									; - mettre la valeur finale de l'expression dans le EAX
									; - faire un return au sytemème d'exploitation - le programme termine.
	ret

; Note vue sur internet dans un blogue :

; "Also, note that, at least on Windows (using MinGW), printf stomps on EAX (return value), ECX, and EDX, and modifies EFLAGS. 
;  As do all of the standard C functions, that I've used thus far, for that matter."

; Donc, faire attention de sauvegarder et restaurer les registres que vous utilisez.
; Ne pas oublier d'enlever les paramètres que vous passez. (== Faire le ménage.)