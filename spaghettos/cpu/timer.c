#include "../drivers/ports.h"
#include "isr.h"

u32_t tick = 0;

static void timer_callback(registers_t regs) { tick++; }

void init_timer(u32_t freq) {
  /* Install the function we just wrote */
  register_interrupt_handler(IRQ0, timer_callback);

  /* Get the PIT value: hardware clock at 1193180 Hz */
  u32_t divisor = 1193180 / freq;
  u8_t low = (u8_t)(divisor & 0xFF);
  u8_t high = (u8_t)((divisor >> 8) & 0xFF);
  /* Send the command */
  port_byte_out(0x43, 0x36); /* Command port */
  port_byte_out(0x40, low);
  port_byte_out(0x40, high);
}
