#include <stdio.h>
#include <stdlib.h>

int main() {
  long iterations = 60000000;
  int dice[] = {0, 0, 0, 0, 0, 0};
  int face = 0;
  for (int i = 0; i < iterations; i++) {
    face = rand() % 6;
    dice[face] = dice[face] + 1;
  }

  for (int i = 0; i < 6; i++) {
    printf("%d\n", dice[i]);
  }
}
