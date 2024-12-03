section .text
global _start
extern kernel_main

_start:
[bits 64]
    call kernel_main
    jmp $

section .note.GNU-stack noalloc noexec nowrite progbits