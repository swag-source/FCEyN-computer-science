/* ** por compatibilidad se omiten tildes **
==============================================================================
TALLER System Programming - Arquitectura y Organizacion de Computadoras - FCEN
==============================================================================

  Definiciones globales del sistema.
*/

#ifndef __DEFINES_H__
#define __DEFINES_H__

/* Misc */
/* -------------------------------------------------------------------------- */
// Y Filas
#define SIZE_N 50
#define ROWS SIZE_N

// X Columnas
#define SIZE_M 80
#define COLS SIZE_M

/* Indices en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_COUNT 35

#define GDT_IDX_NULL_DESC 0
#define GDT_IDX_CODE_0 1
#define GDT_IDX_CODE_3 2
#define GDT_IDX_DATA_0 3
#define GDT_IDX_DATA_3 4
#define GDT_IDX_VIDEO 5

/* Offsets en la gdt */
/* -------------------------------------------------------------------------- */
#define GDT_OFF_NULL_DESC (GDT_IDX_NULL_DESC << 3)
#define GDT_OFF_VIDEO (GDT_IDX_VIDEO << 3)

/*
 * Defino los SELECTORES de segmento de mi GDT
 * Recordar:
 *
 *  15              3  2   1 0
 *  +----------------+---+----+
 *  |   GDT index    |TI | RPL|
 *  +----------------+---+----+
 * */
#define GDT_CODE_0_SEL (GDT_IDX_CODE_0 << 3)          // TI = 1, RPL = 0
#define GDT_DATA_0_SEL (GDT_IDX_DATA_0 << 3)          // TI = 1, RPL = 0
#define GDT_CODE_3_SEL (GDT_IDX_CODE_3 << 3) | 0x0003 // TI = 1, RPL = 3
#define GDT_DATA_3_SEL (GDT_IDX_DATA_3 << 3) | 0x0003 // TI = 1, RPL = 3

// SEGM_LIMIT_4KIB es el limite de segmento visto como bloques de 4KIB
// principio del ultimo bloque direccionable.
#define GDT_LIMIT_4KIB(X) (((X) / 4096) - 1)
#define GDT_LIMIT_BYTES(X) ((X) - 1)

#define GDT_LIMIT_LOW(limit) (uint16_t)(((uint32_t)(limit)) & 0x0000FFFF)
#define GDT_LIMIT_HIGH(limit) (uint8_t)((((uint32_t)(limit)) >> 16) & 0x0F)

#define GDT_BASE_LOW(base) (uint16_t)(((uint32_t)(base)) & 0x0000FFFF)
#define GDT_BASE_MID(base) (uint8_t)((((uint32_t)(base)) >> 16) & 0xFF)
#define GDT_BASE_HIGH(base) (uint8_t)((((uint32_t)(base)) >> 24) & 0xFF)

/* (Parte 1: Pasaje a modo protegido)  - Valores de atributos */
#define DESC_CODE_DATA 0x00809A000000330F
#define DESC_SYSTEM 0x0080FA2000000330F
#define DESC_TYPE_EXECUTE_READ 0x008092000000330F
#define DESC_TYPE_READ_WRITE 0x0080F2000000330F

/* Tamaños de segmentos */
#define FLAT_SEGM_SIZE 0xFFFFFFFF // Segmentacion Flat => (0x00000000:0xFFFFFFFF)
#define VIDEO_SEGM_SIZE 0x000B8000

/* Direcciones de memoria */
/* -------------------------------------------------------------------------- */

// direccion fisica de comienzo del bootsector (copiado)
#define BOOTSECTOR 0x00001000
// direccion fisica de comienzo del kernel
#define KERNEL 0x00001200
// direccion fisica del buffer de video
#define VIDEO 0x000B8000
// direccion fisica de la pagina de memoria compartida
#define SHARED 0x0001D000

/* Parte 3: Paginación - defines para MMU */
/* -------------------------------------------------------------------------- */

#define VIRT_PAGE_OFFSET(X) ((X) & 0x00000FFF)        // VIRTUAL_ADDRESS_OFFSET = X[0:11]
#define VIRT_PAGE_TABLE(X) (((X) >> 12) & 0x000003FF) // VIRTUAL_ADDRESS_TABLE = X[12:21]
#define VIRT_PAGE_DIR(X) (((X) >> 22) & 0x000003FF)   // VIRTUAL_ADDRESS_DIRECTORY = X[22:31]
#define CR3_TO_PAGE_DIR(X) (((X) & 0xFFFFF000))       // PAGE_DIRECTORY_BASE = CR3[12:31]
#define MMU_ENTRY_PADDR(X)

#define MMU_P (1 << 0)
#define MMU_W (1 << 1)
#define MMU_U (1 << 2)

#define PAGE_SIZE 4096 // 2^{12}

// direccion virtual del codigo
#define TASK_CODE_VIRTUAL 0x08000000
#define TASK_CODE_PAGES 2
#define TASK_STACK_BASE 0x08003000
#define TASK_SHARED_PAGE 0x08003000

// direccion virtual de memoria compartida on demand
#define ON_DEMAND_MEM_START_VIRTUAL 0x07000000
#define ON_DEMAND_MEM_END_VIRTUAL 0x07000FFF
#define ON_DEMAND_MEM_START_PHYSICAL 0x03000000

// Tipos de descriptor de segmento para la TSS
#define DESC_TYPE_32BIT_TSS 0x9

/* Direcciones fisicas de directorios y tablas de paginas del KERNEL */
/* -------------------------------------------------------------------------- */
#define KERNEL_PAGE_DIR (0x00025000)
#define KERNEL_PAGE_TABLE_0 (0x00026000)
#define KERNEL_STACK (0x00025000)

#endif //  __DEFINES_H__
