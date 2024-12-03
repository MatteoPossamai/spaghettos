[org 0x7c00]
[bits 16]

; Set video mode
mov ah, 0x00
mov al, 0x03
int 0x10

; Load kernel
mov bx, 0x1000
mov ah, 0x02
mov al, 30
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
int 0x13

; Enable A20 line
in al, 0x92
or al, 2
out 0x92, al

; Load GDT and enter protected mode
cli
lgdt [GDT.Pointer]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:ProtectedMode

[bits 32]
ProtectedMode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; Set up page tables
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, cr3

    ; PML4
    mov DWORD [edi], 0x2003
    add edi, 0x1000
    
    ; PDPT
    mov DWORD [edi], 0x3003
    add edi, 0x1000
    
    ; PD
    mov DWORD [edi], 0x4003
    add edi, 0x1000
    
    ; PT
    mov ebx, 0x00000003
    mov ecx, 512
    
.SetEntry:
    mov DWORD [edi], ebx
    add ebx, 0x1000
    add edi, 8
    loop .SetEntry

    ; Enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Set EFER.LME
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    lgdt [GDT64.Pointer64]
    jmp CODE_SEG:LongMode

[bits 64]
LongMode:
    mov rax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov rsp, 0x90000
    
    ; Jump to kernel
    call 0x1000
    
    jmp $

GDT:
.Null:
    dq 0
.Code:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0
.Data:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
.Pointer:
    dw $ - GDT - 1
    dd GDT

GDT64:
.Null:
    dq 0
.Code:
    dw 0
    dw 0
    db 0
    db 10011010b
    db 00100000b
    db 0
.Data:
    dw 0
    dw 0
    db 0
    db 10010010b
    db 00000000b
    db 0
.Pointer64:
    dw $ - GDT64 - 1
    dq GDT64

CODE_SEG equ GDT.Code - GDT
DATA_SEG equ GDT.Data - GDT

times 510-($-$$) db 0
dw 0xaa55