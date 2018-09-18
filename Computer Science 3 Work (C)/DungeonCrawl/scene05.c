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
extern actor hero;
extern actor monster;

void PickupSword( int monsterHit,  int monsterStr );
void IgnoreSword( int monsterHit,  int monsterStr );
void FindChest( int monsterHit,  int monsterStr );
 
void scene05( int monsterHit, int monsterStr )
{

	printf("  You continue deeper into the mine.\n\n");
	printf("  Suddenly you trip over something heavy! (Hit enter)");
	gets( buffer ); 
	printf("  It's a bluesteel sword! Do you pick it up? (y or n):");
	gets( buffer );
  
	if ( buffer[0] == 'Y' || buffer[0] == 'y' )
	{
		PickupSword( monsterHit, monsterStr );
	}
	else
	{
		IgnoreSword( monsterHit, monsterStr );
	}
  
}

void FindChest( int monsterHit,  int monsterStr )
{
	int toss = randInt( 1, 4 );
	if (toss == 1)
	{
		printf("  There's nothing in there. Oh well! You move on\n");
	}
	else /* 3/4 chance that the hero gets gold */
	{
		printf("\n  You see a large chest covered in dust. Do you open it? (y or n):");
		gets( buffer );
		
		if ( buffer[0] == 'Y' || buffer[0] == 'y' )
		{
			int MoneyGained = randInt(1,60);
			printf("  Awesome! You gained %d gold! You pocket it and move on\n",MoneyGained);
		}
		else
		{
			printf("  You decide it looks a bit spooky. You move on\n");
		}
	}
}

void PickupSword( int monsterHit,  int monsterStr )
{
	printf("\n  As you pick it up, you feel an enormous strength running through your veins!\n");
	hero.maxStrength = hero.maxStrength+2;
	hero.strength = hero.maxStrength;
	printf("  Your strength increases! (Hit enter)");
	gets( buffer ); 
	printf("\n  You continue to hold the sword, and it suddenly gets so bright that the entire mine is lit up\n");
	printf("  Do you look to your left or right? (L or R):");
	gets( buffer );

	if ( buffer[0] == 'L' || buffer[0] == 'l' )
	{
		FindChest( monsterHit, monsterStr );
	}
	else
	{
		printf("  You find nothing. Dissapointed, you move on\n");
	}
}

void FindArmor( int monsterHit, int monsterStr )
{
	printf("\n  You put it on, and realize it's even more comfortable than it looks!\n");
	printf("  Suddenly you feel as healthy as a horse.\n");
	if (hero.hitPoints != hero.maxHitPoints)
	{
		printf("  Your hit points are fully restored, and also increase!");
	}
	else
	{
		printf("  Your HP increases! (Hit enter)");
	}
	hero.maxHitPoints = hero.maxHitPoints+2;
	hero.hitPoints = hero.maxHitPoints;
}

void IgnoreSword( int monsterHit,  int monsterStr )
{
	printf("\n  Deciding that it looks a bit spooky, you get up and turn around\n");
	printf("  However you spot some sweet looking armor! Do you wear it? (y or n):");
	gets( buffer );
	
	if ( buffer[0] == 'Y' || buffer[0] == 'y' )
	{
		FindArmor( monsterHit, monsterStr );
	}
	else
	{
		printf("  You decide that armor looks pretty spooky too. You move on\n");
	}
}