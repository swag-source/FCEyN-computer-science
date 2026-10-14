; ** por compatibilidad se omiten tildes **
; ==============================================================================
; System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
; ==============================================================================
;
; Definicion de rutinas de atencion de interrupciones

%include "print.mac"
%define CS_RING_0_SEL    (1 << 3)

%define SHARED_TICK_COUNT 0x1D000
BITS 32

sched_task_offset:     dd 0xFFFFFFFF
sched_task_selector:   dw 0xFFFF

;; PIC
extern pic_finish1

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
ISRE 14 ; comentar esta línea en la parte 3 (paginación)
ISRNE 15
ISRNE 16
ISRE 17
ISRNE 18
ISRNE 19
ISRNE 20

;; Rutina de atención de Page Fault ISRE 14 ; Descomentar esta rutina en la parte 3 (paginación)
;; -------------------------------------------------------------------------- ;;
;global _isr14

;_isr14:
;	add esp, 4 ; error code
;	iret

;; Rutina de atención del RELOJ
;; -------------------------------------------------------------------------- ;;
global _isr32
; COMPLETAR (Parte 2: Interrupciones): La rutina se encuentra escrita parcialmente. Completar la rutina
_isr32:
    pushad
    ; 1. Le decimos al PIC que vamos a atender la interrupción
    ; COMPLETAR
    
    ; 2. Imprimimos el reloj que gira en pantalla
    ; COMPLETAR
    
    ; 3. (Parte 4: Tareas) Realizamos el cambio de tareas en caso de ser necesario
    ; COMPLETAR

    .fin:
    ; 3. Actualizamos las estructuras compartidas ante el tick del reloj
    ; call tasks_tick ; DESCOMENTAR (Parte 4: Tareas)
    ; 4. Actualizamos la "interfaz" del sistema en pantalla
    ; call tasks_screen_update ; DESCOMENTAR (Parte 4: Tareas)
    popad
    iret

;; Rutina de atención del TECLADO
;; -------------------------------------------------------------------------- ;;
global _isr33
; COMPLETAR: Implementar la rutina
_isr33:
    pushad
    ; 1. Le decimos al PIC que vamos a atender la interrupción
    
    ; 2. Leemos la tecla desde el teclado y la procesamos con la funcion process_scancode (Durante Parte 2: Interrupciones) o tasks_input_process (Durante Parte 4: Tareas)
    
    popad
    iret


;; Rutinas de atención de las SYSCALLS
;; -------------------------------------------------------------------------- ;;

global _isr88
; COMPLETAR: Implementar la rutina
; Para la seccion de interrupciones: que modifique el valor de eax por 0x58
; Para las secciones de paginación y tareas: que llame a la funcion task_syscall_draw
_isr88:

  iret


; COMPLETAR: Implementar la rutina
; La rutina debe modificar el valor de eax por 0x62
global _isr98
_isr98:
  
  iret

; PushAD Order
%define offset_EAX 28
%define offset_ECX 24
%define offset_EDX 20
%define offset_EBX 16
%define offset_ESP 12
%define offset_EBP 8
%define offset_ESI 4
%define offset_EDI 0


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
