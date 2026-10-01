extern malloc
extern strcpy

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

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
global publicar
publicar:

    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14    ; Stack desalineado
    push r15    ; Stack alineado

    ; Preservamos los valores iniciales
    mov r12, rdi    ; Mensaje
    mov r13, rsi    ; User (Publicador)

    ; Pedimos memoria para el tuit_t que queremos publicar
    mov rdi, TUIT_SIZE
    call malloc

    ; Ahora en RAX tengo el puntero hacia mi nuevo tuit_t
    mov r14, rax    ; Lo preservo en un no-volátil

    ; Llenamos el tuit de información
    mov word [r14 + TUIT_FAVORITOS_OFFSET], word 0
    mov word [r14 + TUIT_RETUITS_OFFSET], word 0
    mov r10d, dword [r13 + USUARIO_ID_OFFSET]
    mov dword [r14 + TUIT_ID_AUTOR_OFFSET], r10d

    ; Nos falta únicamente COPIAR el mensaje
    lea rdi, [r14 + TUIT_MENSAJE_OFFSET]    ; Explicar qué significa LEA
    mov rsi, r12
    call strcpy

    ; Le colocamos en el feed la nueva publicación al usuario "POSTEADOR"
    mov rdi, r14
    mov rsi, [r13 + USUARIO_FEED_OFFSET]
    call agregar_tuit_al_feed

    ; Solo nos queda agregarle el tuit al feed de cada SEGUIDOR
    xor r15, r15    ; Contador con registro NO volátil para no perder la cuenta entre llamadas externas
    .ciclo:
        cmp r15d, dword [r13 + USUARIO_CANT_SEGUIDORES_OFFSET]
        je .fin

        ; Tomamos la lista de seguidores
        mov r8, [r13 + USUARIO_SEGUIDORES_OFFSET]
        ; Elegimos al i-ésimo seguidor
        mov r9, [r8 + r15 * 8]
        
        mov rdi, r14    ; Tuit
        mov rsi, [r9 + USUARIO_FEED_OFFSET] ; Feed
        call agregar_tuit_al_feed

        inc r15
        jmp .ciclo


    .fin:
    mov rax, r14

    .epilogo:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

global agregar_tuit_al_feed
agregar_tuit_al_feed:

    .prologo:
    push rbp
    mov rbp, rsp
    push r12
    push r13

    ; RDI: tuit_t*
    ; RSI: feed_t*
    ; Preservamos valores iniciales
    mov r12, rdi    ; Tuit
    mov r13, rsi    ; Feed

    ; Creamos la publicación
    mov rdi, PUBLICACION_SIZE
    call malloc

    ; Le asignamos el VALOR (TUIT) a la publicación
    mov [rax + PUBLICACION_VALUE_OFFSET], r12

    ; Nos falta decir que la próxima publicación a esta nueva es la que está primera actualmente
    mov r8, [r13 + FEED_FIRST_OFFSET]

    ; Ahora sí, en R8 tengo la primera publicación actual
    mov [rax + PUBLICACION_NEXT_OFFSET], r8
    mov [r13 + FEED_FIRST_OFFSET], rax

    .epilogo:
    pop r13
    pop r12
    pop rbp
    ret
