/**
 * @file hello.c
 * a sample program
 * @author Alfredo Mazzinghi (qwattash)
 */

#include <stdio.h>
#include <stdlib.h>
#include "hello.h"

int main(int argc, char* argv[])
{
  int x = 100;
  printf("%s\n", hello);
  printf("%d + 2 = %d\n", x, x + 2);
  return 0;
}
