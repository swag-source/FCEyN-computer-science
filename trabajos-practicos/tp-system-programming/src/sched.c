/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones del scheduler
*/

#include "sched.h"

#include "i386.h"
#include "kassert.h"

/**
 * Tarea actualmente en ejecución (excepto que esté pasuada, en cuyo caso se
 * corre la idle).
 */
uint32_t current_task = 0;

/**
 * Deshabilita una tarea en el scheduler
 *
 * @param task_id la tarea a deshabilitar
 */
void sched_disable_task(int8_t task_id) {
  kassert(task_id >= 0 && task_id < MAX_TASKS, "Invalid task_id");
  tasks[task_id].sched_state = TASK_PAUSED;
}

/**
 * Habilita un tarea en el scheduler
 *
 * @param task_id la tarea a habilitar
 */
void sched_enable_task(int8_t task_id) {
  kassert(task_id >= 0 && task_id < MAX_TASKS, "Invalid task_id");
  tasks[task_id].sched_state = TASK_RUNNABLE;
}

/**
 * Obtiene la siguiente tarea disponible con una política round-robin. Si no
 * hay tareas disponibles, se salta a la tarea Idle.
 *
 * @return uint16_t el selector de segmento de la tarea a saltar
 */
uint32_t sched_next_task(void) {
  // Buscamos la próxima tarea viva (comenzando en la actual)
  int8_t i;
  for (i = (current_task + 1); (i % MAX_TASKS) != current_task; i++) {
    // Si esta tarea está disponible la ejecutamos
    if (tasks[i % MAX_TASKS].sched_state == TASK_RUNNABLE) {
      break;
    }
  }

  // Ajustamos i para que esté entre 0 y MAX_TASKS-1
  i = i % MAX_TASKS;

  // Si la tarea que encontramos es ejecutable entonces vamos a correrla.
  if (tasks[i].sched_state == TASK_RUNNABLE) {
    current_task = i;
    return i;
  }

  // En el peor de los casos no hay ninguna tarea viva. Usemos la idle.
  return 0;
}
