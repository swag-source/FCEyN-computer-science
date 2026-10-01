extern malloc
extern strcpy
extern sleep
extern wakeup
extern create_dir_entry

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio
sleep_name: DB "sleep", 0
wakeup_name: DB "wakeup", 0

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - init_fantastruco_dir
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - summon_fantastruco
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

; void init_fantastruco_dir(fantastruco_t* card);
section .text
; rdi <- fantastruco_t* card
global init_fantastruco_dir
init_fantastruco_dir:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 48
	mov	qword [rbp-40], rdi ; 
	mov	edi, 16
	call	malloc
	mov	qword [rbp-8], rax ; [rbp - 8] <- directory_entry_t **arr
	mov	edi, 24
	call	malloc
	mov	qword [rbp-16], rax ; [rbp - 16] <- directory_entry_t *entry_2
	mov	edi, 24
	call	malloc
	mov	qword [rbp-24], rax ; [rbp - 24] <- directory_entry_t *entry_2
	; strcpy(entry_1->ability_name, "sleep")
	mov	rdi, qword [rbp-16]
	mov	rsi, sleep_name
	call	strcpy
	; entry_1->ability_ptr = &sleep
	mov	rax, qword [rbp-16]
	mov	qword [rax + DIRENTRY_PTR_OFFSET], sleep

	; strcpy(entry_2->ability_name, "wakeup")
	mov	rdi, qword [rbp-24]
	mov	rsi, wakeup_name
	call	strcpy
	; entry_2->ability_ptr = &wakeup
	mov	rax, qword [rbp-24]
	mov	qword [rax + DIRENTRY_PTR_OFFSET], wakeup
	
	mov	rax, qword [rbp-8]
	mov	rdx, qword [rbp-16]
	mov	qword [rax], rdx
	mov	rax, qword [rbp-8]
	lea	rdx, [rax+8]
	mov	rax, qword [rbp-24]
	mov	qword [rdx], rax
	mov	rax, qword [rbp-40]
	mov	rdx, qword [rbp-8]
	mov	qword [rax], rdx
	mov	rax, qword [rbp-40]
	mov	word [rax+8], 2
	add rsp, 48
    pop rbp
	ret

global summon_fantastruco
summon_fantastruco:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	edi, 32
	call	malloc
	mov	qword [rbp-8], rax
	mov	rax, qword [rbp-8]
	mov	rdi, rax
	call	init_fantastruco_dir
	mov	rax, qword [rbp-8]
	mov	qword [rax+16], 0
	mov	rax, qword [rbp-8]
	mov	byte [rax+24], 1
	mov	rax, qword [rbp-8]
    add rsp, 16
    pop rbp
	ret
