#!/usr/bin/bash
: '
Note: This code works in Ubuntu 24.04.1 LTS `noble`. It is likely to run in other Ubuntu
machines, and in Linux in general. The code that inspired this(*) was written in Windows, 
and it took a while to be used in the Ubuntu machine. This may therefore not run. 

* https://github.com/TINU-2000/OS-DEV/tree/main/Beginning-OS-DEV/Entering%20c
'

# --- Setup ---

# Exit on any error
set -e  
# Get variables for setting up the system
kernel_name=$1
language=$2

# Check that variables are set
if [ -z "$kernel_name" ]; then
    echo "Error: kernel name variable is not set"
    exit 1
fi

if [ -z "$language" ]; then
    echo "Error: language variable is not set"
    exit 1
fi

# Create repository, if not already there, and change the mod
# to be able to execute all the required operations
mkdir -p build && chmod 755 build

# --- Compile ASM and kernel --- 

# Compile Boot script and kernel entrypoint executor
nasm spaghettos/asm/boot.asm -f bin -o build/boot.bin
nasm spaghettos/asm/kernel_entry.asm -f elf32 -o build/entry.o 

# Compile kernel, according to language and file name
if [ "$language" = "C" ]; then
    gcc -m32 -fno-pie -ffreestanding -c "spaghettos/kernel/$kernel_name.c" -o build/kernel.o
elif [ "$language" = "C++" ]; then
    # TODO: find a way to use also C++
    g++ -m32 -fno-pie -ffreestanding -c "spaghettos/kernel/$kernel_name.cpp" -o build/kernel.o
else
    # TODO: try also using Rust
    echo "Invalid language $language: NOT SUPPORTED"
    exit 1
fi

# --- Link and create kernel files --- 
# Link code 
ld -m elf_i386 -T spaghettos/linker.ld -o build/kernel.img build/entry.o build/kernel.o

# Copy the objects created to make the kernel
objcopy -O binary build/kernel.img build/kernel.bin
# Concatenate boot sector and kernel
cat build/boot.bin build/kernel.bin > build/os-image

# --- RUN ---
# Run the Emulator to spin up kernel
qemu-system-i386 -display sdl -drive format=raw,file=build/os-image