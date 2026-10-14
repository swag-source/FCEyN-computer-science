/* ** por compatibilidad se omiten tildes **
==============================================================================
TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
==============================================================================

  Definicion de la tabla de descriptores globales
*/

#include "gdt.h"
#include "defines.h"

/* Aca se inicializa un arreglo de forma estatica
GDT_COUNT es la cantidad de líneas de la GDT y esta definido en defines.h */
#define SEGMENT_LIMIT 0x0000340F
#define BASE_ADDRESS 0x00000000
#define VIDEO_BASE_ADDRESS 0x000B8000
#define VIDEO_SEGMENT_LIMIT 0x000B9F3F

gdt_entry_t gdt[GDT_COUNT] = {
    /* Descriptor nulo*/
    /* Offset = 0x00 */
    [GDT_IDX_NULL_DESC] =
    {
        .limit_15_0 = 0x0000,
        .base_15_0 = 0x0000,
        .base_23_16 = 0x00,
        .type = 0x0,
        .s = 0x00,
        .dpl = 0x00,
        .p = 0x00,
        .limit_19_16 = 0x00,
        .avl = 0x0,
        .l = 0x0,
        .db = 0x0,
        .g = 0x00,
        .base_31_24 = 0x00,
    },
   /* Offset = 0x08 */
    [GDT_IDX_CODE_0] =
    {
        .limit_15_0 = GDT_LIMIT_LOW(SEGMENT_LIMIT),
        .base_15_0 = GDT_BASE_LOW(BASE_ADDRESS),
        .base_23_16 = GDT_BASE_MID(BASE_ADDRESS),
        .type = 0xA,
        .s = 0x1,
        .dpl = 0x0,
        .p = 0x1,
        .limit_19_16 = GDT_LIMIT_HIGH(SEGMENT_LIMIT),
        .avl = 0x0,
        .l = 0x0,
        .db = 0x1,
        .g = 0x1,
        .base_31_24 = GDT_BASE_HIGH(BASE_ADDRESS),
    },
    /* Offset = 0x10 */
    [GDT_IDX_DATA_0] = {
        .limit_15_0 = GDT_LIMIT_LOW(SEGMENT_LIMIT),
        .base_15_0 = GDT_BASE_LOW(BASE_ADDRESS),
        .base_23_16 = GDT_BASE_MID(BASE_ADDRESS),
        .type = 0x2,
        .s = 0x1,
        .dpl = 0x0,
        .p = 0x1,
        .limit_19_16 = GDT_LIMIT_HIGH(SEGMENT_LIMIT),
        .avl = 0x0,
        .l = 0x0,
        .db = 0x1,
        .g = 0x1,
        .base_31_24 = GDT_BASE_HIGH(BASE_ADDRESS),
    },
    /* Offset = 0x18 */
    [GDT_IDX_CODE_3] = {
        .limit_15_0 = GDT_LIMIT_LOW(SEGMENT_LIMIT),
        .base_15_0 = GDT_BASE_LOW(BASE_ADDRESS),
        .base_23_16 = GDT_BASE_MID(BASE_ADDRESS),
        .type = 0xA,
        .s = 0x1,
        .dpl = 0x3,
        .p = 0x1,
        .limit_19_16 = GDT_LIMIT_HIGH(SEGMENT_LIMIT),
        .avl = 0x0,
        .l = 0x0,
        .db = 0x1,
        .g = 0x1,
        .base_31_24 = GDT_BASE_HIGH(BASE_ADDRESS),
    },
    /* Offset = 0x20*/
    [GDT_IDX_DATA_3] = {
        .limit_15_0 = GDT_LIMIT_LOW(SEGMENT_LIMIT),
        .base_15_0 = GDT_BASE_LOW(BASE_ADDRESS),
        .base_23_16 = GDT_BASE_MID(BASE_ADDRESS),
        .type = 0x2,
        .s = 0x1,
        .dpl = 0x3,
        .p = 0x1,
        .limit_19_16 = GDT_LIMIT_HIGH(SEGMENT_LIMIT),
        .avl = 0x0,
        .l = 0x0,
        .db = 0x1,
        .g = 0x1,
        .base_31_24 = GDT_BASE_HIGH(BASE_ADDRESS),
    },
    /* Offset = 0x28 */
    [GDT_IDX_VIDEO] = {
        .limit_15_0 = GDT_LIMIT_LOW(VIDEO_SEGMENT_LIMIT),
        .base_15_0 = GDT_BASE_LOW(VIDEO_BASE_ADDRESS),
        .base_23_16 = GDT_BASE_MID(VIDEO_BASE_ADDRESS),
        .type = 0x2,
        .s = 0x1 ,
        .dpl = 0x0,
        .p = 0x1,
        .limit_19_16 = GDT_LIMIT_HIGH(VIDEO_SEGMENT_LIMIT),
        .avl = 0x0,
        .l = 0x0,
        .db = 0x1,
        .g = 0x1,
        .base_31_24 = GDT_BASE_HIGH(VIDEO_BASE_ADDRESS)
    }
};

// Aca hay una inicializacion estatica de una structura que tiene su primer componente el tamano 
// y en la segunda, la direccion de memoria de la GDT. Observen la notacion que usa. 
gdt_descriptor_t GDT_DESC = {sizeof(gdt) - 1, (uint32_t)&gdt};
