#include "../utils/constants.h"
#include "../drivers/ports.h"

int set_cursor(int row, int col) {
    if (row >= VGA_HEIGHT || col >= VGA_WIDTH) return 1;

    int position = row * VGA_WIDTH + col;

    // Write the high byte of the position to control register (index 14)
    port_byte_out(VGA_CONTROL_REGISTER, CURSOR_HIGH_BYTE);
    port_byte_out(VGA_DATA_REGISTER, (position >> 8) & 0xFF); // Send high byte

    // Write the low byte of the position to control register (index 15)
    port_byte_out(VGA_CONTROL_REGISTER, CURSOR_LOW_BYTE);
    port_byte_out(VGA_DATA_REGISTER, position & 0xFF); // Send low byte
    return 0;
}


int get_cursor_position(){
    port_byte_out(VGA_CONTROL_REGISTER, CURSOR_HIGH_BYTE); 
    int position = port_byte_in(VGA_DATA_REGISTER);
    position = position << 8;
    port_byte_out(VGA_CONTROL_REGISTER, CURSOR_LOW_BYTE); 
    position += port_byte_in(VGA_DATA_REGISTER);

    return position * 2;
}