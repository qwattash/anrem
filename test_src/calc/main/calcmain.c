/**
 * @file calcmain.c
 * this is an example of name conflicting module
 * @author Alfredo Mazzinghi
 */

#include "calcmain.h"

/**
 * ask for a number
 * @param str prompt string
 * @returns number
 */
int prompt(char* str)
{
  printf("%s:", str);
  int x = 0;
  scanf("%d", &x);
  return x;
}
