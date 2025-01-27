#include "../cpu/isr.h"
#include "../display/print.h"
#include "../libc/string.h"
#include "../cpu/isr.h"

void kernel_main() {
    isr_install();
    irq_install();

    print("Type something, it will go through the kernel\n"
        "Type END to halt the CPU\n> ");
}

void user_input(char *input) {
    if (strcmp(input, "END") == 0) {
        print("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    }
    print("You said: ");
    print(input);
    print("\n> ");
}