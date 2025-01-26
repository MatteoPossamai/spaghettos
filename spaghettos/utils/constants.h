#ifndef CONSTANTS_H
#define CONSTANTS_H

// VGA Constants
#define VGA_WIDTH 80       // Number of columns in VGA text mode
#define VGA_HEIGHT 25      // Number of rows in VGA text mode
#define VGA_MEMORY 0xB8000 // Base address for VGA text buffer

// VGA I/O Port Constants
#define VGA_CONTROL_REGISTER 0x3D4 // Control register
#define VGA_DATA_REGISTER 0x3D5    // Data register

// Cursor High and Low Byte Indices
#define CURSOR_HIGH_BYTE 14
#define CURSOR_LOW_BYTE 15

#endif // CONSTANTS_H