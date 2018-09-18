#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

extern char buffer[132];   /* external:  there is really only one of these */
void scene01part2();

/* First fight scene */
extern actor hero;
extern actor monster;

void scene01(int monsterHit, int monsterStr )
{
  printf("  What is that fluttering sound?\n");
  printf("  OH NO! It's a saber-tooth bat!\n");
  
  makeActor( &monster, (char *)"Bat", monsterHit, monsterStr, 0);
  monsterSummary();
  printf("\n");
  
  sortie();
  if ( monster.hitPoints<=0 && hero.hitPoints>0 )
    scene01part2();
}

void scene01part2()
{
  printf("  The dead bat lies at your feet.\n");
  printf("  Is that some gold in its teeth?\n");
  printf("  Do you wish to pry the gold from the bat's teeth? (y or n): ");
  gets( buffer );

  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
  {
    int toss = randInt( 1, 12 );

    if ( toss < 5 )
    {
      printf("  The bat is not quite dead!\n It bites! You die of rabies.\n");
      hero.hitPoints = 0;
    }
    else
    {
      printf("  Where did the bat ever get %2d pieces of gold?\n", toss );
      printf("  You pocket the gold and move on.\n\n");
      hero.gold += toss;
    }
  }
}
