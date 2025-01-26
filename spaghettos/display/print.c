#include "print.h"
#include "../utils/constants.h"
#include "cursor.h"

void cls() {
  char *memory = (char *)VGA_MEMORY;
  int i = 0;
  while (i < (2 * VGA_WIDTH * VGA_HEIGHT)) {
    *(memory + i) = ' ';
    i += 2;
  }
}

void set_monitor_color(char Color) {
  char *memory = (char *)VGA_MEMORY;
  int i = 1;
  while (i < (2 * VGA_HEIGHT * VGA_WIDTH)) {
    *(memory + i) = Color;
    i += 2;
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

  // Clear the last row by filling it with spaces and default color
  for (int col = 0; col < VGA_WIDTH; col++) {
    int index = 2 * ((VGA_HEIGHT - 1) * VGA_WIDTH + col);
    *(memory + index) = ' ';      // Clear character
    *(memory + index + 1) = 0x0f; // Default color
  }

  // Update the cursor to the start of the last row
  set_cursor(VGA_HEIGHT - 1, 0);
}

void print_color_char(char c, char color) {
  char *memory = (char *)VGA_MEMORY;
  int cursor_position = get_cursor_position();
  int cursor_row = cursor_position / (2 * VGA_WIDTH);
  int cursor_col = (cursor_position / 2) % VGA_WIDTH;

  if (cursor_position >= 2 * VGA_WIDTH * VGA_HEIGHT) {
    scroll();
    cursor_position = get_cursor_position(); // Update cursor after scroll
    cursor_row = cursor_position / (2 * VGA_WIDTH);
    cursor_col = (cursor_position / 2) % VGA_WIDTH;
  }

  if (c == '\n') {
    set_cursor(cursor_row + 1, 0);
    return;
  }

  // Write character to the current cursor position
  *(memory + cursor_position) = c;
  *(memory + cursor_position + 1) = color;

  // Update cursor to the next position
  if (cursor_col == VGA_WIDTH - 1) {
    // If at the end of the row, move to the next row
    set_cursor(cursor_row + 1, 0);
  } else {
    // Move to the next column
    set_cursor(cursor_row, cursor_col + 1);
  }
}

void print_color(char *string, char color) {
  int i = 0;
  while (*(string + i) != '\0') {
    print_color_char(*(string + i), color);
    i++;
  }
}

void print_char_uncolor(char c) {
  char *memory = (char *)VGA_MEMORY;
  int cursor_position = get_cursor_position();
  int cursor_row = cursor_position / (2 * VGA_WIDTH);
  int cursor_col = (cursor_position / 2) % VGA_WIDTH;

  if (cursor_position >= 2 * VGA_WIDTH * VGA_HEIGHT) {
    scroll();
    cursor_position = get_cursor_position(); // Update cursor after scroll
    cursor_row = cursor_position / (2 * VGA_WIDTH);
    cursor_col = (cursor_position / 2) % VGA_WIDTH;
  }

  if (c == '\n') {
    set_cursor(cursor_row + 1, 0);
    return;
  }

  // Write character to the current cursor position
  *(memory + cursor_position) = c;

  // Update cursor to the next position
  if (cursor_col == VGA_WIDTH - 1) {
    // If at the end of the row, move to the next row
    set_cursor(cursor_row + 1, 0);
  } else {
    // Move to the next column
    set_cursor(cursor_row, cursor_col + 1);
  }
}

void print_uncolor(char *string) {
  int i = 0;
  while (*(string + i) != '\0') {
    print_char_uncolor(*(string + i));
    i++;
  }
}

void print(char *string) { print_uncolor(string); }

void print_char(char c) { print_char_uncolor(c); }

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