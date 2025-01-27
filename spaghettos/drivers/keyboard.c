#include "keyboard.h"
#include "../cpu/isr.h"
#include "../display/print.h"
#include "../libc/mem.h"
#include "ports.h"

#define KEYUP_OFFSET 0x80

// Italian keyboard layout mapping
static char *it_keyboard_lower[] = {
    "ERROR",  "ESC",      "1",     "2",    "3", "4",         "5",      "6", "7",
    "8",      "9",        "0",     "'",    "ì", "Backspace", "Tab",    "q", "w",
    "e",      "r",        "t",     "y",    "u", "i",         "o",      "p", "è",
    "+",      "ENTER",    "LCtrl", "a",    "s", "d",         "f",      "g", "h",
    "j",      "k",        "l",     "ò",    "à", "\\",        "LShift", "ù", "z",
    "x",      "c",        "v",     "b",    "n", "m",         ",",      ".", "-",
    "RShift", "Keypad *", "LAlt",  "Space"};

static char *it_keyboard_upper[] = {
    "ERROR",  "ESC",      "!",     "\"",   "£", "$",         "%",      "&", "/",
    "(",      ")",        "=",     "?",    "^", "Backspace", "Tab",    "Q", "W",
    "E",      "R",        "T",     "Y",    "U", "I",         "O",      "P", "é",
    "*",      "ENTER",    "LCtrl", "A",    "S", "D",         "F",      "G", "H",
    "J",      "K",        "L",     "ç",    "°", "|",         "LShift", "§", "Z",
    "X",      "C",        "V",     "B",    "N", "M",         ";",      ":", "_",
    "RShift", "Keypad *", "LAlt",  "Space"};

static int shift_pressed = 0;

static void keyboard_callback_it(registers_t regs) {
  u8_t scancode = port_byte_in(0x60);

  // Handle shift keys
  if (scancode == 0x2A || scancode == 0x36) { // Left or right shift pressed
    shift_pressed = 1;
    return;
  } else if (scancode == (0x2A + KEYUP_OFFSET) ||
             scancode == (0x36 + KEYUP_OFFSET)) { // Shift released
    shift_pressed = 0;
    return;
  }

  // Handle regular keys
  if (scancode < KEYUP_OFFSET) { // Key press
    if (scancode < sizeof(it_keyboard_lower) / sizeof(it_keyboard_lower[0])) {
      if (shift_pressed) {
        print(it_keyboard_upper[scancode]);
      } else {
        print(it_keyboard_lower[scancode]);
      }
    } else {
      print("Unknown key");
    }
  }
  // Key release events can be ignored or handled separately if needed
}

void init_keyboard_it() {
  register_interrupt_handler(IRQ1, keyboard_callback_it);
}

// Helper function to print the full scancode for debugging
void print_scancode_it(u8_t scancode) {
  char sc_ascii[16];
  int_to_ascii(scancode, sc_ascii);
  print("Scancode: ");
  print(sc_ascii);
  print("\n");
}

// Function to handle special Italian characters
char *get_special_char(u8_t scancode, int shifted) {
  // Add any special character handling here
  // For example, dead keys for accents
  return shifted ? it_keyboard_upper[scancode] : it_keyboard_lower[scancode];
}

// ------------------------------------------------------------------------

// US QWERTY keyboard layout mapping
static char *us_keyboard_lower[] = {
    "ERROR", "ESC",  "1",      "2",  "3",     "4",     "5",         "6",
    "7",     "8",    "9",      "0",  "-",     "=",     "Backspace", "Tab",
    "q",     "w",    "e",      "r",  "t",     "y",     "u",         "i",
    "o",     "p",    "[",      "]",  "ENTER", "LCtrl", "a",         "s",
    "d",     "f",    "g",      "h",  "j",     "k",     "l",         ";",
    "'",     "`",    "LShift", "\\", "z",     "x",     "c",         "v",
    "b",     "n",    "m",      ",",  ".",     "/",     "RShift",    "Keypad *",
    "LAlt",  "Space"};

static char *us_keyboard_upper[] = {
    "ERROR", "ESC",  "!",      "@", "#",     "$",     "%",         "^",
    "&",     "*",    "(",      ")", "_",     "+",     "Backspace", "Tab",
    "Q",     "W",    "E",      "R", "T",     "Y",     "U",         "I",
    "O",     "P",    "{",      "}", "ENTER", "LCtrl", "A",         "S",
    "D",     "F",    "G",      "H", "J",     "K",     "L",         ":",
    "\"",    "~",    "LShift", "|", "Z",     "X",     "C",         "V",
    "B",     "N",    "M",      "<", ">",     "?",     "RShift",    "Keypad *",
    "LAlt",  "Space"};

static void keyboard_callback_us(registers_t regs) {
  u8_t scancode = port_byte_in(0x60);

  // Handle shift keys
  if (scancode == 0x2A || scancode == 0x36) { // Left or right shift pressed
    shift_pressed = 1;
    return;
  } else if (scancode == (0x2A + KEYUP_OFFSET) ||
             scancode == (0x36 + KEYUP_OFFSET)) { // Shift released
    shift_pressed = 0;
    return;
  }

  // Handle regular keys
  if (scancode < KEYUP_OFFSET) { // Key press
    if (scancode < sizeof(us_keyboard_lower) / sizeof(us_keyboard_lower[0])) {
      if (shift_pressed) {
        print(us_keyboard_upper[scancode]);
      } else {
        print(us_keyboard_lower[scancode]);
      }
    } else {
      print("Unknown key");
    }
  }
  // Key release events can be ignored or handled separately if needed
}
void print_scancode_us(u8_t scancode) {
  char sc_ascii[16];
  int_to_ascii(scancode, sc_ascii);
  print("Scancode: ");
  print(sc_ascii);
  print("\n");
}

// Function to handle special characters (if needed)
char *get_special_char_us(u8_t scancode, int shifted) {
  return shifted ? us_keyboard_upper[scancode] : us_keyboard_lower[scancode];
}

void init_keyboard_us() {
  register_interrupt_handler(IRQ1, keyboard_callback_us);
}

// ----------------------------------------
void init_keyboard(){
  init_keyboard_us();
}
void print_scancode(u8_t scancode){
  print_scancode_us(scancode);
}