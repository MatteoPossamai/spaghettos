#include "mem.h"

void memory_copy(char *source, char *dest, int nbytes) {
  int i;
  for (i = 0; i < nbytes; i++) {
    *(dest + i) = *(source + i);
  }
}

void memory_set(u8_t *dest, u8_t val, u32_t len) {
  u8_t *temp = (u8_t *)dest;
  for (; len != 0; len--)
    *temp++ = val;
}
