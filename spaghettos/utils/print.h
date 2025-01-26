#ifndef PRINT_H
#define PRINT_H

void cls();
void set_monitor_color(char);

void print(char*);
void print_char(char);

void scroll();

void print_color(char* , char);
void print_color_char(char , char);

void boot_page();

#endif // PRINT_H