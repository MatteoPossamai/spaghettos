; Example: print the alphabet

mov dl, 65
mov ah, 0x0e
loop:
   cmp dl, 91
   je end
   
   mov al, dl
   int 0x10
   inc dl
   
   jmp loop
    
end:


times 510 - ($-$$) db 0
dw 0xaa55