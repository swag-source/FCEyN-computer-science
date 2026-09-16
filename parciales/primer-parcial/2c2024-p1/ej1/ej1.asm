extern malloc
section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 4
ITEM_DURABILIDAD EQU 8
ITEM_SIZE EQU 16
global es_indice_ordenado
 


; bool es_indice_ordenado(item_t **inventario, uint16_t *indice, uint16_t tamanio, comparador_t comparador)
; RDI <- **inventario
; RSI <- *indice
; DX <- tamanio
; RCX <- comparador
es_indice_ordenado:
	; prologo
	push rbp
	mov rbp, rsp
	sub rsp, 8 * 6 ; Dejo espacio para mis variables

	push r12
	push r13
	push r14
	push r15

	; Muevo los argumentos a la pila
	mov qword [rbp - 8 * 1], rdi
	mov qword [rbp - 8 * 2], rsi
	mov word [rbp - 8 * 3], dx
	mov qword [rbp - 8 * 4], rcx

	; Limpio los iteradores
	xor r8, r8 ; i = 0
	xor r9, r9 ; j = i + 1
	inc r9
	
	movzx r10, dx
	dec r10w
	
	; Limpio registros no volatiles
	xor rax, rax
	xor r12, r12
	xor r13, r13
	xor r14, r14
	xor r15, r15

	.loop:
		cmp r8w, r10w ; i < n - 1
		jge .ordenado

		mov r12w, word [rsi + r8 * 2] ; indice[i]
		mov r13w, word [rsi + r9 * 2] ; indice[i+1]
		mov r14, [rdi + r12 * 8] ; inventario[indice[i]]
		mov r15, [rdi + r13 * 8] ; inventario[indice[i+1]]

		mov rdi, r14 ; inventario[indice[i]]
		mov rsi, r15 ; inventario[indice[i+1]]

		mov word [rbp - 8 * 5], r10w  
		call rcx
		mov rcx, [rbp - 8 * 4]
		mov r10w, word [rbp - 8 * 5]


		cmp al, 0
		je .no_ordenado


		mov rdi, [rbp - 8 * 1]
		mov rsi, [rbp - 8 * 2]
		inc r8
		inc r9
		jmp .loop

	.no_ordenado:
		xor rax, rax
		jmp .fin

	.ordenado:
		xor rax, rax
		inc rax	

	.fin:
	; epilogo
	pop r15
	pop r14
	pop r13
	pop r12
	add rsp, 8 * 6
	pop rbp
	ret

; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);
; RDI <- item_t **inventario
; RSI <- uint16_t *indice
; DX <- tamanio
global indice_a_inventario
indice_a_inventario:
	; Prologo
	push rbp
	mov rbp, rsp ; alineada
	
	push r12
	push r13
	push r14
	push rdi
	push rsi
	push rdx ; alineada

	; limpio los registros que voy a utilizar
	xor r12, r12
	xor r13, r13


	; calculo: tamanio * sizeof(item_t *)
	mov r12w, dx ; r12w <- tamanio
	xor rdi, rdi
	xor rax, rax
	mov ax, dx ; guardo en ax (tamanio) para multiplicar
	mov r13w, 8 ; sizeof(item_t *)
	mul r13w 
	
	mov di, ax
	call malloc
	; rax = malloc(tamanio * sizeof(item_t));
	pop rdx
	pop rsi
	pop rdi
	add rsp, 8

	; rax <- ptr (tamanio * sizeof(item_t*))
	; rdi <- **inventario
	; rsi <- *indice
	; dx <- tamanio
	xor r10, r10
	xor r11, r11
	xor r12, r12
	xor r13, r13
	mov r11w, dx
	.loop:
		cmp r10, r11
		JE .end_loop

		; r12 <- indice[i]
		mov r12w, word [rsi + r10 * 2] 

		; r13 <- inventario[indice[i]]
		mov r13, [rdi + r12 * 8]

		; resultado[i] = r12
		mov [rax + r10 * 8], r13

		inc r10
		jmp .loop
	
	.end_loop:

	; Epilogo
	sub rsp, 8
	pop r14
	pop r13
	pop r12
	pop rbp

	ret
