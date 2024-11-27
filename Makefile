$(shell mkdir -p build)

# $@ = target file
# $< = first dependency
# $^ = all dependencies

all: run

# Kernel linking
build/kernel.bin: build/kernel_entry.o build/kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# Compile assembly files
build/kernel_entry.o: spaghettos/asm/kernel_entry.asm
	nasm $< -f elf -o $@

# Compile C files
build/kernel.o: spaghettos/kernel/kernel.c
	i386-elf-gcc -ffreestanding -c $< -o $@

# Disassemble kernel for debugging
build/kernel.dis: build/kernel.bin
	ndisasm -b 32 $< > $@

# Compile boot sector
build/bootsect.bin: spaghettos/asm/bootsect.asm
	nasm $< -f bin -o $@

# Create final OS image
build/os-image.bin: build/bootsect.bin build/kernel.bin
	cat $^ > $@

# Run the OS in QEMU
run: build/os-image.bin
	qemu-system-i386 -display sdl -drive "format=raw,file=$<" 
	

# Clean build artifacts
clean:
	rm -rf build/

# Phony targets
.PHONY: all run clean
