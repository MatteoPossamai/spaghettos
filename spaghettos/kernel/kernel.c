#include "../cpu/isr.h"
#include "../display/print.h"

void kernel_main() {
    set_monitor_color(0x34);
    isr_install();
    /* Test the interrupts */
    __asm__ __volatile__("int $2");
    __asm__ __volatile__("int $9");
}