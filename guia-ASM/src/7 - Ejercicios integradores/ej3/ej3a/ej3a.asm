extern calloc
;########### SECCION DE DATOS
section .data

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

; int contar_casos_por_nivel(caso_t *arreglo_casos, int largo, int nivel)
; rdi <- *arreglo_caso
; edi <- largo
; edx <- nivel
global contar_casos_por_nivel
contar_casos_por_nivel:
    ; Prologo
    push rbp
    mov rbp, rsp

    xor rax, rax
    xor r8, r8
    .loop:
        cmp r8d, esi ; i == largo?
        je .end_loop
        
        imul r11, r8, CASO_SIZE ; r11 <- i * CASO_SIZE
        mov r9, qword [rdi + r11 + CASO_USUARIO_OFFSET] ; r9 <- caso_t arreglo_casos[i].usuario
        mov r10d, dword [r9 + USUARIO_NIVEL_OFFSET] ; r10d <- uint32_t arreglo_casos[i].usuario->nivel

        cmp r10d, edx
        jne .inc ; arreglo_casos[i].usuario->nivel != nivel?

        inc rax

    .inc:
        inc r8d
        jmp .loop

    .end_loop:
    ; Epilogo
    pop rbp
    ret


;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
; rdi <- caso_t* arreglo_casos
; esi <- int largo
global segmentar_casos
segmentar_casos:
    ; Prologo
    push rbp
    mov rbp, rsp

    sub rsp, 64
    mov qword [rbp - 24], rdi
    mov dword [rbp - 32], esi


; Seccion 1:
;    int n_0 = contar_casos_por_nivel(arreglo_casos, largo, 0); // Devuelve cuantos casos en el arreglo de casos son de tipo 0
;    int n_1 = contar_casos_por_nivel(arreglo_casos, largo, 1); // Devuelve cuantos casos en el arreglo de casos son de tipo 1
;    int n_2 = contar_casos_por_nivel(arreglo_casos, largo, 2); // Devuelve cuantos casos en el arreglo de casos son de tipo 2

    ; rdi <- caso_t* arreglo_casos
    ; esi <- int largo
    ; edx <- int nivel
    mov edx, 0
    call contar_casos_por_nivel
    mov dword [rbp - 40], eax ; [rbp - 40] <- n0


    mov rdi, qword [rbp - 24]
    mov esi, dword [rbp - 32]
    mov edx, 1
    call contar_casos_por_nivel
    mov dword [rbp - 48], eax ; [rbp - 48] <- n1


    mov rdi, qword [rbp - 24]
    mov esi, dword [rbp - 32]
    mov edx, 2
    call contar_casos_por_nivel
    mov dword [rbp - 56], eax ; [rbp - 56] <- n2


; Seccion 2:
;   segmentacion_t *segmentado = calloc(3, sizeof(caso_t *));

    mov rdi, 3
    mov rsi, 8              ; sizeof(caso_t*)
    call calloc
    mov [rbp - 64], rax


; Seccion 3:
;    caso_t *casos_0 = (n_0 == 0) ? NULL : calloc(n_0, sizeof(caso_t));
;    caso_t *casos_1 = (n_1 == 0) ? NULL : calloc(n_1, sizeof(caso_t));
;    caso_t *casos_2 = (n_2 == 0) ? NULL : calloc(n_2, sizeof(caso_t));
    ; cada bloque: leer el contador, poner NULL (8 bytes), y solo pisar si n != 0
    mov edi, dword [rbp - 40]       ; edi <- n_0
    mov qword [rbp - 40], 0         ; casos_0 = NULL
    test edi, edi
    jz .skip_0
    mov rsi, CASO_SIZE
    call calloc
    mov qword [rbp - 40], rax       ; [rbp - 40] <- caso_t *casos_0
.skip_0:

    mov edi, dword [rbp - 48]       ; edi <- n_1
    mov qword [rbp - 48], 0         ; casos_1 = NULL
    test edi, edi
    jz .skip_1
    mov rsi, CASO_SIZE
    call calloc
    mov qword [rbp - 48], rax       ; [rbp - 48] <- caso_t *casos_1
.skip_1:

    mov edi, dword [rbp - 56]       ; edi <- n_2
    mov qword [rbp - 56], 0         ; casos_2 = NULL
    test edi, edi
    jz .skip_2
    mov rsi, CASO_SIZE
    call calloc
    mov qword [rbp - 56], rax       ; [rbp - 56] <- caso_t *casos_2
.skip_2:

.loop_init:
; Seccion 3
;    segmentado->casos_nivel_0 = casos_0;
;    segmentado->casos_nivel_1 = casos_1;
;    segmentado->casos_nivel_2 = casos_2;
    mov rdi, qword [rbp - 64]
    lea r8, qword [rdi + SEGMENTACION_CASOS0_OFFSET]
    mov r9, qword [rbp - 40]
    mov qword [r8], r9

    lea r8, qword [rdi + SEGMENTACION_CASOS1_OFFSET]
    mov r9, qword [rbp - 48]
    mov qword [r8], r9

    lea r8, qword [rdi + SEGMENTACION_CASOS2_OFFSET]
    mov r9, qword [rbp - 56]
    mov qword [r8], r9


; Seccion 4
;    uint32_t i_0 = 0;
;    uint32_t i_1 = 0;
;    uint32_t i_2 = 0;
    ; r13/r14/r15 son no volatiles: hay que preservarlos.
    ; Se pushean despues del 'sub rsp, 64', asi no pisan los slots [rbp-24..rbp-64].
    ; No hay ningun 'call' de aca en adelante, asi que el desalineo de 8 no molesta.
    push r13
    push r14
    push r15

    xor r15, r15 ; i_2
    xor r14, r14 ; i_1
    xor r13, r13 ; i_0
    xor r9, r9 ; largo
    xor r8, r8 ; i

    mov r9d, dword [rbp - 32] ; r9d <- largo

    .loop:
        cmp r8d, r9d
        je .end

        imul r11, r8, CASO_SIZE
        add r11, qword [rbp - 24] ; r11 <- &arreglo_casos[i]
        mov r10, qword [r11 + CASO_USUARIO_OFFSET] ; r10 <- arreglo_casos[i].usuario
        mov r10d, dword [r10 + USUARIO_NIVEL_OFFSET] ; r10d <- arreglo_casos[i].usuario->nivel

        ; if (arreglo_casos[i].usuario->nivel == 0)
        cmp r10d, 0
        je .nivel_0

        ; if (arreglo_casos[i].usuario->nivel == 1)
        cmp r10d, 1
        je .nivel_1

        ; if (arreglo_casos[i].usuario->nivel == 2)
        cmp r10d, 2
        je .nivel_2

        jmp .inc ; nivel > 2: se ignora, igual que en el C

    ; cada rama calcula rdi <- &casos_N[i_N] y cae en .copiar
    .nivel_0:
        mov rdi, qword [rbp - 40] ; rdi <- casos_0
        imul rsi, r13, CASO_SIZE  ; rsi <- i_0 * CASO_SIZE
        add rdi, rsi              ; rdi <- &casos_0[i_0]
        inc r13
        jmp .copiar

    .nivel_1:
        mov rdi, qword [rbp - 48] ; rdi <- casos_1
        imul rsi, r14, CASO_SIZE  ; rsi <- i_1 * CASO_SIZE
        add rdi, rsi              ; rdi <- &casos_1[i_1]
        inc r14
        jmp .copiar

    .nivel_2:
        mov rdi, qword [rbp - 56] ; rdi <- casos_2
        imul rsi, r15, CASO_SIZE  ; rsi <- i_2 * CASO_SIZE
        add rdi, rsi              ; rdi <- &casos_2[i_2]
        inc r15

    .copiar:
        ; *rdi = *r11 : copia de CASO_SIZE (16) bytes, de a qword
        mov rax, qword [r11]
        mov qword [rdi], rax
        mov rax, qword [r11 + 8]
        mov qword [rdi + 8], rax

    .inc:
        inc r8d
        jmp .loop


    .end:
    ; Epilogo
    mov rax, qword [rbp - 64] ; rax <- segmentado (valor de retorno)
    pop r15
    pop r14
    pop r13
    add rsp, 64
    pop rbp
ret