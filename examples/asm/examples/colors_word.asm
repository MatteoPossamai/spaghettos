mov ah , 0x0b 
mov bh , 0x0
mov bl , 0xa5
int 0x10


mov ah, 0x0e


mov al , 'H'
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xaa55