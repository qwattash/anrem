#include "hello.h"
#include <stdlib.h>

char* names[3] = {"Alice", "Bob", "Carl"};

char* randname(){
  time_t t;
  srand((unsigned) time(&t));
  return names[rand() % 3];
};
