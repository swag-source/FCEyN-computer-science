extern malloc
extern free
extern fprintf

section .data
	db 0x00

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **
; Debe retornar:
; 0 si son iguales
; 1 si a < b
;-1 si a > b

; int32_t strCmp(char* a, char* b)
; RDI <- char* a
; RSI <- char* b
strCmp:
	push RBP
	mov RBP, RSP
	push rdi ; desalineada 
	push rsi ; alineada

	; calculo max(|a|, |b|)
	call strLen
	; eax <- |a|
	
	pop rsi ; rsi <- char* b
	pop rdi ; rdi <- char* a

	; necesito calcular |b|
	push rax     ; guardo |a|, desalineada
	push rdi     ; guardo a, alineada
	push rsi
	sub rsp, 8 ; croto
	mov rdi, rsi ; rdi <- b
	call strLen

	; eax <- |b|
	add rsp, 8
	pop rsi 
	pop rdi      ; restauro a
	pop r10      ; r10 <- |a|

	; r10 = min(|a|, |b|)
	cmp r10d, eax ; |a| == |b|?
	jge .b_lte_a ; |a| >= |b| => r10 = |b|
	mov r10d, eax ; |a| < |b| => r10 = |a|	
	
	.b_lte_a:
	push r11
	push r12

	xor rax, rax ; res = 0
	xor r9, r9 ; i = 0
	xor r11, r11 ; a[i]
	xor r12, r12 ; b[i]

	.ciclo:
		cmp r9, r10; i = n
		je .done

		mov r11b, byte [RDI + r9] ; BL <- byte a[i]
		mov r12b, byte [RSI + r9] ; DL <- byte b[i]

		cmp r11b, r12b
		je .is_equal ; a[i] == b[i]
		jg .a_gt_b ; a[i] > b[i]
		jl .a_lt_b ; a[i] < b[i]

		inc r9
		jmp .ciclo

	; a = b => eax = 0
	.is_equal:
		inc r9
		jmp .ciclo

	; a > b => eax == -1
	.a_gt_b:
		mov rax, -1;
		jmp .done

	; a < b => eax == 1
	.a_lt_b:
		mov rax, 1

	.done:

	pop r12
	pop r11
	pop RBP
	ret

; char* strClone(char* a)
; rdi <- char* a
strClone:
	push rbp
	mov rbp, rsp
	sub rsp, 8
	push rdi ; alineada

	call strLen
	; eax <- len(a)

	sub rsp, 8
	push rax ; alineada

	inc rax ; len(a) + 1
	mov rdi, rax ; rdi <- len(a) + 1
	call malloc
	; rax <- malloc(len(a) + 1)

	mov r8, rax ; r8 <- malloc(len(a) + 1)
	pop rax ; rax <- len(a)
	add rsp, 8
	pop rdi ; rdi <- a
	xor r9, r9 ; i = 0

	; rax <- len(a)
	; rdi <- char* a
	; r8 <- char* malloc(len(a) + 1)
	; r9 <- i = 0
	.ciclo:
	 	cmp r9b, al
	 	je .done

	 	mov r10b, byte [rdi + r9] ; r10b <- a[i]

		mov [r8 + r9], r10b ; cpy_a[i] <- a[i]

		inc r9
		jmp .ciclo

	
	.done:
	mov [r8 + r9], byte 0 ; cpy_a[i] <- '\0'
	mov rax, r8

	; epilogo
	add rsp, 8
	pop rbp	
	ret

; void strDelete(char* a)
; rdi <- char* a
strDelete:
	; prologo
	push rbp
	mov rbp, rsp ; alineada

	call free

	;epilogo
	pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
; rdi <- char* a
; rsi <- FILE* pFile
strPrint:
	
	
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp, rsp
	
	xor eax, eax ; res = 0
	xor r8, r8 ; a[i] = 0

	.ciclo:
		mov r8b, byte [rdi + rax]

		; a[i] == '\0'
		cmp r8b, 0
		je .done

		; i++
		inc eax
		jmp .ciclo

	.done:
	pop rbp
	ret


