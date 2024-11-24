#!/usr/bin/bash

# --- Compile boot loader ---
boot_loader="examples/read_disk"

# Create repository 
mkdir -p build && chmod 755 build

# Compile file
nasm -f bin "spaghettos/asm/$boot_loader.asm" -o "build/boot_loader.bin"

# Make it executable and readable
sudo chmod 777 build/boot_loader.bin

# --- Launch boot loader --- 
qemu-system-x86_64 -drive format=raw,file=build/boot_loader.bin --nographic