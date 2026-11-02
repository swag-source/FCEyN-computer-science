/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "defines.h"
#include "i386.h"

#include "kassert.h"

static pd_entry_t *kpd = (pd_entry_t *)KERNEL_PAGE_DIR;
static pt_entry_t *kpt = (pt_entry_t *)KERNEL_PAGE_TABLE_0;

static const uint32_t identity_mapping_end = 0x003FFFFF;
static const uint32_t user_memory_pool_end = 0x02FFFFFF;

static paddr_t next_free_kernel_page = 0x100000;
static paddr_t next_free_user_page = 0x400000;

/**
 * kmemset asigna el valor c a un rango de memoria interpretado
 * como un rango de bytes de largo n que comienza en s
 * @param s es el puntero al comienzo del rango de memoria
 * @param c es el valor a asignar en cada byte de s[0..n-1]
 * @param n es el tamaño en bytes a asignar
 * @return devuelve el puntero al rango modificado (alias de s)
 */
static inline void *kmemset(void *s, int c, size_t n)
{
  uint8_t *dst = (uint8_t *)s;
  for (size_t i = 0; i < n; i++)
  {
    dst[i] = c;
  }
  return dst;
}

/**
 * zero_page limpia el contenido de una página que comienza en addr
 * @param addr es la dirección del comienzo de la página a limpiar
 */
static inline void zero_page(vaddr_t addr)
{
  kmemset((void *)addr, 0x00, PAGE_SIZE);
}

void mmu_init(void) {}

/**
 * mmu_next_free_kernel_page devuelve la dirección física de la próxima página de kernel disponible.
 * Las páginas se obtienen en forma incremental, siendo la primera: next_free_kernel_page
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de kernel
 */
paddr_t mmu_next_free_kernel_page(void)
{
  paddr_t next_free;
  if (next_free_kernel_page < identity_mapping_end)
  {
    next_free = next_free_kernel_page;
    next_free_kernel_page += PAGE_SIZE;
  }
  else
  {
    return 0; // No hay más páginas de kernel disponibles
  }
  return next_free;
}

/**
 * mmu_next_free_user_page devuelve la dirección de la próxima página de usuarix disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de usuarix
 */
paddr_t mmu_next_free_user_page(void)
{
  if (next_free_user_page < user_memory_pool_end)
  {
    paddr_t next_free = next_free_user_page;
    next_free_user_page += PAGE_SIZE;
    return next_free;
  }
  else
  {
    return 0; // No hay más páginas de usuario disponibles
  }
}

/**
 * mmu_init_kernel_dir inicializa las estructuras de paginación vinculadas al kernel y
 * realiza el identity mapping
 * @return devuelve la dirección de memoria de la página donde se encuentra el directorio
 * de páginas usado por el kernel
 */
paddr_t mmu_init_kernel_dir(void)
{
  zero_page((vaddr_t)kpd);

  // Identity mapping of the first 4MB
  for (uint32_t i = 0; i < 1024; i++)
  {
    kpt[i].page = i;
    kpt[i].attrs = MMU_P | MMU_W;
  }

  kpd[0].pt = KERNEL_PAGE_TABLE_0 >> 12;
  kpd[0].attrs = MMU_P | MMU_W;

  // Update the CR3 to the new cr3

  return KERNEL_PAGE_DIR;
}

/*
 * mmu_map_page agrega las entradas necesarias a las estructuras de paginación de modo de que
 * la dirección virtual virt se traduzca en la dirección física phy con los atributos definidos en attrs
 * @param cr3 el contenido que se ha de cargar en un registro CR3 al realizar la traducción
 * @param virt la dirección virtual que se ha de traducir en phy
 * @param phy la dirección física que debe ser accedida (dirección de destino)
 * @param attrs los atributos a asignar en la entrada de la tabla de páginas
 */
void mmu_map_page(uint32_t cr3, vaddr_t virt, paddr_t phy, uint32_t attrs)
{
  // Extract the base address of the page directory
  pd_entry_t *pd = (pd_entry_t *)CR3_TO_PAGE_DIR(cr3);
  uint32_t pd_idx = VIRT_PAGE_DIR(virt);

  // Extract the page table entry address from the page directory
  // Verify if the PDE is present. If not, allocate a new page table.
  bool pd_entry_p = pd[pd_idx].attrs & MMU_P;
  if (pd_entry_p == 0)
  {
    paddr_t kernel_page = mmu_next_free_kernel_page();
    zero_page((vaddr_t)kernel_page);
    pd[pd_idx].pt = kernel_page >> 12;                // Allocate a new page table
    pd[pd_idx].attrs = attrs | MMU_P | MMU_W | MMU_U; // Set the attributes of the PDE
  }

  pt_entry_t *pt = (pt_entry_t *)(pd[pd_idx].pt << 12);
  uint32_t pt_index = VIRT_PAGE_TABLE(virt);

  // Verify if the page table is defined. If already defined, we map the page. If not, we need to allocate a new page table.
  pt[pt_index].page = phy >> 12;
  pt[pt_index].attrs = attrs | MMU_P;

  // Update the CR3 register with the new cr3
  tlbflush();
}

/**
 * mmu_unmap_page elimina la entrada vinculada a la dirección virt en la tabla de páginas correspondiente
 * @param virt la dirección virtual que se ha de desvincular
 * @return la dirección física de la página desvinculada
 */
paddr_t mmu_unmap_page(uint32_t cr3, vaddr_t virt)
{
  // Extract the base address of the page directory
  pd_entry_t *pd_base = (pd_entry_t *)CR3_TO_PAGE_DIR(cr3);
  uint32_t pd_idx = VIRT_PAGE_DIR(virt);

  // Verify if the associated page directory entry is defined and present. If not, we cannot unmap the page.
  bool pd_entry_present = pd_base[pd_idx].attrs & MMU_P;
  if (pd_entry_present == 0)
  {
    return 0; // Page table not present, cannot unmap page.
  }

  // Verify if the page frame is defined and present. If not, we cannot unmap the page frame.
  // Extract the base address of the page table
  pt_entry_t *pt_base = pd_base[pd_idx].pt << 12;
  uint32_t pt_index = VIRT_PAGE_TABLE(virt);

  bool pt_entry_present = pt_base[pt_index].attrs & MMU_P;
  if (pt_entry_present == 0)
  {
    return 0;
  }

  paddr_t page_number = pt_base[pt_index].page << 12;

  // Clear the page table entry
  pt_base[pt_index].page = 0x0;
  pt_base[pt_index].attrs = 0x0;

  // Update the CR3 register with the new cr3
  tlbflush();

  return page_number;
}

#define DST_VIRT_PAGE 0xA00000
#define SRC_VIRT_PAGE 0xB00000

/**
 * copy_page copia el contenido de la página física localizada en la dirección src_addr a la página física ubicada en dst_addr
 * @param dst_addr la dirección a cuya página queremos copiar el contenido
 * @param src_addr la dirección de la página cuyo contenido queremos copiar
 *
 * Esta función mapea ambas páginas a las direcciones SRC_VIRT_PAGE y DST_VIRT_PAGE, respectivamente, realiza
 * la copia y luego desmapea las páginas. Usar la función rcr3 definida en i386.h para obtener el cr3 actual
 */
void copy_page(paddr_t dst_addr, paddr_t src_addr)
{
  // Request current context CR3 register
  uint32_t cr3 = rcr3();

  // Map (SRC_VIRT_PAGE, src_addr)
  uint32_t src_attributes = MMU_P | MMU_U | MMU_W;
  mmu_map_page(cr3, SRC_VIRT_PAGE, src_addr, src_attributes);

  // Map DST_VIRT_PAGE
  uint32_t dst_attributes = MMU_P | MMU_U | MMU_W;
  mmu_map_page(cr3, DST_VIRT_PAGE, dst_addr, dst_attributes);

  // Copy each entry of the source page (virtual) into the destination (virtual)
  uint32_t *src = (uint32_t *)SRC_VIRT_PAGE;
  uint32_t *dst = (uint32_t *)DST_VIRT_PAGE;
  for (uint32_t i = 0; i < 1024; i++)
  {
    dst[i] = src[i];
  }

  // Unmap pages respectively
  mmu_unmap_page(cr3, SRC_VIRT_PAGE);
  mmu_unmap_page(cr3, DST_VIRT_PAGE);
}

/**
 * mmu_init_task_dir inicializa las estructuras de paginación vinculadas a una tarea cuyo código se encuentra en la dirección phy_start
 * @pararm phy_start es la dirección donde comienzan las dos páginas de código de la tarea asociada a esta llamada
 * @return el contenido que se ha de cargar en un registro CR3 para la tarea asociada a esta llamada
 */
paddr_t mmu_init_task_dir(paddr_t phy_start)
{
  // Request a page from the kernel
  pd_entry_t *kernel_page = (pd_entry_t *)mmu_next_free_kernel_page();

  // Clean page
  zero_page((vaddr_t)kernel_page);

  // Copy the kernel mappings to the requested page
  kernel_page[0] = kpd[0];

  paddr_t cr3 = (paddr_t)kernel_page;

  // User mappings
  paddr_t stack_page = mmu_next_free_user_page();
  mmu_map_page(cr3, TASK_CODE_VIRTUAL, phy_start, MMU_P | MMU_U);
  mmu_map_page(cr3, TASK_CODE_VIRTUAL + PAGE_SIZE, phy_start + PAGE_SIZE, MMU_P | MMU_U);
  mmu_map_page(cr3, TASK_STACK_BASE - PAGE_SIZE, stack_page, MMU_P | MMU_U | MMU_W);
  mmu_map_page(cr3, TASK_SHARED_PAGE, SHARED, MMU_P | MMU_U);

  // Update the CR3
  tlbflush();

  return cr3;
}

bool page_fault_handler(vaddr_t virt)
{
  print("Atendiendo page fault...", 0, 0, C_FG_WHITE | C_BG_BLACK);

  // Check if the virtual address is within [ON_DEMAND_MEM_END_VIRTUAL : ON_DEMAND_MEM_START_VIRTUAL]
  if (virt <= ON_DEMAND_MEM_END_VIRTUAL && virt >= ON_DEMAND_MEM_START_VIRTUAL)
  {
    // Map the new page
    uint32_t cr3 = rcr3();

    paddr_t phy_page = ON_DEMAND_MEM_START_PHYSICAL;

    mmu_map_page(cr3, virt, phy_page, MMU_P | MMU_U | MMU_W);

    // Update the memory mapping of the process
    tlbflush();

    return 1;
  }
  return 0;
}
