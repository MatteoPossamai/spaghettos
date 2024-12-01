# Language selection (can be C, CPP, or RUST)
LANG ?= C

# Common settings
BUILD_DIR := build
SRC_DIR := spaghettos
ASM_DIR := $(SRC_DIR)/asm

# Assembly settings
AS := nasm
ASFLAGS := -f elf32

# Linker settings
LD := ld
LDFLAGS := -m elf_i386 -T spaghettos/linker.ld

# Language-specific settings
ifeq ($(LANG),C)
    CC := gcc
    COMPILER_FLAGS := -m32 -fno-pie -ffreestanding -Wall -Wextra
    COMPILE_CMD = $(CC) $(COMPILER_FLAGS) -c $< -o $@
    SRC_EXT := c
    OBJ_EXT := o
    KERNEL_DIR := $(SRC_DIR)/kernel
else ifeq ($(LANG),CPP)
    CC := g++
    COMPILER_FLAGS := -m32 -fno-pie -ffreestanding -Wall -Wextra -fno-exceptions -fno-rtti -nostdlib -nostartfiles
    COMPILE_CMD = $(CC) $(COMPILER_FLAGS) -c $< -o $@
    SRC_EXT := cpp
    OBJ_EXT := o
    KERNEL_DIR := $(SRC_DIR)/kernel_cpp
else ifeq ($(LANG),RUST)
    CC := rustc
    COMPILER_FLAGS := --target i686-unknown-linux-gnu \
                     -C panic=abort \
                     -C opt-level=2 \
                     -C code-model=kernel \
                     -C relocation-model=static \
                     --edition=2021 \
                     -C linker-flavor=ld
    COMPILE_CMD = $(CC) $(COMPILER_FLAGS) --emit obj=$@ $<
    SRC_EXT := rs
    OBJ_EXT := o
    KERNEL_DIR := $(SRC_DIR)/kernel_rust
else
    $(error Unknown language $(LANG))
endif

# Find source files
SRCS := $(shell find $(KERNEL_DIR) -name '*.$(SRC_EXT)')
ASM_SRCS := $(shell find $(ASM_DIR) -name '*.asm')

# Generate object file names
OBJS := $(SRCS:$(SRC_DIR)/%.$(SRC_EXT)=$(BUILD_DIR)/%.$(OBJ_EXT))
ASM_OBJS := $(filter-out $(BUILD_DIR)/asm/boot.o, $(ASM_SRCS:$(SRC_DIR)/%.asm=$(BUILD_DIR)/%.o))

# Override LANG environment variable
export LANG=C

# Main targets
.PHONY: all clean run

all: $(BUILD_DIR)/os-image
	@echo "Build completed successfully for $(LANG)"

run: all
	@echo "Starting QEMU..."
	qemu-system-i386 -display sdl -drive format=raw,file=$(BUILD_DIR)/os-image

clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)

# Build rules
$(BUILD_DIR)/os-image: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	@echo "Creating final OS image..."
	cat $^ > $@

$(BUILD_DIR)/boot.bin: $(ASM_DIR)/boot.asm
	@echo "Compiling boot sector..."
	@mkdir -p $(dir $@)
	$(AS) -f bin $< -o $@

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.img
	@echo "Converting kernel to binary..."
	objcopy -O binary $< $@

$(BUILD_DIR)/kernel.img: $(ASM_OBJS) $(OBJS)
	@echo "Linking kernel..."
	@mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^

# Pattern rules for building object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.$(SRC_EXT)
	@echo "Compiling $<..."
	@mkdir -p $(dir $@)
	$(COMPILE_CMD)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@echo "Assembling $<..."
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@