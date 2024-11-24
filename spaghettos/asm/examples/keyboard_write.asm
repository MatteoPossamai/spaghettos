; Infinite keyboard input program
; Waits for a keypress, displays it, and then moves to a new line.

org 0x7C00          ; Bootloader location for execution (if used as bootloader)

loop: 
    ; Wait for a keypress
    mov ah, 0         ; BIOS Keyboard Service - Wait for keypress
    int 0x16          ; Result in AL (ASCII) and AH (Scan code)
    
    ; Display the character
    mov ah, 0x0E      ; BIOS Video Service - Teletype Output
    int 0x10          ; Character to print is in AL (from previous int 0x16)

    call print_nl     ; Print empty line 
    jmp loop          ; Jump back to beginnig of loop

; Function to print a newline (CR + LF)
print_nl:
    pusha             ; Save registers

    mov ah, 0x0E      ; BIOS Video Service - Teletype Output
    mov al, 0x0D      ; Carriage return ('\r')
    int 0x10

    mov al, 0x0A      ; Line feed ('\n')
    int 0x10

    popa              ; Restore registers
    ret               ; Return from function

; Fill the remaining bytes to make the bootloader 512 bytes (optional)
times 510-($-$$) db 0
dw 0xAA55           ; Bootloader signature
