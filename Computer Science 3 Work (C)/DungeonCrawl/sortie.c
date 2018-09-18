#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "scenes.h"
#include "utilities.h"

/* A fight between the hero and a  monster
|
|  The fight continues until one contestant is dead or
|  the hero runs away.
|
*/
extern char buffer[132];
extern actor hero;
extern actor monster;

void sortie()
{
  int monsterThrow, heroThrow;
  int bothAlive = 1;
  int runAway   = 0;

  while ( bothAlive && !runAway )
  {
    printf("\n\n\tWhat do you wish to do? (f fight, r run away, d duck) ");
    gets( buffer );
    system( "cls" );

    /* Hero Fights the Monster */
    if ( buffer[0] == 'f' || buffer[0] == 'F' )
    {
      printf("\n\n\tYou attack the %s\n\n", monster.name );
      monsterThrow = randInt( 1, monster.strength );
      heroThrow    = randInt( 1, hero   .strength );

      if ( heroThrow == monsterThrow )
      {
        printf("\tYou swing and miss.\n");
        printf("\tThe %s swings and misses.\n\n", monster.name );
      }
      else if ( heroThrow > monsterThrow+2 )
      {
        printf("\tWHAMO!! You hit the monster hard.\n");
        printf("\tThe %s looses two hit points.\n\n", monster.name );
        monster.hitPoints -= 2;
      }
      else if ( heroThrow > monsterThrow)
      {
        printf("\tBAM!! You swing and hit.\n");
        printf("\tThe %s looses a hit point.\n\n", monster.name );
        monster.hitPoints--;
      }
      else if ( heroThrow < monsterThrow-2 )
      {
        printf("\tOUCH OUCH OUCH!! The %s hits you.\n", monster.name);
        printf("\tYou loose two hit point.\n\n");
        hero.hitPoints -= 2;
      }
      else 
      {
        printf("\tOOF!! The %s hits you.\n", monster.name);
        printf("\tYou loose a hit point.\n\n");
        hero.hitPoints--;
      }
    }

    /* Hero Runs Away */
    else if ( buffer[0] == 'r' || buffer[0] == 'R' )
    {
      printf("\n\tYou run away from the %s.\n", monster.name);
      printf("\tThe %s throws a shurikin at your back!!\n", monster.name);
      monsterThrow = randInt( 1, 4 );
      if ( monsterThrow > 3 )
      {
        printf("\tIt hits! You lose a hit point\n");
        hero.hitPoints-- ;
      }
      else
        printf("\tIt misses.\n");
      runAway = 1;
    }

    /* Hero Ducks the Monster's Blow */
    else
    {
      printf("\n\n\tYou duck from the monster's blow.\n");
      monsterThrow = randInt( 1, monster.strength );
      heroThrow    = randInt( 1, hero   .strength );

      if ( hero.hitPoints < hero.maxHitPoints && heroThrow > 3*monsterThrow/4 )
      {
        printf("\tThe %s misses.\n\n", monster.name );
        printf("\tYour tricky move gains you a hit point!!!\n");
        hero.hitPoints++;
      }
      else if ( heroThrow > monsterThrow/2 )
      {
        printf("\tThe %s misses.\n\n", monster.name );
      }
      else
      {
        printf("\tThe %s hits you anyway.\n", monster.name);
        printf("\tYou loose a hit point!\n\n");
        hero.hitPoints--;
      }
    }

    /* Determine the outcome of this exchange of blows */
    if ( hero.hitPoints <= 0 )
    {
      printf("\n\t\t\tYou moan... and die...\n\n");
      bothAlive = 0;
    }
    else  if ( monster.hitPoints <= 0 )
    {
      printf("\tThe %s drops dead.\n\n", monster.name );
      bothAlive = 0;
    }
    summary ( );
    
    /* The monster hears its mommy calling */
    if ( monster.hitPoints > 0 && monster.hitPoints < hero.hitPoints && randInt( 1, 10 ) == 1 )
    {
      runAway = 1;
      printf("\n\t\tThe %s turns tail and runs away!\n\n", monster.name);
    }
    
  } /* end while */

  /* Final Result of the Sortie */
  if ( !runAway && hero.hitPoints > 0 )
  {
    printf("\n\n\tYou gain strength from your experience\n");
    hero.strength++ ;
    hero.maxStrength++ ;
    heroSummary( );
	  printf("\n");
  }

}
