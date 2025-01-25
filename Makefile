# Makefile for Simple OS

# Assembler and flags
NASM = nasm
NASMFLAGS = -f bin

# Directories
SRC_DIR = ./spaghettos/asm
BUILD_DIR = ../build

# Ensure build directory exists
$(shell mkdir -p $(BUILD_DIR))

# Output binary
TARGET = $(BUILD_DIR)/boot_sect_simple.bin

# Source files
SRCS = $(SRC_DIR)/boot.asm $(SRC_DIR)/protected_mode_gdt.asm

# Default target
all: $(TARGET)

# Compile boot sector
$(TARGET): $(SRCS)
	$(NASM) $(NASMFLAGS) $(SRC_DIR)/boot.asm -o $(TARGET)

# Clean up build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Run in QEMU
run: $(TARGET)
	qemu-system-x86_64 -nographic -display gtk -drive format=raw,file=$(TARGET)

.PHONY: all clean run