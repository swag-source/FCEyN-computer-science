extern free

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

; void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear);
global bloquearUsuario 
bloquearUsuario:
    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13    ; Stack alineado

    ; Preservo los valores iniciales
    mov r12, rdi    ; usuario
    mov r13, rsi    ; usuarioABloquear

    xor r8, r8
    mov r8d, dword [r12 + USUARIO_CANT_BLOQUEADOS_OFFSET]   ; Cantidad de usuarios bloqueados
    mov r9, [r12 + USUARIO_BLOQUEADOS_OFFSET] ; usuario->bloqueados
    mov [r9 + r8 * 8], r13

    inc dword [r12 + USUARIO_CANT_BLOQUEADOS_OFFSET]   ; usuario->cantBloqueados++

    ; Solo nos queda llamar a la función auxiliar con el feed de cada usuario y el usuario a bloquar/bloqueador
    mov rdi, [r12 + USUARIO_FEED_OFFSET]
    mov rsi, r13
    call eliminar_publicaciones_del_feed_del_usuario

    mov rdi, [r13 + USUARIO_FEED_OFFSET]
    mov rsi, r12
    call eliminar_publicaciones_del_feed_del_usuario

    .epilogo:
    pop r13
    pop r12
    pop rbp
    ret

global eliminar_publicaciones_del_feed_del_usuario
eliminar_publicaciones_del_feed_del_usuario:
    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15    ; Stack alineado
    push rbx    ; Stack desalineado...

    ; Preservamos los valores originales
    mov r12, rdi    ; Feed
    mov r13, rsi    ; Usuario

    mov r15, [r12 + FEED_FIRST_OFFSET]  ; actual
    xor rbx, rbx    ; previa
    xor r14, r14    ; encontre_nuevo_first

    .ciclo:
        cmp r15, 0
        je .fin

        mov r8, [r15 + PUBLICACION_NEXT_OFFSET] ; siguiente

        mov r9, [r15 + PUBLICACION_VALUE_OFFSET]    ; tuit_t
        mov r9d, dword [r9 + TUIT_ID_AUTOR_OFFSET]  ; id_autor
        mov r10d, dword [r13 + USUARIO_ID_OFFSET]   ; usuario->id

        ; Comparamos para ver si la publicación es del usuario o no
        cmp r9d, r10d
        jne .noEliminar
        jmp .eliminar

        .noEliminar:
            cmp r14b, byte 0
            jne .nuevaPrevia

            mov [r12 + FEED_FIRST_OFFSET], r15  ; feed->first = actual
            mov r14b, byte 1

            .nuevaPrevia:
            mov rbx, r15
            jmp .siguiente

        .eliminar:
            cmp rbx, 0
            je .noHayPrevia

            mov [rbx + PUBLICACION_NEXT_OFFSET], r8

            .noHayPrevia:
            push r8
            mov rdi, r15
            call free
            pop r8
            jmp .siguiente
        
        .siguiente:
        mov r15, r8 ; actual = siguiente
        jmp .ciclo

    .fin:
    ; Tenemos que ver si encontramos una publicación FIRST o no
    cmp r14b, byte 0
    jne .epilogo

    ; Sin feed
    mov qword [r12 + FEED_FIRST_OFFSET], qword 0

    .epilogo:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret