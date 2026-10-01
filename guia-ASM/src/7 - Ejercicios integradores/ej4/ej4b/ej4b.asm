extern strcmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 8
DIRENTRY_SIZE EQU 16

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 0
FANTASTRUCO_ARCHETYPE_OFFSET EQU 0
FANTASTRUCO_FACEUP_OFFSET EQU 0
FANTASTRUCO_SIZE EQU 0

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio


section .text
global verificar_arqueotipo
verificar_arqueotipo:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32
	mov	qword [rbp-24], rdi
	mov	qword [rbp-32], rsi
	cmp	qword [rbp-24], 0
	je	.L7
	mov	dword [rbp-4], 0
	jmp	.L4
.L6:
	mov	rax, qword [rbp-24]
	mov	rdx, qword [rax]
	mov	eax, dword [rbp-4]
	cdqe
	sal	rax, 3
	add	rax, rdx
	mov	rax, qword [rax]
	mov	rdx, rax
	mov	rax, qword [rbp-32]
	mov	rsi, rax
	mov	rdi, rdx
	call	strcmp
	cmp rax, 0
	jne	.L5
	mov	rax, qword [rbp-24]
	mov	rdx, qword [rax]
	mov	eax, dword [rbp-4]
	cdqe
	sal	rax, 3
	add	rax, rdx
	mov	rax, qword [rax]
	mov	rax, qword [rax+16]
	mov	qword [rbp-16], rax
	mov	rax, qword [rbp-24]
	mov	rdx, qword [rbp-16]
	mov	rdi, rax
	call	rdx
.L5:
	add	dword [rbp-4], 1
.L4:
	mov	rax, qword [rbp-24]
	movzx	eax, word [rax+8]
	movzx	eax, ax
	cmp	dword [rbp-4], eax
	jl	.L6
	mov	rax, qword [rbp-24]
	mov	rax, qword [rax+16]
	mov	rdx, qword [rbp-32]
	mov	rsi, rdx
	mov	rdi, rax
	call	verificar_arqueotipo
	jmp	.L1
.L7:
	nop
.L1:
	add rsp, 32
	pop rbp
	ret
global invocar_habilidad
invocar_habilidad:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	qword [rbp-40], rdi
	mov	qword [rbp-48], rsi
	mov	rax, qword [rbp-40]
	mov	qword [rbp-16], rax
	mov	dword [rbp-4], 0

	jmp	.L9
.L11:
	mov	rax, qword [rbp-16]

	mov	rdx, qword [rax]
	mov	eax, dword [rbp-4]

	sal	rax, 3
	add	rax, rdx
	mov	rax, qword [rax]
	mov	rdx, rax


	mov	rax, qword [rbp-48]
	mov	rsi, rax
	mov	rdi, rdx
	call	strcmp
	cmp rax, 0
	jne	.L10


	mov	rax, qword [rbp-16]
	mov	rdx, qword [rax]
	mov	eax, dword [rbp-4]
	sal	rax, 3
	add	rax, rdx

	mov	rax, qword [rax]
	mov	rax, qword [rax+16]
	mov	qword [rbp-24], rax

	mov	rax, qword [rbp-16]
	mov	rdx, qword [rbp-24]
	mov	rdi, rax
	call	rdx
.L10:
	add	dword [rbp-4], 1
.L9:
	mov	rax, qword [rbp-16]
	movzx	eax, word [rax+8]
	movzx	eax, ax
	cmp	dword [rbp-4], eax
	jl	.L11
	mov	rax, qword [rbp-16]
	mov	rax, qword [rax+16]
	mov	rdx, qword [rbp-48]
	mov	rsi, rdx
	mov	rdi, rax
	call	verificar_arqueotipo
	add rsp, 48
	pop rbp
	ret
