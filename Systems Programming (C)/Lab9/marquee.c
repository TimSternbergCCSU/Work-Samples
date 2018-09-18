#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <curses.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <math.h>

#define BUFFERSIZE 124

// gcc -o marquee marquee.c -lncurses

void adjustBuffer(char *buf, char nextchar, int n_chars) {
  char temp_buf[n_chars+1];
  memcpy(temp_buf, buf, n_chars);
  int i=n_chars-1;
  while(i>0) {
    buf[i-1] = temp_buf[i];
    i--;
  }
  buf[n_chars-1] = nextchar;
}

int main(int ac, char *av[]) {
  int n_chars,src,length,row,col,speed;

  if (ac < 5){ /* need at least the source file */
    printf("Invalid parameters. Please enter in the format:\n$ ./marquee file_name row col speed (length)\n");
    return 1;
  }
  if ((src=open(av[1], O_RDONLY)) == -1) {
    perror("Cannot open source file");
    return 1;
  }

  initscr();
  clear();

  char*end;
  row = strtol(av[2],&end,10);
  col = strtol(av[3],&end,10);
  speed = strtol(av[4],&end,10);
  if(ac==6)
    length = strtol(av[5],&end,10);
  else {
    int row=0;
    getmaxyx(stdscr,row,length);
    length = length - col;
  }

  char buf[length+1];
  buf[length] = '\0';

  if((n_chars = read(src, buf, length)) == length) {
    int i;
    for(i=0; i<BUFFERSIZE; i++) {
      if(buf[i] == '\n')
        buf[i] = ' ';
    }
    addstr(buf); //printf("%s\n",buf);
    refresh();
    char nextchar[BUFFERSIZE];
    int charsread;
    while ((charsread = read(src, nextchar, BUFFERSIZE)) > 0) {
      for(i=0; i<BUFFERSIZE; i++) {

        if(nextchar[i] == '\n') nextchar[i] = ' ';
        if(n_chars>charsread) n_chars=charsread;

        usleep( 10000000 / (speed*10) );
        adjustBuffer(buf,nextchar[i],n_chars);
        clear();
        move(row,col);
        addstr(buf); //printf("%s\n",buf);
        refresh();
      }
    }
  }

  endwin();
  return 0;
}
