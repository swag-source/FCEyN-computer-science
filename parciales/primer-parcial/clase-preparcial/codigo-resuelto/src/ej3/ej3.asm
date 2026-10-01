extern malloc

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140
TUIT_RETUITS_OFFSET EQU 142
TUIT_ID_AUTOR_OFFSET EQU 144
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0;
USUARIO_SEGUIDORES_OFFSET EQU 8; 
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16; 
USUARIO_SEGUIDOS_OFFSET EQU 24; 
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32; 
USUARIO_BLOQUEADOS_OFFSET EQU 40; 
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48; 
USUARIO_ID_OFFSET EQU 52; 
USUARIO_SIZE EQU 56

; tuit_t **trendingTopic(usuario_t *usuario, uint8_t (*esTuitSobresaliente)(tuit_t *));
global trendingTopic 
trendingTopic:
    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15    ; Stack alineado...
    push rbx
    sub rsp, 8

    ; Preservamos valores originales
    mov r12, rdi    ; User
    mov r13, rsi    ; Función "esTuitSobresaliente"

    mov rdi, [r12 + FEED_FIRST_OFFSET]  ; Feed
    mov esi, dword [r12 + USUARIO_ID_OFFSET]    ; User ID
    mov rdx, r13    ; Función "esTuitSobresaliente"
    call cuantos_tuits_trending_topic

    cmp eax, dword 0
    jne .memoria
    xor rax, rax    ; Devolvemos NULL
    jmp .epilogo

    .memoria:
    ; Pedimos memoria para tuit_t**
    inc rax
    imul rax, 8
    mov rdi, rax
    call malloc

    ; Ahora, en RAX tengo guardado el puntero tuit_t** que tengo que devolver
    mov r14, rax    ; tuits
    xor r15, r15    ; index
    mov r9, [r12 + USUARIO_FEED_OFFSET]
    mov rbx, [r9 + FEED_FIRST_OFFSET]   ; actual
    mov r12d, dword [r12 + USUARIO_ID_OFFSET]

    .ciclo:
        cmp rbx, 0
        je .fin

        mov rdi, [rbx + PUBLICACION_VALUE_OFFSET]   ; tuit

        mov r8d, dword [rdi + TUIT_ID_AUTOR_OFFSET]
        cmp r8d, r12d
        jne .siguiente

        ; Si llegamos hasta aquí, es porque el tuit es del usuario
        call r13
        cmp al, byte 1
        jne .siguiente

        ; Si llegamos hasta aquí, es porque el tuit es TT
        mov rdi, [rbx + PUBLICACION_VALUE_OFFSET]   ; tuit
        mov [r14 + r15 * 8], rdi
        inc r15

        .siguiente:
        mov rbx, [rbx + PUBLICACION_NEXT_OFFSET]
        jmp .ciclo
    
    .fin:
    mov qword [r14 + r15 * 8], qword 0
    mov rax, r14

    .epilogo:
    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; uint32_t cuantos_tuits_trending_topic(feed_t* feed, uint32_t user_id, uint8_t (*esTuitSobresaliente)(tuit_t *))
global cuantos_tuits_trending_topic
cuantos_tuits_trending_topic:
    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15    ; Stack alineado

    ; Preservamos valores originales
    mov r12, [rdi + FEED_FIRST_OFFSET]    ; actual
    mov r13, rsi                          ; user_id
    mov r14, rdx                          ; esTuitSobresaliente

    xor r15, r15    ; Contador
    .ciclo:
        cmp r12, 0
        je .fin

        mov rdi, [r12 + PUBLICACION_VALUE_OFFSET]   ; tuit
        
        mov r8d, dword [rdi + TUIT_ID_AUTOR_OFFSET]
        mov r9d, r13d
        cmp r8d, r9d
        jne .proximo

        ; Solo nos queda ver si es sobresaliente
        call r14
        cmp al, byte 0
        je .proximo

        inc r15

        .proximo:
        mov r12, [r12 + PUBLICACION_NEXT_OFFSET]
        jmp .ciclo

    .fin:
    mov rax, r15

    .epilogo:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
