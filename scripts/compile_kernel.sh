#!/usr/bin/bash

language=$1

if [ $language = "C" ]; then
    # Compile and link - C
    i386-elf-gcc -ffreestanding -c spaghettos/kernel/kernel.c -o kernel.o
    i386-elf-ld -o kernel.bin -Ttext 0x0 --oformat binary kernel.o
elif [ $language = "C++" ]; then
    # Compile and link - C++
    i386-elf-g++ -ffreestanding -c spaghettos/kernel/kernel.cpp -o kernel.o
    i386-elf-ld -o kernel.bin -Ttext 0x0 --oformat binary kernel.o
else
    echo "Not supported language for kernel"
fi

# --- Extra ---
# Examine machine code
# i386-elf-objdump -d kernel.o
# Decompile to see machine code
# ndisasm -b 32 kernel.bin
# --- End Extra --- 