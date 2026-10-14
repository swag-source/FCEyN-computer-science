/* ** por compatibilidad se omiten tildes **
================================================================================
 TALLER System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Rutinas del controlador de interrupciones.
*/
#include "pic.h"

#define PIC1_PORT 0x20
#define PIC2_PORT 0xA0

static __inline __attribute__((always_inline)) void outb(uint32_t port,
                                                         uint8_t data) {
  __asm __volatile("outb %0,%w1" : : "a"(data), "d"(port));
}
void pic_finish1(void) { outb(PIC1_PORT, 0x20); }
void pic_finish2(void) {
  outb(PIC1_PORT, 0x20);
  outb(PIC2_PORT, 0x20);
}

void pic_reset() {
    // Inicialización del PIC1
    outb(PIC1_PORT, 0x11); // ICW1
    
    outb(PIC1_PORT + 1, 0x8); // ICW2
    
    outb(PIC1_PORT + 1, 0x4); // ICW3

    outb(PIC1_PORT + 1, 0x1); // ICW4

    outb(PIC1_PORT + 1, 0xFF); // OCW1

    // Inicialización del PIC2
    outb(PIC2_PORT, 0x11); // ICW1
    
    outb(PIC2_PORT + 1, 0x70); // ICW2

    outb(PIC2_PORT + 1, 0x2); // ICW3

    outb(PIC2_PORT + 1, 0x1); // ICW4

    outb(PIC2_PORT + 1, 0xFF); // OCW1
}

void pic_enable() {
  outb(PIC1_PORT + 1, 0x00);
  outb(PIC2_PORT + 1, 0x00);
}

void pic_disable() {
  outb(PIC1_PORT + 1, 0xFF);
  outb(PIC2_PORT + 1, 0xFF);
}
