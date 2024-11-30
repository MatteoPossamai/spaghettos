# Boot loader (and some useful ASM)

To boot the system, the BIOS delegates the task to the boot sector, which are the first 512 byte of the first sector of the disk. In here there is the Boot Loader. For it to be valid, it needs to terminate with `0xAA55`. 

## Padding and validity
Since we need this, usually to padd with a number of zero and then add the byte signature in the end, there is the following end of file: 
```asm
times 510 - ($-$$) db 0 ; Padding for 510 byte, done by repeating 510 `times` define byte (`db 0`)
; ($ - $$) => current address - starting address = how many times we already wrote
; -> computes automatically the padding required 
dw 0xaa55 ; Define word as the closign 
```
[Full code](../spaghettos/asm/boot_loader_1.asm)

This will look something like (depending on your code):
```binary
00000000: ebfe 0000 0000 0000 0000 0000 0000 0000  ................
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
(...lines...)
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
```
You can see this via `xxd your_binary.bin`.

## ASM instruction
To print something to screen, we have to first go into `tty` mode, by putting `ah` to `0x0e`. Then we can write the char to be printed into `al` and call the interrupt `0x10`. 
```asm
mov ah, 0x0e ; tty mode in `ah` register
mov al, '1' ; Put the data into the register `al`
int 0x10 ; video services interrupt in x86-64
```
[Code for printing chars](../spaghettos/asm/boot_loader_2.asm)

### Interrupts
#### Interrupt `0x10`
This interrupt is the ***Video Service*** interrupt. It can do a number of things, such as:
1. Set video modes (IE: text mode, graphic mode, VGA mode, ....)
2. Cursor manipulation (IE: set/get cursor position, hide/show cursor, ...)
3. Character and String output (IE: Print to screen, change color attributes, ...)
4. Pixel drawing
5. Screen control (IE: clear screen, ...)

The function that is performed is determined by the value in the `ah` register, and the most common functions are: 

|  AH    |            Function           |                          Description                          | 
|:------:|:-----------------------------:|:-------------------------------------------------------------:|
| `0x01` | Set Cursor Type               | Defines the cursor's appearance.                              |   
| `0x02` | Set Cursor Position           | Moves the cursor to a specific row and column.                |  
| `0x09` | Write Character and Attribute | Outputs a character with a specified attribute to the screen. |  
| `0x0E` | Write Character to TTY	     | Prints a character at the current cursor position.            |
| `0x13` | Write String	                 | Outputs a string to the screen.                               |

#### Other famous interrupts
Here is a list of other famous interrupts and what they do

| **INT**  | **Purpose**               | **Description**                                           |
|----------|---------------------------|-----------------------------------------------------------|
| `0x00`   | Divide-by-Zero            | Handles division errors (divide-by-zero or overflow).     |
| `0x01`   | Debug Services            | Triggers single-step or breakpoint debugging.             |
| `0x08`   | System Timer              | Called by the system timer interrupt (18.2 times per second). |
| `0x13`   | Disk Services             | Provides low-level disk access (read/write sectors).      |
| `0x14`   | Serial Port Services      | Manages communication over serial ports (COM ports).      |
| `0x15`   | System Services           | Provides miscellaneous system functions like memory size detection. |
| `0x16`   | Keyboard Services         | Handles keyboard input (get key, check key status).       |
| `0x19`   | Boot Loader Call          | Invokes the bootstrap routine for system startup.         |
| `0x1A`   | Real-Time Clock Services  | Accesses the real-time clock and system timer.            |

### Variables
To define a variable, you can use the following declaration: 
```asm
variable:
    db "X"
```
If you want to print the value, you need to first move to the BIOS offset(`0x7c00`). We then set it globally with:
```asm
[org 0x7c00]
```
### Constants
For defining constant, this is the syntax: 
```asm
CONSTANT_NAME equ 0xb8000
```
[Print variables code](../spaghettos/asm/boot_loader_3.asm)

## Keyboard
To get data from the keyboard, you have to set the `ah` register to be 0, and then call the interrupt `0x16`. In output, we will have in `al` the ASCII code, and in `ah` the scancode. 

[Example](../spaghettos/asm/examples/keyboard_write.asm)

## Bios settings
By tuning the following registers, you can change the values of how the BIOS looks like:
```asm
mov ah , 0x0b 
mov bh , 0x0
mov bl , 0x01
int 0x10
```

In `ah` you can put what you want to change (in the example, the background), in `bh` the page, and in `bl` the parameter (in this case, blue).

For all the infos, refer to the [Wiki](https://en.wikipedia.org/wiki/INT_10H). 