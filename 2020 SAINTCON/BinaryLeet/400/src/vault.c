#include <stdio.h>

int main() {
  // here is your secret - passphrase
  // you_found_the_flag! - flag
  int offset[20] = { 17, 10, 3, -6, 70, 6, 2, 78, -21, -16, 
										 -1, -10, 69, -20, 1, 9, -17, 2, -83};
  char input[20]; 

  printf("Passphrase: ");
  fgets(input, sizeof(input), stdin);             

  for (int i=0; i<20; i++) {
    input[i] = input[i] + offset[i];
  }

  printf("Possible flag... ;)");
  printf("\nflag{%s}\n", input);

  return 0;
}