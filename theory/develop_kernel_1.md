# Kernel, basics

## Text mode
We just started our kernel, and it is now in `Text Mode`. It is a 80x25 mode matrix in which you can print colors and letter to screen. To do so, you can start by modifying from the address `0xb8000`. It has to be cast as `char*` in C. There you save the character you want to display. At the next location (`0xb8001`) you can poke with the color (first four bit for background, last four for foregroud). 
Here is a snippet of a kernel to make the whole screen magenta. 
```c
void start(){
    char* cell = (char*) 0xb8000;
    int i = 1;
    while(i < (2 * 80 * 25)){
        *(cell + i) = 0xd5; // d is background, 5 is foreground (do not notice in this example)
        i += 2;
    }
}
```
Alternatively, for having the printed alphabeth with black words and azure background:
```c
void kernel_main() {
  char *cell = (char *)0xb8000;
  int i = 0;
  int c = 0;
  while (i < (2 * 80 * 25)) {
    *(cell + i) = (c % 26) + 'a';
    i += 1;
    c++;
    *(cell + i) = 0xb0;
    i += 1;
  }
}
```

TODO: Page 139