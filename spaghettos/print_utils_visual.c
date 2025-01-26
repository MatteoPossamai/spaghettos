
// TODO: investigate why prints just vertical lines
void setMonitorColorVisual(unsigned char color) {
    // Video memory starts at 0xA0000 in mode 0x12
    unsigned char *videoMemory = (unsigned char *)0xA0000;

    // 640x480 resolution means there are 640 * 480 pixels.
    // Each byte in video memory stores 2 pixels (4 bits per pixel).
    int pixelCount = 640 * 480 / 2; // Divide by 2 because 2 pixels per byte

    // Combine two pixels with the same color into a single byte
    unsigned char pixelByte = (color << 4) | color;

    // Fill the screen by writing pixelByte into all of video memory
    for (int i = 0; i < pixelCount; i++) {
        videoMemory[i] = pixelByte;
    }
}