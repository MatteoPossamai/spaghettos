section .text         ; Declaration of the start of the executable code
global _start         ; make _start visible to the Linker (expose the label to run it)
extern kernel_main    ; name of the function that we take as entrypoint in kernel

_start:
[bits 32]             ; required, signals for protected mode
    call kernel_main  ; Call our C function
    jmp $             ; Infinite loop to block the CPU 


; Make stack non executable. If removed creates WARNING
; 
; ld: warning: build/entry.o: missing .note.GNU-stack section implies executable stack
; ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
; 
section .note.GNU-stack noalloc noexec nowrite progbits

