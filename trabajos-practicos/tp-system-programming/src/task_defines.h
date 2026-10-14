#ifndef __TASK_DEFINES_H__
#define __TASK_DEFINES_H__

/* GDT */
#define GDT_IDX_TASK_INITIAL         11

/* Direcciones fisicas de codigos */
/* -------------------------------------------------------------------------- */
/* En estas direcciones estan los códigos de todas las tareas. De aqui se
 * copiaran al destino indicado por TASK_<X>_CODE_START.
 */
#define USER_TASK_SIZE (PAGE_SIZE * 2)

#define TASK_A_CODE_START (0x00018000)
#define TASK_B_CODE_START (0x0001A000)
#define TASK_IDLE_CODE_START   (0x0001C000)

/* EFLAGS */

#define EFLAGS_IF (1 << 9)

/* Constantes Generales */

#define MAX_TASKS (1 /* Idle */ + 3 /* Tipo A */ + 1 /* Tipo B */)

/* Interfaz gráfica del sistema */
/* -------------------------------------------------------------------------- */
#define TASK_VIEWPORT_WIDTH 38
#define TASK_VIEWPORT_HEIGHT 23

/**
 * Estados posibles de una tarea en el scheduler:
 * - `TASK_SLOT_FREE`: No existe esa tarea
 * - `TASK_RUNNABLE`: La tarea se puede ejecutar
 * - `TASK_PAUSED`: La tarea se registró al scheduler pero está pausada
 */
typedef enum {
  TASK_SLOT_FREE,
  TASK_RUNNABLE,
  TASK_PAUSED
} task_state_t;

typedef struct {
	task_state_t sched_state;
	uint32_t eax;
	uint32_t ebx;
	uint32_t ecx;
	uint32_t edx;
	uint32_t esi;
	uint32_t edi;
	uint32_t esp;
	uint32_t ebp;
	uint32_t eip;
	uint32_t eflags;
	uint32_t cr3;
} task_t;

extern task_t idle;
extern task_t tasks[MAX_TASKS];

#endif //  __TASK_DEFINES_H__
