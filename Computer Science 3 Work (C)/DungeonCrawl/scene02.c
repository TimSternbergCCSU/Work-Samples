#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

/* Scene 02 */

extern char buffer[132];   /* external:  there is really only one of these */
extern actor hero;
extern actor monster;

void scene02( int monsterHit, int monsterStr )
{
  printf("  You go deeper into the mine.\n\n");

  printf("  You find a small chest. ");
  printf("  On the chest is an inscription in a mystical language:\n");
  printf("  if (rand()%%6 == 0) death=1; ");
  printf("  Do you wish to open the box? (y or n): ");
  gets( buffer );

  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
  {
    int toss = rand()%6;

    if ( toss == 0 )
    {
      printf("  You open the box. A burst of poison gas hits you. You die.\n");
      hero.hitPoints = 0;
    }
    else if ( toss == 1 )
    {
      printf("  You open the box and find it empty.\n");
      printf("  You hear a snicker in the distance.\n");
    }
    else if ( toss == 2 )
    {
      printf("  You find a Purple magic potion.\n" );
      printf("  Do you drink the potion? (y or n): ");
      gets( buffer );
      if ( buffer[0] == 'y' || buffer[0] == 'Y' )
      {
        printf("  Your hit points are restored.\n");
        hero.hitPoints = hero.maxHitPoints;
      }
    }
    else if ( toss == 3 )
    {
      printf("  You find a Red magic potion.\n" );
      printf("  Do you drink the potion? (y or n): ");
      gets( buffer );
      if ( buffer[0] == 'y' || buffer[0] == 'Y' )
      {
        printf("  Your strength is increased.\n");
        hero.maxStrength = hero.maxStrength+1;
      }
    }
    else if ( toss == 4 )
    {
      printf("  You find a Yucky Green magic potion.\n" );
      printf("  Do you drink the potion? (y or n): ");
      gets( buffer );
      if ( buffer[0] == 'y' || buffer[0] == 'Y' )
      {
        printf("  You feel ill.\n");
        hero.maxStrength = hero.maxStrength-1;
      }
    }
    else
    {
      printf("  You find a Orange magic potion.\n" );
      printf("  Do you drink the potion? (y or n): ");
      gets( buffer );
      if ( buffer[0] == 'y' || buffer[0] == 'Y' )
      {
        printf("  Nothing Happens\n");
      }
    }
  }
}
