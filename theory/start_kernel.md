# Kernel
The kernel is part of the software of the operating system that handles a number of operation, as managing memory, system calls and similar. We want to write in probably in higher level languages, such as C/C++, and therefore from our ASM we want to load it into memory and start writing it. 

## Workflow

1. Load the kernel (into memory from disk)
2. Clear the screen
3. Switch to [Protected mode](./gdt.md#protected-mode)
4. Jump to kernel