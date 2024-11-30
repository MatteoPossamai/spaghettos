all: kernel

clean:
	rm -rf build/

kernel:
	@./scripts/launch_kernel.sh $(KERNEL) $(LANGUAGE)

# Phony targets
.PHONY: all kernel clean

# example code: make KERNEL="kernel" LANGUAGE="C"