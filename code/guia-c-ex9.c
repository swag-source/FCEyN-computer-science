#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
int main() {
  // We want to check if the highest 3 bits of string are equal to the lowest 3
  // bits of another string a = 1110 0000 0000 0000 0000 0000 0000 0000 b = 0000
  // 0000 0000 0000 0000 0000 0000 0111
  uint32_t a = 0x10000000;
  uint32_t b = 0x00000007;

  printf("Are they equal: %d", ((a >> 29) ^ (b & 0x7)) == 0);

  return 0;
}
