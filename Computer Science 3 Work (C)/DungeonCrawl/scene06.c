/* CS 153 PROGRAM 9 Dungeon Crawl
 AUTHOR: Tim Sternberg
 DATE: 4/08/17
 DESCRIPTION: Add scenes 05 and 06 to Dungeon Crawl
*/

#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

extern char buffer[132]; 
void scene06part2();

extern actor hero;
extern actor monster;
 
void scene06( int monsterHit, int monsterStr )
{

	printf("  You continue deeper into the mine");
  
	printf("\n\n  What's that hissing noise?\n");
	printf("  Geepers! It's a Slimy Slithering Sanguine Snake!! (Hit enter)");
	gets( buffer ); 
	
	makeActor( &monster, (char *)"Slimy Slithering Sanguine Snake", monsterHit, monsterStr, 0);
	monsterSummary();
	printf("\n");
  
	sortie();
	if ( monster.hitPoints<=0 && hero.hitPoints>0 )
		scene06part2();
}

void scene06part2()
{
  printf("  The dead Sanguine Snake makes one final hiss at you, and then curls up and dies.\n");
  printf("  You give it a good long look, and contemplate opening it up to look for treasure\n");
  printf("  Do you want to cut it open to look for loot? (y or n): ");
  gets( buffer );

  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
  {
    int toss = randInt( 1, 20 );

    if ( toss < 7 )
    {
      printf("  Venom starts to pour out of the snake, so you throw it against the wall\n");
    }
    else
    {
      printf("  %2d gold falls out of the snakes innards! What the heck?\n", toss );
      printf("  You pocket the gold and move on.\n\n");
      hero.gold += toss;
    }
  }
  else
	  printf("  Ew why would anyone want to cut open a snake?!\n");
}
