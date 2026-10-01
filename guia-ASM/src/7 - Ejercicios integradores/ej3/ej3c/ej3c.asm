extern calloc
extern strcmp

;########### SECCION DE DATOS
section .rodata
LC0: db "CLT", 0
LC1: db "RBO", 0
LC2: db "KSC", 0
LC3: db "KDT", 0


;########### SECCION DE TEXTO (PROGRAMA)
section .text
; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

section .text
section .text
global calcular_estadisticas
calcular_estadisticas:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	qword [rbp-24], rdi
	mov	dword [rbp-28], esi
	mov	dword [rbp-32], edx
	mov	esi, ESTADISTICAS_SIZE
	mov	edi, 1
	call	calloc
	mov	qword [rbp-16], rax
	cmp	dword [rbp-32], 0
	je	.L3
	mov	dword [rbp-4], 0
	jmp	.L4
.L12:
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	rax, qword [rax+8]
	mov	eax, dword [rax]
	cmp	dword [rbp-32], eax
	jne	.L5
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC0
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L6
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax], dl
	jmp	.L7
.L6:
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC1
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L8
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+1]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+1], dl
	jmp	.L7
.L8:
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC2
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L9
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+2]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+2], dl
	jmp	.L7
.L9:
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+3]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+3], dl
.L7:
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	movzx	eax, word [rax+4]
	test	ax, ax
	jne	.L10
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+4]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+4], dl
	jmp	.L5
.L10:
	mov	eax, dword [rbp-4]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	movzx	eax, word [rax+4]
	cmp	ax, 1
	jne	.L11
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+5]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+5], dl
	jmp	.L5
.L11:
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+6]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+6], dl
.L5:
	add	dword [rbp-4], 1
.L4:
	mov	eax, dword [rbp-4]
	cmp	eax, dword [rbp-28]
	jl	.L12
	jmp	.L13
.L3:
	mov	dword [rbp-8], 0
	jmp	.L14
.L22:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC0
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L15
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax], dl
	jmp	.L16
.L15:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC1
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L17
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+1]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+1], dl
	jmp	.L16
.L17:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC2
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L16
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+2]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+2], dl
.L16:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	mov	esi, LC3
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L18
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+3]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+3], dl
.L18:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	movzx	eax, word [rax+4]
	test	ax, ax
	jne	.L19
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+4]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+4], dl
	jmp	.L20
.L19:
	mov	eax, dword [rbp-8]
	sal	rax, 4
	mov	rdx, rax
	mov	rax, qword [rbp-24]
	add	rax, rdx
	movzx	eax, word [rax+4]
	cmp	ax, 1
	jne	.L21
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+5]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+5], dl
	jmp	.L20
.L21:
	mov	rax, qword [rbp-16]
	movzx	eax, byte [rax+6]
	lea	edx, [rax+1]
	mov	rax, qword [rbp-16]
	mov	byte [rax+6], dl
.L20:
	add	dword [rbp-8], 1
.L14:
	mov	eax, dword [rbp-8]
	cmp	eax, dword [rbp-28]
	jl	.L22
.L13:
	mov	rax, qword [rbp-16]
	add rsp, 32
	pop rbp
	ret
