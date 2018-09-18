#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

extern actor hero;
char buffer[132];   /* external:  there is really only one of these */

/* Magic Potion Scene
|
|  The Hero finds a magic potion and, based on color, decides
|  whether to drink it.  Things may happen.
|
*/

/* Initially, potion zero is increase hit points, potion 1 is restore hitpoints, ...
|  But this is immediately scrambled.
|
*/
static int potions[] = {0, 1, 2, 3}; /* increase, restore, neutral, poison */
static int potionInit = 0;

void potionScene()
{
	int toss, tossA, tossB, temp, j;

	/* Determine lucky potions for this game (done just once) */
	if ( !potionInit )
  {
    potionInit = 1;
    for ( j=0; j<3; j++ )
    {
	    tossA = randInt(0,3);
	    tossB = randInt(0,3);
      temp = potions[ tossA ];
      potions[ tossA ] = potions[ tossB ];
      potions[ tossB ] = temp;
    }
  }

  /* What does the Hero see? */
	toss = randInt(0,3);
	printf("  You find a ");
	if ( toss == 0 ) printf("puce ");
	if ( toss == 1 ) printf("green ");
	if ( toss == 2 ) printf("red ");
	if ( toss == 3 ) printf("yellow ");
	printf("potion.  Do you wish to drink it? (y/n)");
	gets( buffer );

  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
	{
	  if ( toss == potions[0] )
	  {
	    printf("  This tastes great!\n");
	    printf("  Your max hitpoints increase!\n");
		  hero.maxHitPoints += randInt(1,3);
	  }
	  else if ( toss == potions[1] )
	  {
	    printf("  It tastes like maple syrup.\n");
	    printf("  You feel warm all over.\n");
	    printf("  Your hitpoints are restored!\n");
		  hero.hitPoints  = hero.maxHitPoints;
	  }
	  else if ( toss == potions[2] )
	  {
	    printf("  It tastes like warm apple juice.\n");
	    printf("  Nothing happens.\n");
	  }
	  else
	  {
	    printf("  It tastes like yellow snow.\n");
	    printf("  This is not good.\n");
		  hero.hitPoints-- ;  
      hero.maxHitPoints-- ;
	  }
	}

}
