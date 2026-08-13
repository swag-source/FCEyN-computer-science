#include <stdio.h>
#include <stdlib.h>

void array_shift(int *a, int shift, int a_size) {
  int arr_res[a_size];

  for (int i = 0; i < a_size; i++) {
    arr_res[i] = a[(i + shift) % (a_size)];
    printf("%d", arr_res[i]);
  }
}

int main() {
  int n = 4;
  int *a = calloc(n, sizeof(int));
  for (int i = 0; i < n; i++) {
    a[i] = i + 1;
  }
  int shift = 2;
  array_shift(a, shift, n);
  return 0;
}
