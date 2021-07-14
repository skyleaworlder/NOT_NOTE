#include <stdio.h>

struct A {
  int a;
  double b;
  char c;
} __attribute__ ((packed));

int main() {
  printf("%d\n", sizeof(struct A));
}