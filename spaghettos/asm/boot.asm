; TODO
; - Jump from real mode to protected mode (V)
; - Jump from protected mode to long mode

[BITS 16]
[ORG 0x7C00]

; Boot sector entry point
start:
    ; Clear interrupts and set up segment registers
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Set up stack pointer

    ; Enable A20 line (for accessing memory above 1MB)
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Load Global Descriptor Table
    call load_gdt

    ; Switch to protected mode
    call switch_to_protected_mode

    ; We should never return here
    jmp $

; Include external files for GDT and protected mode switch
%include "./spaghettos/asm/protected_mode_gdt.asm"

; Pad the boot sector to 510 bytes and add boot signature
times 510 - ($ - $$) db 0
dw 0xAA55