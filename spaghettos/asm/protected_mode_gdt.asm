; GDT and Protected Mode Switching Routines

; Load Global Descriptor Table
load_gdt:
    cli
    lgdt [gdt_descriptor]
    ret

; Switch to Protected Mode
switch_to_protected_mode:
    ; Set protection enable bit in control register
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to flush CPU pipeline and load code segment
    jmp 0x08:protected_mode_start

[BITS 32]
protected_mode_start:
    ; Set up segment registers in protected mode
    mov ax, 0x10    ; Data segment selector
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Optional: Set up a simple kernel entry point or halt
    jmp kernel_entry

; Kernel entry point (placeholder)
kernel_entry:
    ; Your kernel initialization code goes here
    ; For now, we'll just halt
    cli
    hlt

; Global Descriptor Table
gdt_start:
    ; Null descriptor (required)
    dd 0
    dd 0

    ; Code segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 10011010b    ; Access byte (present, ring 0, code, readable)
    db 11001111b    ; Flags and limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)

    ; Data segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 10010010b    ; Access byte (present, ring 0, data, writable)
    db 11001111b    ; Flags and limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)
gdt_end:

; GDT Descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; GDT size
    dd gdt_start                ; GDT address