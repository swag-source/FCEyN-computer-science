; ** por compatibilidad se omiten tildes **
; ==============================================================================
; System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
;
; Definicion de rutinas de atencion de interrupciones

%include "print.mac"
%define CS_RING_0_SEL    (1 << 3)
%define CS_RING_3_SEL    (2 << 3) | 0x0003
%define DS_RING_3_SEL    (4 << 3) | 0x0003
%define TASK_SIZE 0x30
%define TASK_STACK_BASE  0x08003000
%define TASK_IDLE_CODE   0x08000000



%define SHARED_TICK_COUNT 0x1D000
BITS 32

sched_task_offset:     dd 0xFFFFFFFF
sched_task_selector:   dw 0xFFFF

;; PIC
extern pic_finish1
extern process_scancode

;; Sched
extern sched_next_task
extern kernel_exception
extern page_fault_handler

;; Tasks
extern tasks_tick
extern tasks_screen_update
extern tasks_syscall_draw
extern tasks_input_process
extern tasks
extern current_task

;; Variables
extern idle


;; Definición de MACROS
;; -------------------------------------------------------------------------- ;;

%macro ISRc 1
    push DWORD %1
    ; Stack State:
    ; [ INTERRUPT #] esp
    ; [ ERROR CODE ] esp + 0x04
    ; [ EIP        ] esp + 0x08
    ; [ CS         ] esp + 0x0c
    ; [ EFLAGS     ] esp + 0x10
    ; [ ESP        ] esp + 0x14 (if DPL(cs) == 3)
    ; [ SS         ] esp + 0x18 (if DPL(cs) == 3)

    ; GREGS
    pushad
    ; Check for privilege change before anything else.
    mov edx, [esp + (8*4 + 3*4)]

    ; SREGS
    xor eax, eax
    mov ax, ss
    push eax
    mov ax, gs
    push eax
    mov ax, fs
    push eax
    mov ax, es
    push eax
    mov ax, ds
    push eax
    mov ax, cs
    push eax

    ; CREGS
    mov eax, cr4
    push eax
    mov eax, cr3
    push eax
    mov eax, cr2
    push eax
    mov eax, cr0
    push eax

    cmp edx, CS_RING_0_SEL
    je .ring0_exception

    ; COMPLETAR (opcional) (Parte 4: Tareas):
    ;   Si caemos acá es porque una tarea causó una excepción
    ;   En lugar de frenar el sistema podríamos matar la tarea (o reiniciarla)
    ;   ¿Cómo harían eso?
    call kernel_exception
    add esp, 10*4
    popad

    xchg bx, bx
    jmp $


.ring0_exception:
    call kernel_exception
    add esp, 10*4
    popad

    xchg bx, bx
    jmp $

%endmacro

; ISR that pushes an exception code.
%macro ISRE 1
global _isr%1

_isr%1:
  ISRc %1
%endmacro

; ISR That doesn't push an exception code.
%macro ISRNE 1
global _isr%1

_isr%1:
  push DWORD 0x0
  ISRc %1
%endmacro

;; Rutina de atención de las EXCEPCIONES
;; -------------------------------------------------------------------------- ;;
ISRNE 0
ISRNE 1
ISRNE 2
ISRNE 3
ISRNE 4
ISRNE 5
ISRNE 6
ISRNE 7
ISRE 8
ISRNE 9
ISRE 10
ISRE 11
ISRE 12
ISRE 13
; ISRE 14
ISRNE 15
ISRNE 16
ISRE 17
ISRNE 18
ISRNE 19
ISRNE 20

;; Rutina de atención de Page Fault ISRE 14 ; Descomentar esta rutina en la parte 3 (paginación)
;; -------------------------------------------------------------------------- ;;
global _isr14

_isr14:
	; Prologo
    pushad 
    mov eax, cr2   
    push eax ; Push CR2 as an argument for the page_fault_handler (through stack)
    
    call page_fault_handler
    add esp, 4 ; Restore the stack top value

    ; Verify if the page fault was handled correctly by the handler
    cmp al, 1
    jne .unhandled    

    ; Case handled
    popad
    add esp, 4 ; Restore the stack top value
	iret
    
    ; Case unhandled
.unhandled:
    popad
    ISRc 14

;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
global _isr32
; (Parte 2: Interrupciones): La rutina se encuentra escrita parcialmente.
_isr32:
    ; Prologo
    pushad

    ; 1. Guardo el estado de la tarea que se venía ejecutando
    call save_current_task_context

    ; 2. Le decimos al PIC que vamos a atender la interrupción
    call pic_finish1     

    ; 3. Imprimimos el reloj que gira en pantalla
    call next_clock
    
    ; 4. Actualizamos las estructuras compartidas ante el tick del reloj
    call tasks_tick

    ; 5. Actualizamos la "interfaz" del sistema en pantalla
    call tasks_screen_update

    ; 6. Buscamos la siguiente tarea a ejecutar
    call sched_next_task

    ; 7. Realizamos el cambio a la i-esima tarea
    jmp switch_to_usermode

;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;
global _isr33
_isr33:
    ; Prologo
    pushad
    ; 1. Le decimos al PIC que vamos a atender la interrupción
    call pic_finish1

    ; 2. Leemos la tecla desde el teclado y la procesamos con la funcion process_scancode (Durante Parte 2: Interrupciones) o tasks_input_process (Durante Parte 4: Tareas)
    in al, 0x60
    push eax

    call tasks_input_process
    add esp, 4
    
    ; Epilogo
    popad
    iret


;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;

global _isr88
; Para la seccion de interrupciones: que modifique el valor de eax por 0x58
; Para las secciones de paginación y tareas: que llame a la funcion tasks_syscall_draw
_isr88:
  ; Prologo
  pushad
    
  push eax
  
  call tasks_syscall_draw
  
  add esp, 4

  ; Epilogo
  popad
  iret


; La rutina debe modificar el valor de eax por 0x62
global _isr98
_isr98:
    ; Prologo
    pushad
    mov eax, 0x62
    
    ; Epilogo
    .fin:
    popad
    iret


; PushAD Order
%define offset_USER_SS 48
%define offset_USER_ESP 44 
%define offset_EFLAGS 40
%define offset_CS  36
%define offset_EIP 32
%define offset_EAX 28
%define offset_ECX 24
%define offset_EDX 20
%define offset_EBX 16
%define offset_ESP 12
%define offset_EBP 8
%define offset_ESI 4
%define offset_EDI 0
global save_current_task_context
save_current_task_context:
    ; Busco el indice de la tarea actual
    mov eax, [current_task]
    imul eax, eax, TASK_SIZE
    lea eax, [tasks + eax] ; eax <- &tasks[current_task]

    ; Busco en la pila (por PUSHAD) el estado de los registros
    ; tasks[current_task].eax
    mov ebx, [esp + 4 + offset_EAX]
    mov DWORD [eax + 4], ebx

    ; tasks[i].ebx
    mov ebx, [esp + 4 + offset_EBX]
    mov DWORD [eax + 8], ebx

    ; tasks[i].ecx
    mov ebx, [esp + 4 + offset_ECX]
    mov DWORD [eax + 12], ebx

    ; tasks[i].edx
    mov ebx, [esp + 4 + offset_EDX]
    mov DWORD [eax + 16], ebx

    ; tasks[i].esi
    mov ebx, [esp + 4 + offset_ESI]
    mov DWORD [eax + 20], ebx

    ; tasks[i].edi
    mov ebx, [esp + 4 + offset_EDI]
    mov DWORD [eax + 24], ebx

    ; tasks[i].esp
    mov ebx, [esp + 4 + offset_USER_ESP]
    mov DWORD [eax + 28], ebx

    ; tasks[i].ebp
    mov ebx, [esp + 4 + offset_EBP]
    mov DWORD [eax + 32], ebx

    ; tasks[i].eip
    mov ebx, [esp + 4 + offset_EIP]
    mov DWORD [eax + 36], ebx

    ; tasks[i].eflags
    mov ebx, [esp + 4 + offset_EFLAGS]
    mov DWORD [eax + 40], ebx

    ; tasks[i].cr3
    mov ebx, cr3
    mov DWORD [eax + 44], ebx
    
    ret


; PushAD Order 
%define TASK_OFFSET_EAX 4
%define TASK_OFFSET_EBX 8
%define TASK_OFFSET_ECX 12
%define TASK_OFFSET_EDX 16
%define TASK_OFFSET_ESI 20
%define TASK_OFFSET_EDI 24
%define TASK_OFFSET_ESP 28
%define TASK_OFFSET_EBP 32
%define TASK_OFFSET_EIP 36
%define TASK_OFFSET_EFLAGS 40
%define TASK_OFFSET_CR3  44
global switch_to_usermode
; void switch_to_usermode(void)
switch_to_usermode:
    ; Determinar la siguiente tarea a ejecutar
    mov eax, [current_task]
    imul eax, eax, TASK_SIZE 
    lea ebx, [tasks + eax] ; ebx <- tasks[current_task]

    ; Seteo los registros de segmento para la tarea de nivel 3
    mov ax, DS_RING_3_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Cargo los registros
    mov eax, [ebx + TASK_OFFSET_CR3]
    mov cr3, eax

    mov eax, [ebx + TASK_OFFSET_EAX]
    mov ecx, [ebx + TASK_OFFSET_ECX]
    mov edx, [ebx + TASK_OFFSET_EDX]
    mov esi, [ebx + TASK_OFFSET_ESI]
    mov edi, [ebx + TASK_OFFSET_EDI]
    mov esp, [ebx + TASK_OFFSET_ESP]
    mov ebp, [ebx + TASK_OFFSET_EBP]
    
        
    ; Armo el stack frame para la tarea
    push DWORD DS_RING_3_SEL     ; SS
    push DWORD [ebx + TASK_OFFSET_ESP]   ; ESP
    push DWORD [ebx + TASK_OFFSET_EFLAGS]             ; EFLAGS
    push DWORD CS_RING_3_SEL     ; CS
    push DWORD [ebx + TASK_OFFSET_EIP]    ; EIP    

    mov ebx, [ebx + TASK_OFFSET_EBX]
    iret ; Jump a CS_LEVEL_3:EIP

;; Funciones Auxiliares
;; -------------------------------------------------------------------------- ;;
isrNumber:           dd 0x00000000
isrClock:            db '|/-\'
next_clock:
        pushad
        inc DWORD [isrNumber]
        mov ebx, [isrNumber]
        cmp ebx, 0x4
        jl .ok
                mov DWORD [isrNumber], 0x0
                mov ebx, 0
        .ok:
                add ebx, isrClock
                print_text_pm ebx, 1, 0x0f, 49, 79
                popad
        ret
