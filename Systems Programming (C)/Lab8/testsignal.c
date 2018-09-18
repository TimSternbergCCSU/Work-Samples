#include <stdio.h>
#include <signal.h>
#include <unistd.h>

int isPrime(int);
void pauseF(int);             /* declare the handler     */
int pauseSignal=0;

int main() {
  char c=0;
  int prime=0,i=0;
  signal(SIGINT, pauseF);        /* install the handler     */
  while(1) {
    if(pauseSignal){
      printf("\n%i\tQuit [y/n]? ",prime);
      c = getchar();
      if(c=='\n') c=getchar();
      if((c=='y') || (c=='Y'))
        break;
      else
        pauseSignal=0;
      c=0;
    }
    else if(isPrime(i) ) {
      //printf("%i\n",prime);
      prime = i;
    }
    sleep(0.01);
    i++;
  }

  return 0;
}

int isPrime(int i) {
  int k;
  int prime=1;
  for(k=2; i/2>k; k++) {
    if(i%k == 0) {
      prime = 0;
      break;
    }
  }
  return prime;
}

void pauseF(int signum) {         /* this function is called */
   pauseSignal = 1;
}
