#include <stdio.h>

int main() {
  int arr[] = {1, 2, 3, 4};
  int n = sizeof(arr) / sizeof(int);
  int arr_res[n];
  for (int i = 0; i < n; i++) {
    arr_res[i] = arr[(i + 1) % (n)];
    printf("%d", arr_res[i]);
  };

  return 0;
}
