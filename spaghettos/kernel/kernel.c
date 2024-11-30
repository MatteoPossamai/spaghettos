void kernel_main() {
    char* video_memory = (char*) 0xb8000;
    video_memory[0] = 'X';  // Character
    video_memory[1] = 'S'; // Attribute byte - white on black
     
    char* second_char = (char *) 0xb8002;
    second_char[0] = 'S';
}