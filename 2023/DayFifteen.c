#include <stdio.h>
#include <stdint.h>

void main(void) {
  int sum = 0;
  int current = 0;
  char c;

  while ((c = fgetc(stdin)) != EOF) {
    switch (c) {
      case '\n':
        continue;
      case ',':
        sum += current;
        current = 0;
        continue;
      default:
        current = ((current + c) * 17) % 256;
        continue;
    }
  }

  printf("%i\n", sum);
}
