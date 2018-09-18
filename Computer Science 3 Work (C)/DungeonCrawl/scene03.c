#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

/* Scene 03 */

extern char buffer[132];   /* external:  there is really only one of these */
extern actor hero;
extern actor monster;

void scene03part2()
{
  printf("  The dead mouse lies at your feet.\n");
  printf("  You feel like kicking it into the darkness.\n");
  printf("  Do you kick the dead mouse? (y or n):");
  gets( buffer );
  
  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
  {
    int toss = randInt( 1, 12 );

    if ( toss < 3 )
    {
      printf("\n  Your actions show disrespect for the fallen. ");
      printf("  You loose a hit point.\n");
      hero.hitPoints -= 1;
    }
 
    if ( toss >= 3 && toss <= 10 )
    {
      printf("\n  The mouse vanishes into the darkness.\n");
    }
    else
    {
      printf("\n  The corpse bursts open, spilling %3d gold coins!\n", toss );
      printf("  You pocket the gold and move on.\n\n");
      hero.gold += toss;
    }
  }
}

void scene03( int monsterHit, int monsterStr )
{
  printf("\n  You continue deeper into the mine\n");
  printf("  What is THAT??  A mouse! \n\n");
  
  makeActor( &monster, (char *)"Mouse", monsterHit, monsterStr, 0);
  monsterSummary();
  printf("\n");

  sortie();
  if ( hero.hitPoints > 0 && monster.hitPoints <= 0 )
    scene03part2();
}
