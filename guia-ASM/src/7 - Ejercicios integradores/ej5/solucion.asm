; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5

; Marca un OFFSET o SIZE como no completado
; Esto no lo chequea el ABI enforcer, sirve para saber a simple vista qué cosas
; quedaron sin completar :)
NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU 416

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

section .rodata

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db FALSE

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text

global hay_accion_que_toque
; bool hay_accion_que_toque(accion_t *accion, char *nombre)
; rdi <- accion_t *accion
; rsi <- char *nombre
hay_accion_que_toque:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	; [rbp - 24] <- accion_t *accion
	mov	qword [rbp-24], rdi
	; [rbp - 32] <- char* nombre
	mov	qword [rbp-32], rsi
	; cargo en rax el address de la acción
	lea	rax, [rbp-24]
	; lo guardo en la pila para no perderlo luego de llamar a strcmp
	mov	qword [rbp-8], rax
	jmp	.loop1_cond
.loop1:
	; rax <- accion_t *accion
	mov	rax, qword [rbp-8]
	; rax <- accion_t **idx = &accion
	mov	rax, qword [rax]
	mov	rax, qword [rax+accion.destino]
	lea	rdx, [rax+carta.nombre]
	mov	rax, qword [rbp-32]
	; rsi <- (*idx)->destion->nombre
	; rdi <- nombre
	mov	rsi, rax
	mov	rdi, rdx
	call	strcmp
	cmp rax, 0
	jne	.if_end1
	mov	eax, 1
	jmp	.ret
.if_end1:
	mov	rax, qword [rbp-8]
	mov	rax, qword [rax]
	mov	rdx, qword [rax+16]
	mov	rax, qword [rbp-8]
	mov	qword [rax], rdx
.loop1_cond:
	; while((*idx) != NULL)
	mov	rax, qword [rbp-8]
	mov	rax, qword [rax]
	cmp rax, 0
	jne	.loop1
	mov	eax, 0
.ret:
	add rsp, 32
	pop rbp
	ret


global invocar_acciones
invocar_acciones:

global contar_cartas
contar_cartas:
	push	rbp
	mov	rbp, rsp
	mov	qword [rbp-24], rdi
	mov	qword [rbp-32], rsi
	mov	qword [rbp-40], rdx
	mov	rax, qword [rbp-40]
	mov	dword [rax], 0
	mov	rax, qword [rbp-40]
	mov	edx, dword [rax]
	mov	rax, qword [rbp-32]
	mov	dword [rax], edx
	mov	dword [rbp-4], 0
	jmp	.condicion_de_loop1
.loop1:
	mov	dword [rbp-8], 0
	jmp	.loop2_cond
.loop2:
	mov	rdx, qword [rbp-24]
	mov	eax, dword [rbp-8]
	movsx	rsi, eax
	mov	eax, dword [rbp-4]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rsi
	add	rax, 2
	mov	rax, qword [rdx+rax*8]
	cmp rax, 0
	je	.if_end2
	mov	rdx, qword [rbp-24]
	mov	eax, dword [rbp-8]
	movsx	rsi, eax
	mov	eax, dword [rbp-4]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rsi
	add	rax, 2
	mov	rax, qword [rdx+rax*8]
	movzx	eax, byte [rax+16]
	cmp	al, 2
	jne	.if_end1
	mov	rax, qword [rbp-40]
	mov	eax, dword [rax]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-40]
	mov	dword [rax], edx
.if_end1:
	mov	rdx, qword [rbp-24]
	mov	eax, dword [rbp-8]
	movsx	rsi, eax
	mov	eax, dword [rbp-4]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rsi
	add	rax, 2
	mov	rax, qword [rdx+rax*8]
	movzx	eax, byte [rax+16]
	cmp	al, 1
	jne	.if_end2
	mov	rax, qword [rbp-32]
	mov	eax, dword [rax]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-32]
	mov	dword [rax], edx
.if_end2:
	add	dword [rbp-8], 1
.loop2_cond:
	cmp	dword [rbp-8], 9 
	jle	.loop2
	add	dword [rbp-4], 1
.loop1_cond:
	cmp	dword [rbp-4], 4
	jle	.loop1
	pop	rbp
	ret
