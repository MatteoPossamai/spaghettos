# Resolve problem with libpthread

https://stackoverflow.com/questions/75921414/java-symbol-lookup-error-snap-core20-current-lib-x86-64-linux-gnu-libpthread

# Interrupts

## IDT

[Source](https://wiki.osdev.org/Interrupt_Descriptor_Table)

Similar to GDT, Maps interrupt to ISR (interrupt service routine) handler. Entries are called gates. It can contain Interrupt Gates, Task Gates and Trap Gates.

There areb by default 256 interrupt vectors, but only 32 are used by the CPU. The rest are reserved for future use. If you access non used vectors, the CPU will throw a general protection fault.

## IRQ
Interrupt request. Generated from the hardware, as for example the keyboard that is clicked.

## ISR
Handler, function that once a specific interrupt is generated will be called. 

## PIC
[Source](https://wiki.osdev.org/8259_PIC). It is a phisical chip. At the moment APIC is the used standard. 
Pic has master and slave with ports 0x20 and 0xA0 respectively for command and 0x21 and 0xA1 for data.

# packed and aligned

[Source](https://stackoverflow.com/questions/11770451/what-is-the-meaning-of-attribute-packed-aligned4)

- packed means it will use the smallest possible space for struct Ball - i.e. it will cram fields together without padding
- aligned means each struct Ball will begin on a 4 byte boundary - i.e. for any struct Ball, its address can be divided by 4
