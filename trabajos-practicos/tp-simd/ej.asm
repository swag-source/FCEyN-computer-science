DEFAULT REL

TRUE  EQU 1
FALSE EQU 0

SINCOS_SIN_OFF EQU 0
SINCOS_COS_OFF EQU 4
SINCOS_SZ      EQU 8

section .rodata
global ej_1_hecho
global ej_2_hecho
global ej_3_hecho
global ej_4_hecho
ej_1_hecho: db TRUE 
ej_2_hecho: db TRUE
ej_3_hecho: db TRUE
ej_4_hecho: db TRUE

ALIGN 16
espacios:
	times 16 db ' '
ceros:
	times 16 db '0'
unos:
    times 16 db 0xFF
clear_upper_six_bytes: 
    db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
ten_whitespaces:
    db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
pesos_n0: 
    db 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 0, 0, 0, 0, 0, 0
pesos_n1: 
    dw 100, 1, 100, 1, 1, 0, 0, 0
pesos_n2:
    dw 10000, 1, 1, 0, 0, 0, 0, 0
; ... y otra data que les resulte útil para resolver los ejercicios

section .text

global ej1_sample
; void ej1_sample(size_t buf_len, int16_t buf[buf_len],
;                 size_t freq_a_len, int16_t freq_a[freq_a_len], size_t a_start,
;                 size_t freq_b_len, int16_t freq_b[freq_b_len], size_t b_start);
;
; RDI <- buf_len
; RSI <- buf
; RDX <- freq_a_len
; RCX <- freq_a  
; R8 <- a_start   
; R9 <- freq_b_len
; [RBP + 16] <- freq_b    
; [RBP + 24] <- b_start   
ej1_sample:
	; Prologo
    push rbp
    mov rbp, rsp
    push r11
    push r12
    push r13
    sub rsp, 8
    xor r10, r10 ; i <- 0
    xor rax, rax
    mov r11, r8 ; r11 <- a_start
    mov r12, [rbp+24] ; r12 <- b_start
    mov r13, [rbp+16] ; r13 <- freq_b
    jmp .guarda
	.loop:
        pxor xmm0, xmm0
        pxor xmm1, xmm1
        movdqu xmm0, [rcx + r11 * 2]
        movdqu xmm1, [r13 + r12 * 2]
        paddw xmm0, xmm1 ; <- xmm0 = | (freq_a[0] + freq_b[0]) | ... | (freq_a[7] + freq_b[7]) |
        movdqa xmm2, xmm0
        psrlw xmm2, 15   ; xmm2 = | 1 | 0 | ... | (1 donde la suma es negativa)
        paddw xmm0, xmm2
        psraw xmm0, 1
        movdqu [rsi + r10 * 2], xmm0 ; buf[i] = | (freq_a[0] + freq_b[0]) / 2 | ... | (freq_a[7] + freq_b[7]) / 2 | 
        add r10, 8  ; i += 8
        add r11, 8  ; r11 += 8
        cmp r11, rdx
        cmovae r11, rax
        add r12, 8  ; r12 += 8
        cmp r12, r9
        cmovae r12, rax
    .guarda:
        cmp r10, rdi 
        jl .loop
    .fin:
    ; Epilogo
    add rsp, 8
    pop r13
    pop r12
    pop r11
    pop rbp
    ret

global ej2_detect
; float ej2_detect(size_t size, int16_t signal[size], sincos_t freq[size]);
;
; RDI <- size
; RSI <- signal
; RDX <- freq
ej2_detect:
	; Prologo
    push rbp
    mov rbp, rsp
    xor r10, r10
    pxor xmm10, xmm10
    jmp .guarda
    .loop:
        ; xmm0 <- | sen[i] | cos[i] | sen[i+1] | cos[i+1] | (cada elemento es de 4 bytes)
        movups xmm0, [rdx + r10 * 8]
        movd xmm1, [rsi + r10 * 2] 
        pmovsxwd xmm1, xmm1 
        cvtdq2ps xmm1, xmm1 
        pshufd xmm1, xmm1, 0x50; xmm1 <- | float(int[i]) | float(int[i]) | float(int[i+1]) | float(int[i+1]) | 
        mulps xmm0, xmm1 ; xmm2 <- | sen[i] * float(int[i]) | cos[i] * float(int[i]) | sen[i+1] * float(int[i+1]) | cos[i+1] * float(int[i+1]) |
        addps xmm10, xmm0 ; acc+= | im[i] | re[i] | im[i+1] | re[i+1] |
        add r10, 2 ; i++
    .guarda:
        cmp r10, rdi
        jl .loop
    .fin:
        movhlps xmm1, xmm10 
        addps xmm10, xmm1 
        mulps xmm10, xmm10 ; | im[i]² | re[i]² | im[i+1]² | re[i+1]² |
        haddps xmm10, xmm10 ; | im[i]² + re[i]² | im[i+1]² + re[i+1]² | im[i]² + re[i]² | im[i+1]² + re[i+1]² |
        sqrtps xmm10, xmm10 ; | sqrt(im[i]² + re[i]²) | sqrt(im[i+1]² + re[i+1]²) | sqrt(im[i]² + re[i]²) | sqrt(im[i+1]² + re[i+1]²) |  
        addps xmm10, xmm10 ; | 2 * sqrt(im[i]² + re[i]²) | 2 * sqrt(im[i+1]² + re[i+1]²) | 2 * sqrt(im[i]² + re[i]²) | 2 * sqrt(im[i+1]² + re[i+1]²) | 
        cvtsi2ss xmm5, rdi
        divss xmm10, xmm5 ; ; | 2 * sqrt(im[i]² + re[i]²) / size | 2 * sqrt(im[i+1]² + re[i+1]²) / size | 2 * sqrt(im[i]² + re[i]²) / size | 2 * sqrt(im[i+1]² + re[i+1]²) / size | 
        movups xmm0, xmm10
    ; Epilogo
        pop rbp
        ret

global ej3_remove_duplicates
; void ej3_remove_duplicates(size_t size, char detected[size], char output[]);
;
; RDI <- size
; RSI <- signal
; RDX <- output 
ej3_remove_duplicates:
	; Prologo
    push rbp
    mov rbp, rsp
    xor r10, r10 ; int i
    xor r9, r9 ; int out_i
    xor r8, r8 ; c = ' ' 
    mov r8b, 0x20
    jmp .guarda
    .loop:
        ; Extiendo s0 a 16 bytes
        movdqu xmm0, [rsi + r10] ; xmm0 <- | s[0] | s[1] | ... | s[15] |
        vpbroadcastb xmm1, xmm0  ; xmm1 <- | s[0] | s[0] | ... | s[0|     
        ; S && W == 1 <=> ∀i in {0,...,15} Si = Wi 
        pcmpeqb xmm1, xmm0
        pmovmskb eax, xmm1 ; Muevo la comparación de cada byte a un registro de 16
        cmp ax, 0xFFFF
        ; If (!all_the_same) 
        jne .continue_not_equal
        ; If(detected[i] == c)
        cmp byte [rsi + r10], r8b
        je .continue_not_equal
        ; c = detected[i]
        mov r8b, byte [rsi + r10]
        ; if (c == ' ') continue
        cmp r8b, 0x20
        je .continue_not_equal
        ; output[out_i] = detected[i]
        mov al, byte [rsi + r10]
        mov byte [rdx + r9], al
        ; out_i++
        inc r9w
    .continue_equal:
        add r10w, 16
        jmp .guarda
    .continue_not_equal:
        ; i++
        add r10w, 16
    .guarda:
        cmp r10w, di
        jb .loop
    .fin:  
    ; Epilogo
    pop rbp
    ret

global ej4_get_numbers
; void ej4_get_numbers(size_t size, char numbers[10 * (size - 1) + 16], size_t output[size]);
;
; RDI <- size
; RSI <- signal 
; RDX <- output 
ej4_get_numbers:
	; Prologo
    push rbp
    mov rbp, rsp
    
    xor r8, r8 ; size_t out_i = 0
    xor r9, r9
    xor r10, r10
   
    ; Pusheo rdx para no perder el valor luego de multiplicar
    push rdx
    ; Calculo n = 10 * size
    mov rax, rdi ; rax <- size
    mov r9, 10 ; 
    mul r9
    
    mov rdi, rax ; n = 10 * size
    ; Popeo para que vuelva todo a la normalidad
    pop rdx
    jmp .guarda
    .loop:
        movdqu xmm0, [rsi + r10]
        movdqu xmm1, xmm0
        pcmpeqb xmm1, [espacios] 
        psubb xmm0, [ceros]
        pandn xmm1, xmm0
        pand xmm1, [clear_upper_six_bytes]
        
        pmaddubsw xmm1, [pesos_n0]
        ; xmm1 (words) = | d0d1 | d2d3 | d4d5 | d6d7 | d8d9 | 0 | 0 | 0 |
        pmaddwd   xmm1, [pesos_n1]
        ; xmm1 (dwords) = | d0..d3 | d4..d7 | d8d9 | 0 |
        packusdw  xmm1, xmm1
        ; xmm1 (words) = | r0 | r1 | r2 | 0 | r0 | r1 | r2 | 0 |
        pmaddwd   xmm1, [pesos_n2]
        ; xmm1 (dwords) = | d0..d7 | d8d9 | 0 | 0 |
        movd      eax, xmm1
        pextrd    ecx, xmm1, 1
        imul      rax, rax, 100
        add       rax, rcx
        mov [rdx + r8*8], rax
        inc r8 ; out_i++
        add r10, 10 ; i += 10
    .guarda:
        cmp r10, rdi
        jb .loop

    ; Epilogo
    pop rbp
    ret
