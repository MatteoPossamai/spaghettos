# Variables
BUILD_DIR = ./build
BOOT_ASM = spaghettos/asm/boot.asm 
KERNEL_ENTRY_ASM = spaghettos/asm/kernel_entry.asm 
LINKER_SCRIPT = spaghettos/linker.ld 
OUTPUT_BIN = $(BUILD_DIR)/os_image.bin
KERNEL_DIR ?= ./spaghettos/kernel

# Used Softwares
QEMU = qemu-system-x86_64 
AS = nasm

# Rules
all: $(OUTPUT_BIN) 

# Compile ./spaghettos/asm/boot.asm
$(BUILD_DIR)/boot.bin: $(BOOT_ASM)
	@mkdir -p $(BUILD_DIR) 
	@echo "Compiling boot sector..."
	$(AS) -f bin $< -o $@

# Compile ./spaghettos/asm/kernel_entry.asm
$(BUILD_DIR)/kernel_entry.o: $(KERNEL_ENTRY_ASM)
	@mkdir -p $(BUILD_DIR) 
	@echo "Compiling kernel entry..."
	$(AS) -f elf64 $< -o $@

# Compile and import the kernel
$(BUILD_DIR)/libkernel.a: 
	@echo "Building kernel library..."
	@cd $(KERNEL_DIR) && ./build_kernel.sh
	@cp $(KERNEL_DIR)/build/libkernel.a $(BUILD_DIR)/libkernel.a

# Link all together
$(OUTPUT_BIN): $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/libkernel.a
	@echo "Linking kernel and bootloader..."
	# Link kernel and bootloader separately
	ld -n -T $(LINKER_SCRIPT) -o $(BUILD_DIR)/kernel.bin \
	    $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/libkernel.a
	# Concatenate the bootloader and the kernel into one file
	cat $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin > $(OUTPUT_BIN)
	@echo "OS image created: $(OUTPUT_BIN)"

# Run the OS
run: all
	@echo "Starting QEMU..."
	$(QEMU) -display sdl -drive format=raw,file=$(BUILD_DIR)/os_image.bin

clean: 
	@rm -r $(BUILD_DIR)