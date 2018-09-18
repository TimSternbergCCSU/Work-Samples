#include <stdio.h>
#include <stdlib.h>
#include <curses.h>
#include <unistd.h>
#include <time.h>

#define C '0'

struct node {
  int y;
  int x;
  struct node *prev, *next;
};

struct node *head,*tail;
int dir,length,addNew=0,dead=0,won=0,x,y;
int trophy[] = {-1,-1,-1}; // element 0 = y, element 1 = x, element 3 = duration
unsigned long start;
struct timespec t, t2;

void printBorder(int maxy, int maxx) {
  int i,o;
  for(i=0; i<2; i++) {
    for(o=1; o<maxx-1; o++) {
      move(i*(maxy-1),o);
      addch('*');
    }
  }
  for(i=0; i<maxy; i++) {
    move(i,0);
    addch('*');
    move(i,maxx-1);
    addch('*');
  }
  refresh();
}

void placeSnake(int maxy, int maxx) {
  int rx = rand()%(maxx-6)+3, ry = rand()%(maxy-6)+3;
  move(ry,rx);

  struct node *Snake = malloc( sizeof(struct node) );
  Snake->x = rx;
  Snake->y = ry;
  Snake->next = NULL;
  Snake->prev = NULL;

  head = Snake;
  tail = Snake;

  addch(C);

  refresh();
}

int positionFilled(int y, int x) {
  struct node *t = head; while(t != NULL) {
    if(t->x == x && t->y == y)
      return 1;
    t = t->prev;
  }
  return 0;
}

void addTrophy() {
  int foundSpot,X,Y;
  X = rand()%(x-2)+1;
  Y = rand()%(y-2)+1;
  foundSpot = !positionFilled(Y,X);
  while(!foundSpot) {
    X = rand()%(x-2)+1;
    Y = rand()%(y-2)+1;
    foundSpot = !positionFilled(Y,X);
  }
  start = (unsigned long)time(NULL);
  int duration = rand()%9+5;
  trophy[0] = Y;
  trophy[1] = X;
  trophy[2] = duration;
  move(Y,X);
  addch('T');
  refresh();
}

void checkTrophy() {
  unsigned long currTime = (unsigned long)time(NULL);
  if(trophy[0] < 0)
    addTrophy();
  else if(currTime-start >= trophy[2]) {
    move(trophy[0],trophy[1]);
    addch(' ');
    addTrophy();
  }
}

void moveSnake() {
  struct node *newHead;
  int x = head->x;
  int y = head->y;

  if(dir == 0)
    x++;
  else if(dir == 1)
    x--;
  else if(dir == 2)
    y++;
  else
    y--;

  if(y==trophy[0] && x==trophy[1]) {
    addNew = 1;
    t.tv_nsec /= 1.2;
    addTrophy();
  }

  if(!addNew) {
    move(tail->y,tail->x);
    addch(' ');
    newHead = tail;
    tail = tail->next;
    if(tail==NULL) {
      tail=newHead;
      newHead->prev = NULL;
      newHead->next = NULL;
    }
    else {
      tail->prev = NULL;
      newHead->prev = head;
      head->next = newHead;
      addNew = 0;
    }
  }
  else {
    newHead = malloc( sizeof(struct node) );
    newHead->prev = head;
    head->next = newHead;
    addNew--;
  }
  newHead->next = NULL;
  head = newHead;

  head->x = x;
  head->y = y;
  move(y,x);
  addch(C);

  // Checking to see if the snake has eaten itself, and to see if we've won
  length=0;
  struct node *t = head; while(t != tail && !dead) {
    t = t->prev;
    if(t->x == head->x && t->y == head->y) dead = 1;
    length++;
  }

  if(!dead) {
    refresh();
  }
}

int main() {
  // Declaring variables
  srand(time(0));
  dir = rand()%4; // Direction of snake

  // Initialization
  initscr();
  start_color();
  init_pair(1, COLOR_MAGENTA, COLOR_BLACK);
  attron(COLOR_PAIR(1));
  clear();
  getmaxyx(stdscr,y,x);
  t.tv_sec  = 0;
  t.tv_nsec = 500000000L;
  t.tv_nsec /= 2;

  printBorder(y,x);
  placeSnake(y,x);

	noecho();
  nodelay(stdscr, 1);
  curs_set(0);
  while( head->x > 0 && head->y > 0 && head->x < x-1 && head->y < y-1 && !dead && !won) {

    if (getch() == '\033') { // if the first value is esc
        getch(); // skip the [
        switch(getch()) { // the real value
          case 'A': // arrow up
              dir = 3;
              break;
          case 'B': // arrow down
              dir = 2;
              break;
          case 'C': // arrow right
              dir = 0;
              break;
          case 'D': // arrow left
              dir = 1;
              break;
        }
    }

    nanosleep(&t , &t2);
    //addNew = 1; //(rand()%2 == 1);
    moveSnake();

    checkTrophy();
    won = length>=(x*2 + y*2)/2;
  }

  if(won) {
    move(y/2,x/2-14);
    addstr("WINNER WINNER CHICKEN DINNER");
  }
  else {
    move(y/2,x/2-6);
    addstr("RIP YOU LOSE");
  }
  refresh();
  sleep(7);
  endwin();
  return 0;
}
