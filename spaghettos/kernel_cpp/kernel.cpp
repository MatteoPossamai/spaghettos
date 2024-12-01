// kernel.cpp
extern "C" void kernel_main() {
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