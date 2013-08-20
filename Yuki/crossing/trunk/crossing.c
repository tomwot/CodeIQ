#include<stdio.h>
#include<stdlib.h>
#include<time.h>

#define NUM 314160

unsigned long crossing[NUM];

int main(void) {
  unsigned long sum1, sum2;
  char nod[80];
  unsigned long node;
  time_t start, finish;
  int i;

  time(&start);

  sum1 = sum2 = 0;
  while (fgets(nod, sizeof(nod), stdin) != NULL) {
    node = atoi(nod);
    sum2 += crossing[node];
    sum1 += sum2 / 100000000;
    sum2 %= 100000000;

    for (i = 1; i < node; i++) {
      crossing[i]++;
    }
  }
  time(&finish);
  printf("%lu%lu\n", sum1, sum2);
  printf("Time: %ld\n", finish - start);
}
