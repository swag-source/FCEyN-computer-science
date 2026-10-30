; ** por compatibilidad se omiten tildes **
; ==============================================================================
; TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
; ==============================================================================

%include "print.mac"

global start

extern GDT_DESC
extern IDT_DESC
extern pic_reset
extern pic_enable
extern screen_draw_layout
extern idt_init
extern mmu_init_kernel_dir

%define CS_RING_0_SEL 0x8  
%define DS_RING_0_SEL 0x18 

BITS 16
jmp start

start_rm_msg db     'Iniciando kernel en Modo Real'
start_rm_len equ    $ - start_rm_msg

start_pm_msg db     'Iniciando kernel en Modo Protegido'
start_pm_len equ    $ - start_pm_msg

; Punto de entrada del kernel.
BITS 16
start:
    ; Paro interrupciones
    cli

   ; Cambiar modo de video a 80 X 50
    mov ax, 0003h
    int 10h ; set mode 03h
    xor bx, bx
    mov ax, 1112h
    int 10h ; load 8x8 font

    ; Imprimir mensaje de bienvenida - MODO REAL
    print_text_rm start_rm_msg, start_rm_len, 1, 0, 0

    ; Habilitar A20
    call A20_enable

    ; Cargar la GDT
    lgdt [GDT_DESC]

    ; Setear el bit PE del registro CR0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far Jump
    jmp CS_RING_0_SEL:modo_protegido

BITS 32

modo_protegido:
    ; Establecer selectores de segmentos DS, ES, GS, FS y SS en el segmento de datos de nivel 0
    mov ax, DS_RING_0_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax 
    
    ; Establecer el tope y la base de la pila 
    mov ebp, 0x25000
    mov esp, ebp
    
    ; Imprimir mensaje de bienvenida - MODO PROTEGIDO (Parte 1: Pasaje a modo protegido)
    print_text_pm start_pm_msg, start_pm_len, 1, 2, 0

    ; Inicializar pantalla (Parte 1: Pasaje a modo protegido)
    call screen_draw_layout 

    ; ===================================
    ; ||     (Parte 3: Paginación)     ||
    ; ===================================

    ; COMPLETAR - los defines para la MMU en defines.h
    ; COMPLETAR - las funciones en mmu.c
    ; COMPLETAR - reemplazar la implementacion de la interrupcion 88 (ver comentarios en isr.asm)
    ; COMPLETAR - La rutina de atención del page fault en isr.asm
    
    ; Inicializar el directorio de paginas
    call mmu_init_kernel_dir

    ; COMPLETAR - Cargar directorio de paginas
    mov cr3, eax

    ; Habilitar paginacion (seteo el bit de paging en 1)
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    

    ; ========================
    ; ||  (Parte 4: Tareas) ||
    ; ========================

    ; COMPLETAR - reemplazar la implementacion de la interrupcion 88 (ver comentarios en isr.asm)
    ; COMPLETAR - las funciones en tss.c
    ; COMPLETAR - Inicializar tss

    ; COMPLETAR - Inicializar el scheduler

    ; COMPLETAR - Inicializar las tareas


    ; ===================================
    ; ||   (Parte 2: Interrupciones)   ||
    ; ===================================

    ; Inicializar y cargar la IDT
    call idt_init

    lidt [IDT_DESC]
    
    ; Reiniciar y habilitar el controlador de interrupciones (ver pic.c)    
    call pic_reset
    
    call pic_enable
    
    ; Rutinas de atención de reloj, teclado, e interrupciones 88 y 89 (en isr.asm)

    ; COMPLETAR (Parte 4: Tareas)- Cargar tarea inicial

    ; COMPLETAR - Habilitar interrupciones (!! en etapas posteriores, evaluar si se debe comentar este código !!)
    sti

    ; NOTA: Pueden chequear que las interrupciones funcionen forzando a que se
    ;       dispare alguna excepción (lo más sencillo es usar la instrucción
    ;       `int3`)
   
    ; ========================
    ; ||  (Parte 4: Tareas)  ||
    ; ========================
    
    ; COMPLETAR - Inicializar el directorio de paginas de la tarea de prueba

    ; COMPLETAR - Cargar directorio de paginas de la tarea

    ; COMPLETAR - Restaurar directorio de paginas del kernel

    ; COMPLETAR - Saltar a la primera tarea: Idle

    ; Ciclar infinitamente 
    mov eax, 0xFFFF
    mov ebx, 0xFFFF
    mov ecx, 0xFFFF
    mov edx, 0xFFFF
    jmp $

%include "a20.asm"
