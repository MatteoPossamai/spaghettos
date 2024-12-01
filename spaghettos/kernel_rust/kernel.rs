#![no_std] // No standard library
#![no_main] // No default entry point

use core::panic::PanicInfo;

/// This function is called if the kernel panics.
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

/// The kernel entry point.
#[no_mangle] // Prevent name mangling so the function name matches what the bootloader expects.
pub extern "C" fn kernel_main() -> ! {
    // Pointer to the VGA text buffer at memory address 0xb8000.
    let vga_buffer: *mut u8 = 0xb8000 as *mut u8;

    unsafe {
        // Write the ASCII character 'K' to the VGA buffer.
        *vga_buffer = b'K'; // `b'K'` represents the ASCII value of 'K'.
        *(vga_buffer.add(1)) = 0x07; // Attribute byte: light gray on black.
    }

    // Halt the CPU to prevent execution from continuing after the kernel finishes.
    loop {}
}
