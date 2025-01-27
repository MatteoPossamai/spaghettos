#ifndef KEYBOARD_H
#define KEYBOARD_H

#include "../utils/types.h"

void init_keyboard();
void print_scancode(u8_t scancode);

void init_keyboard_it();
void print_scancode_it(u8_t scancode);

void init_keyboard_us();
void print_scancode_us(u8_t scancode);

#endif // KEYBOARD_H