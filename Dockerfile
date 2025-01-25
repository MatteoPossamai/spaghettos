FROM ubuntu:latest

# Set environment variables to prevent interactive prompts during apt operations
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt update && apt install -y \
    nasm \
    qemu-system-x86 \
    build-essential \ 
    make \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ARG directory=/spaghettos
ARG AS=nasm
ARG CC=gcc
ARG CFLAGS=CFLAGS := -m32 -fno-pie -ffreestanding -Wall -Wextra

# Set the working directory 
WORKDIR $directory
COPY . ${directory}

# Define the default command to build and run the binary using exec form
# CMD ["sh", "-c", "nasm -f bin boot_sect_simple.asm -o boot_sect_simple.bin && qemu-system-x86_64 -nographic -display gtk -drive format=raw,file=boot_sect_simple.bin"]
CMD ["make", "run"]
