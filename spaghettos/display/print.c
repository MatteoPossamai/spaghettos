#include "print.h"
#include "../utils/constants.h"
#include "cursor.h"

void cls() {
    char *memory = (char *)VGA_MEMORY;
    for (int i = 0; i < (2 * VGA_WIDTH * VGA_HEIGHT); i += 2) {
        *(memory + i) = ' ';
        *(memory + i + 1) = 0x0f; // Default color
    }
    set_cursor(0, 0);
}

void set_monitor_color(char Color) {
    char *memory = (char *)VGA_MEMORY;
    for (int i = 1; i < (2 * VGA_HEIGHT * VGA_WIDTH); i += 2) {
        *(memory + i) = Color;
    }
}

void scroll() {
    char *memory = (char *)VGA_MEMORY;

    // Move each row of characters one row up
    for (int row = 1; row < VGA_HEIGHT; row++) {
        for (int col = 0; col < VGA_WIDTH; col++) {
            int source_index = 2 * (row * VGA_WIDTH + col);
            int dest_index = 2 * ((row - 1) * VGA_WIDTH + col);

            // Copy character and its color from the row below
            *(memory + dest_index) = *(memory + source_index);
            *(memory + dest_index + 1) = *(memory + source_index + 1);
        }
    }

    // Clear the last row
    for (int col = 0; col < VGA_WIDTH; col++) {
        int index = 2 * ((VGA_HEIGHT - 1) * VGA_WIDTH + col);
        *(memory + index) = ' ';
        *(memory + index + 1) = 0x0f; // Default color
    }

    // Update cursor to start of last row
    set_cursor(VGA_HEIGHT - 1, 0);
}

void print_color_char(char c, char color) {
    char *memory = (char *)VGA_MEMORY;
    int cursor_position = get_cursor_position();
    int cursor_row = (cursor_position / 2) / VGA_WIDTH;
    int cursor_col = (cursor_position / 2) % VGA_WIDTH;

    // Handle newline
    if (c == '\n') {
        cursor_row++;
        cursor_col = 0;
        if (cursor_row >= VGA_HEIGHT) {
            scroll();
            cursor_row = VGA_HEIGHT - 1;
        }
        set_cursor(cursor_row, cursor_col);
        return;
    }

    // Check if we need to scroll
    if (cursor_row >= VGA_HEIGHT - 1 && cursor_col >= VGA_WIDTH - 1) {
        scroll();
        cursor_position = get_cursor_position();
        cursor_row = (cursor_position / 2) / VGA_WIDTH;
        cursor_col = (cursor_position / 2) % VGA_WIDTH;
    }

    // Write character and color
    int offset = 2 * (cursor_row * VGA_WIDTH + cursor_col);
    *(memory + offset) = c;
    *(memory + offset + 1) = color;

    // Move cursor
    cursor_col++;
    if (cursor_col >= VGA_WIDTH) {
        cursor_col = 0;
        cursor_row++;
        if (cursor_row >= VGA_HEIGHT) {
            scroll();
            cursor_row = VGA_HEIGHT - 1;
        }
    }
    set_cursor(cursor_row, cursor_col);
}

void print_color(char *string, char color) {
    for (int i = 0; string[i] != '\0'; i++) {
        print_color_char(string[i], color);
    }
}

void print_char_uncolor(char c) {
    print_color_char(c, 0x0f); // Default color (white on black)
}

void print_uncolor(char *string) {
    print_color(string, 0x0f); // Default color (white on black)
}

void print(char *string) {
    print_uncolor(string);
}

void print_char(char c) {
    print_char_uncolor(c);
}

void boot_page() {
    cls();
    set_monitor_color(0xa5);

    char title[] = "SpahettOs - Pile of spaghetti code in your kernel\n";
    char sub[] = "Version 0.0.1\n\n";
    char OSM[] = "linguine $> ";

    print(title);
    print(sub);
    print(OSM);
}