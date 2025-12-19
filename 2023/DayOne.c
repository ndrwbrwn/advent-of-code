#include <stdio.h>
#include <stdint.h>

void main(void) {
  char *line = NULL;
  size_t size = 0;

  int first = -1;
  int last = 0;

  int total = 0;

  while (getline(&line, &size, stdin) != -1) {
    for (int i = 0; line[i] != '\0'; i++) {
      register int64_t next5 = (*(int64_t*)(line + i)) & 0xFFFFFFFFFF;
      register int32_t next4 = next5 & 0xFFFFFFFF;
      register int32_t next3 = next5 & 0xFFFFFF;
      register char next1 = next5 & 0xFF;

      if (next3 == 0x656E6F || next1 == 0x31) {
        last = 1;
      } else if (next3 == 0x6F7774 || next1 == 0x32) {
        last = 2;
      } else if (next5 == 0x6565726874 || next1 == 0x33) {
        last = 3;
      } else if (next4 == 0x72756F66 || next1 == 0x34) {
        last = 4;
      } else if (next4 == 0x65766966 || next1 == 0x35) {
        last = 5;
      } else if (next3 == 0x786973 || next1 == 0x36) {
        last = 6;
      } else if (next5 == 0x6E65766573 || next1 == 0x37) {
        last = 7;
      } else if (next5 == 0x7468676965 || next1 == 0x38) {
        last = 8;
      } else if (next4 == 0x656E696E || next1 == 0x39) {
        last = 9;
      }

      if (first == -1) first = last;
    }
    
    total += (first * 10) + last;
    first = -1;
    last = -1;
  }

  printf("%i\n", total);
}
