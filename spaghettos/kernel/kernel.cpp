void kernel_main() {
    char* video_memory = (char*) 0xb8000;
    video_memory[0] = 'K';  // Character
    // video_memory[1] = 0x0F; // Attribute byte - white on black
}