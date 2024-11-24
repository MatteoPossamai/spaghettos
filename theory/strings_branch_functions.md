# Strings, branch, functions
[Full example code](../spaghettos/asm/boot_loader_5.asm)
## Include
For including another asm file into the main, the syntax is the following:
```asm
%include "/path/to/file.asm"
```

## Strings
In ASM, strings are a sequence of ASCII characters with a 0 at the end (as in C). 
```asm
mystring:
    db 'Hello, World', 0
```
## Branch
You can decide to branch on a given condition. So, you can use the `cmp` primitive to compare two values. Then, with conditional jumps (IE `je`, `jne`, `jle`, ...) you can decide where to jump. Otherwise there is unconditional jump `jmp`. 

```asm
cmp ax, 0      ; Equivalent of if (ax == 0){printf('T');} else {printf('F');}
je ax_is_four 
jmp else   
jmp endif 

ax_is_four:
    mov ah, 0x0e
    mov al, 'T'
    int 0x10
    jmp endif

else:
    mov ah, 0x0e
    mov al, 'F'
    int 0x10
    jmp endif 
endif:
```

## Function calls
You can use function calls with jumps and labels, but this became problematic with the number of labels, and makes the reuse of code impossible. Another approach is to push on the stack all the current context (`pusha`), and then from there do everything. In the end, to complete, pop of the stack all (`popa`). 
