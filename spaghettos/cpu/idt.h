#ifndef IDT_H
#define IDT_H

#include "../utils/types.h"

#define KERNEL_CS 0x08

typedef struct {
  u16_t low_offset; /* Lower 16 bits of handler function address */
  u16_t sel;        /* Kernel segment selector */
  u8_t always0;
  /* First byte
   * Bit 7: "Interrupt is present"
   * Bits 6-5: Privilege level of caller (0=kernel..3=user)
   * Bit 4: Set to 0 for interrupt gates
   * Bits 3-0: bits 1110 = decimal 14 = "32 bit interrupt gate" */
  u8_t flags;
  u16_t high_offset; /* Higher 16 bits of handler function address */
} __attribute__((packed)) idt_gate_t;

/* A pointer to the array of interrupt handlers, loaded with 'lidt' */
typedef struct {
  u16_t limit;
  u32_t base;
} __attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256
extern idt_gate_t idt[IDT_ENTRIES];
extern idt_register_t idt_reg;

void set_idt_gate(int n, u32_t handler);
void set_idt();

#endif