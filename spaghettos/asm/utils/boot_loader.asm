; Add the padding and magic number by default to each 
; `*.asm` file to avoid repetition

times 510-($-$$) db 0   ; For 510 - (bytes alreay written) add padding of 0
dw 0xaa55               ; Magic number, make the drive bootable