/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de estructuras para administrar tareas
*/

#include "tss.h"
#include "defines.h"
#include "kassert.h"

/*
 * TSS del sistema (sólo se usa para el cambio de pila al hacer cambios de
 * privilegio)
 */
tss_t tss = {
  .ss0 = GDT_DATA_0_SEL,
  .esp0 = KERNEL_STACK,
};

/**
 * Inicializa las primeras entradas de tss (inicial y idle)
 */
void tss_init(void) {
  // COMPLETAR
  gdt[GDT_IDX_TASK_INITIAL] = (gdt_entry_t) {
    .g = 0,
    .limit_15_0 = sizeof(tss_t) - 1,
    .limit_19_16 = 0x0,
    .base_15_0 = GDT_BASE_LOW(&tss),
    .base_23_16 = GDT_BASE_MID(&tss),
    .base_31_24 = GDT_BASE_HIGH(&tss),
    .p = 1,
    .type = DESC_TYPE_32BIT_TSS,
    .s = DESC_SYSTEM,
    .dpl = 0,
  };
}
