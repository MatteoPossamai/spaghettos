# Compiler and linker settings
CC := gcc
AS := nasm
LD := ld
GDB := gdb

# Compiler flags
CFLAGS := -g -m32 -fno-pie -ffreestanding -Wall -Wextra
ASFLAGS := -f elf32
# TODO: what is elf32
# TODO: understand why this address does not matter and I can delete the 
# whole linker file and still work just fine
LDFLAGS := -m elf_i386 -T spaghettos/linker.ld #-Ttext 0x1000

# Directories
SRC_DIR := spaghettos
KERNEL_DIR := $(SRC_DIR)
ASM_DIR := $(SRC_DIR)/asm
BUILD_DIR := build

# Find all source files
C_SRCS := $(shell find $(KERNEL_DIR) -name '*.c')
HEADERS := $(shell find $(KERNEL_DIR) -name '*.h')
ASM_SRCS := $(shell find $(ASM_DIR) -name '*.asm')

# Generate object file names
C_OBJS := $(C_SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
ASM_OBJS := $(filter-out $(BUILD_DIR)/asm/boot.o, $(ASM_SRCS:$(SRC_DIR)/%.asm=$(BUILD_DIR)/%.o))

# Main targets
.PHONY: all clean run

all: $(BUILD_DIR)/os-image

run: all
	qemu-system-i386 -display gtk -drive format=raw,file=$(BUILD_DIR)/os-image

clean:
	rm -rf $(BUILD_DIR)

debug: all
	qemu-system-i386 -s -S -display gtk -drive format=raw,file=$(BUILD_DIR)/os-image &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file build/kernel.img"

# Build rules
$(BUILD_DIR)/os-image: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $@

$(BUILD_DIR)/boot.bin: $(ASM_DIR)/boot.asm
	@mkdir -p $(dir $@)
	$(AS) -f bin $< -o $@

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.img
	objcopy -O binary $< $@

$(BUILD_DIR)/kernel.img: $(ASM_OBJS) $(C_OBJS)
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^

# Pattern rules for building object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@