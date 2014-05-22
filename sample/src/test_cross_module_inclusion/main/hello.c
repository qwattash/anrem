/**
 * @file hello.c
 * a sample program
 * @author Alfredo Mazzinghi (qwattash)
 */

#include <stdio.h>
#include <stdlib.h>

/**
 * WARNING!!!
 * Q: calc.h is included as if it was in this directory! WHY?
 * A: beacause the make rule uses the correct dir as -I path
 * Q: but how can I include more than one .h with the same name but in
 * different paths?
 * A: ANREM gives the possibility to use less than the complete directory tree to the -I option
 * so you may use here "bla/calc.h" and tell anrem to strip the bla part from the -I option
 */
#include "calc/calc.h"
#include "calcmain.h"

int main(int argc, char* argv[])
{
  int x = prompt("gimme a number");
  printf("%s\n", "hello, world");
  printf("%d + 2 = %d\n", x, add(x, 2));
  return 0;
}
