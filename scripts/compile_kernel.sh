#!/usr/bin/bash

# Compile
i386-elf-gcc -ffreestanding -c function.c -o function.o

# Examine machine code
i386-elf-objdump -d function.o

# Link
i386-elf-ld -o function.bin -Ttext 0x0 --oformat binary function.o

# Decompile to see machine code
ndisasm -b 32 function.bin