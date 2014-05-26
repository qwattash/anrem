/**
 * @file hello.c
 * a sample program
 * @author Alfredo Mazzinghi (qwattash)
 */

#include <stdio.h>
#include <stdlib.h>
#include "hello.h"

const char* hello = "Hello World";
const int a = 20;

int main(int argc, char* argv[])
{
  int x = 100;
  printf("%s\n", hello);
  world();
  printf("%d + 2 = %d\n", x, x + 2);
  sayname(randname());
  return 0;
}
