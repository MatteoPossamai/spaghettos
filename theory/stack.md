# Stack
The stack is a FIFO data structure, that in the hardware starts in the value of register `bp` and ends at `sp` (base pointer and stack pointer). `sp` is always lower than `bp`, since the stack grows downwards. To avoid overwriting, you usually start in an address far from `07c00`, or the BIOS base. A good example is `0x8000`. 

If you want to push something on the stack, you can use the primitive `push 'A'`. Note that once you pushed something into the stack, you will not be able to see the top until you popped everything out of it. Example of code:
```asm
; Pushing 
push 'A'
push 'B'
push 'C'

; Does not work, top cannot be seen
mov al, [0x8000]
int 0x10

; Popping
pop bx
mov al, bl
int 0x10 ; prints C

pop bx
mov al, bl
int 0x10 ; prints B

pop bx
mov al, bl
int 0x10 ; prints A
```
[Full example](../spaghettos/asm/boot_loader_4.asm)