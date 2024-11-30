#!/usr/bin/bash

# Script to launch simple ASM files

# --- Compile boot loader ---
boot_loader="examples/$1"

# Create repository 
mkdir -p build && chmod 755 build

# Compile file
nasm -f bin "spaghettos/asm/$boot_loader.asm" -o "build/boot_loader.bin"

# Make it executable and readable
sudo chmod 777 build/boot_loader.bin

# --- Launch boot loader --- 
qemu-system-i386 -display sdl -drive format=raw,file=build/boot_loader.bin 