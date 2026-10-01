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
;   - optimizar
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_1C_HECHO
EJERCICIO_1C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

global optimizar
; void optimizar(mapa_t mapa, attackunit_t *compartida, uint32_t (*fun_hash)(attackunit_t *))
; rdi <- mapa
; rsi <- compartida
; rdx <- fun_hash
optimizar:
	; Prologo
	push rbp
	mov rbp ,rsp
	sub rsp, 32

	; Guardo las variables en la pila para no perderlas en los llamados
	mov qword [rbp - 8], rdi
	mov qword [rbp - 16], rsi
	mov qword [rbp - 24], rdx

	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8

	xor r15, r15
	xor r14, r14
	xor r13, r13
	xor r12, r12
	xor rbx, rbx
	.loop:
		cmp r15, 0xFE01 ; N * M
		je .end_loop

		; Traigo mapa[ij] para checkear si es null
		mov r14, qword [rbp - 8]
		mov r13, qword [r14 + r15 * 8] ; r13 <- mapa[ij]
		cmp r13, 0
		je .inc

		; fun_hash((mapa[ij])) == fun_hash(compartida)
		; Calculo fun_hash(mapa[ij])
		mov rdi, r13
		call [rbp - 24]
		
		; eax <- fun_hash(mapa[ij])
		
		mov r12d, eax ; r12d <- fun_hash(mapa[ij])

		; Calculo fun_hash(compartida)
		mov rdi, qword [rbp - 16]
		call [rbp - 24]

		; eax <- fun_hash(compartida)

		mov ebx, eax ; ebx <- fun_hash(compartida)
		cmp r12d, ebx
		jne .inc

		; Calculo
		; mapa[i][j]->references--;
		; mapa[i][j] = compartida;
        ; compartida->references++;

		xor r12, r12
		xor rbx, rbx

		; mapa[ij]->references--
		mov r12b, [r13 + ATTACKUNIT_REFERENCES]
		dec r12b
		mov byte [r13 + ATTACKUNIT_REFERENCES], byte r12b

		; compartida->references++
		xor r12, r12

		mov rdi, [rbp - 16]
		mov r12b, byte [rdi + ATTACKUNIT_REFERENCES]
		inc r12b
		mov byte [rdi + ATTACKUNIT_REFERENCES], r12b

		; mapa[ij] = compartida
		mov r12, [rbp - 16]
		mov qword [r13], r12

	.inc:
		inc r15
		jmp .loop

	.end_loop:

	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	add rsp, 32
	pop rbp 
	ret

global contarCombustibleAsignado
	; rdi = r/m64 = mapa_t           mapa
	; rsi = r/m64 = uint16_t*        fun_combustible(char*)
contarCombustibleAsignado:
	; prologo
	push rbp
	mov rbp, rsp
	sub rsp, 24

	mov qword [rbp - 8], rdi
	mov qword [rbp - 16], rsi

	push r15
	push r14
	push r13
	push r12
	push r11

	xor r15, r15
	xor r14, r14
	xor r13, r13

	.loop:
		cmp r13w, 0xFE01
		je .end_loop

		mov r14, [rbp - 8]
		mov r15, [r14 + r13 * 8]

		; mapa[i][j] == 0
		cmp r15, 0 
		je .inc

		




	
	.inc:
		inc r13w
		jmp .loop


	.end_loop:



	; epilogo
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15
	pop rbp
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret