#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "actor.h"
#include "scenes.h"
#include "utilities.h"

extern char buffer[132];   /* general purpose scratch area */

actor hero ;      /* The hero object    -- constantly updated by the game */
actor monster ;   /* The monster object -- constantly updated by the game */

/* Generate a random integer  min <= r <= max
|
|  max-min+1 should be no larger than 65535
|
*/
int randInt( int min, int max )
{
  int num;
  num = rand()%(max-min+1) + min ;
  return num;
}

/* Fill in the members of an actor struct.  Used for both Hero and Monsters */
void makeActor(actor *act, char *name, int hitPoints, int strength, int gold)
{
  strcpy( act->name, name );
  act->hitPoints = hitPoints; act->maxHitPoints = hitPoints;
  act->strength  = strength;  act->maxStrength  = strength;
  act->gold = gold;
}

/*  Summary of the status of the Hero and the current Monster. */ 
void heroSummary()
{
  printf("  Hero   : %1d/%1d HP; %1d/%1d ST; %1d Gold\n",
    hero.hitPoints, hero.maxHitPoints,
    hero.strength,  hero.maxStrength, hero.gold );
}

void monsterSummary()
{
  printf("  Monster: %1d/%1d HP; %1d/%1d ST\n",
    monster.hitPoints,  monster.maxHitPoints,
    monster.strength,   monster.maxStrength);
}

void summary()
{
  heroSummary();
  monsterSummary();
}

/* Scene Selector
|
|  Additional scenes will be added as they are created.
|
*/
void sceneSelect( int scene )
{
  if      ( scene== 0 ) scene00(  0, 0 );  /* monster-hitpoints, monster-strength  */
  else if ( scene== 1 ) scene01(  2, 2 );
  else if ( scene== 2 ) scene02(  0, 0 );
  else if ( scene== 3 ) scene03(  3, 3 );
  else if ( scene== 4 ) scene04(  5, 5 );
  else if ( scene== 5 ) scene05(  7, 7 );
  else if ( scene== 6 ) scene06(  9, 5 );

  else
  {
    fprintf( stderr, "No such scene number %d\n", scene );
  }
}

int main ( int argc, char** argv )
{
  int scene = 0;  /* The current scene number */
 
  /* Splash Screen */
  system("cls");  /* Clear the screen.  May not work on all systems. */
  splash();

  printf(" \n\n           (Hit enter)"); 
  gets( buffer ); 
  system("cls");   
 
  /* Create the Hero and start the Game */
  srand( time(NULL) );
  makeActor( &hero, (char *)"dummy", 4, 4, 0);
  intro();
 
  /* Explore the dungeon scene by scene */
  while ( hero.hitPoints > 0 && scene <= MAXSCENE )
  {
    
    printf("\n\n  (Hit enter)"); 
    gets( buffer ); 
    system("cls");
    printf("\n\n\n      **** scene %d *****\n\n", scene );
    heroSummary();   

    /* Go to the current scene */
    sceneSelect( scene );

    /* If hit points are low, place a magic potion in the Hero's path */
	  if (  hero.hitPoints > 0 && hero.hitPoints < scene/4 + 2  ) 
      potionScene();

	  /* Advance the scene by a random amount, to be adjusted when there are more scenes */
    /* scene +=  randInt(1,4); */
    scene += 1;

  }
 
  /* End of Game Summary */
  if ( hero.hitPoints <= 0 )
  {
    printf("\n\nYou Lose.\n");
    rip( hero.name );
  }
  else
  {
    printf("\n\n  You reach the end of the mine and find 100 pieces of gold\n\n");
    printf("  You now have %2d pieces of gold and have WON the game.\n\n", hero.gold+=100 );
    printf("            (Hit enter)"); 
    gets( buffer ); 
    system("cls");
    winner( hero.gold );
    printf("\n\n\n            (Hit enter)"); 
    gets( buffer );
  }

}
