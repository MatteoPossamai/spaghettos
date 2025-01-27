#ifndef TYPES_H
#define TYPES_H

typedef unsigned int   u32_t;
typedef          int   i32_t;
typedef unsigned short u16_t;
typedef          short i16_t;
typedef unsigned char  u8_t;
typedef          char  i8_t;

#define low_16(address) (u16_t)((address) & 0xFFFF)
#define high_16(address) (u16_t)(((address) >> 16) & 0xFFFF)

#endif