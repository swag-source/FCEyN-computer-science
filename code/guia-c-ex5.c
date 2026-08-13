#include <stdio.h>

int main() {

  float f = 0.1;
  double d = 0.1;

  printf("0.1 as float: %f \n", f);
  printf("0.1 as double: %f \n", d);

  printf("0.1 casted from float to int: %d \n", (int)f);
  printf("0.1 casted from double to int: %d \n", (int)d);

  return 0;
}
