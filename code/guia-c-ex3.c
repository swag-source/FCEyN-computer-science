#include <stdio.h>

int main() {
  char a = 127;            // should print -> sizeof(a) = 1
  unsigned char u_a = 255; // should print -> sizeof(u_a) = 1

  short b = 32766;            // should print -> sizeof(u_b) = 1
  unsigned short u_b = 32766; // should print -> sizeof(u_b) = 2

  int c = 1234;              // should print -> sizeof(c) = 4
  unsigned int u_c = 123456; // should print -> sizeof(u_c) = 4

  float d = 0.123456789; // should print -> sizeof(d) = 4

  long l = 10000000000;        // should print -> sizeof(l) = 8
  unsigned long u_l = 1203943; // should print -> sizeof(ul) = 8

  printf("char size: %lu, value: %d \n", sizeof(a), a);
  printf("unsigned char size: %lu, value: %d \n", sizeof(u_a), u_a);

  printf("short size: %lu, value: %d \n", sizeof(b), b);
  printf("unsigned short size: %lu, value: %d \n", sizeof(u_b), u_b);

  printf("integer size: %lu, value: %d \n", sizeof(c), c);
  printf("unsigned integer size: %lu, value: %d \n", sizeof(u_c), u_c);

  printf("float size: %lu, value: %f \n", sizeof(d), d);

  printf("long size: %lu, value: %ld \n", sizeof(l), l);
  printf("unsigned long size: %ld, value: %ld", sizeof(u_l), u_l);

  return 0;
}
