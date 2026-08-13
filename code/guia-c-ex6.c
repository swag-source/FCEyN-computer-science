#include <stdio.h>
int main() {
  int secret_msg[] = {116, 104, 101, 32,  103, 105, 102, 116, 32,  111, 102,
                      32,  119, 111, 114, 100, 115, 32,  105, 115, 32,  116,
                      104, 101, 32,  103, 105, 102, 116, 32,  111, 102, 32,
                      100, 101, 99,  101, 112, 116, 105, 111, 110, 32,  97,
                      110, 100, 32,  105, 108, 108, 117, 115, 105, 111, 110};
  int n = sizeof(secret_msg) / sizeof(int);
  char decoded[n];

  for (int i = 0; i < n; i++) {
    decoded[i] = (char)secret_msg[i];
  };

  for (int i = 0; i < n; i++) {
    printf("%c", decoded[i]);
  }

  return 0;
}
