#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"

extern char buffer[132]; 
extern actor hero;
extern actor monster;

void leftChoice( int monsterHit,  int monsterStr );
void rightChoice( int monsterHit,  int monsterStr );

void scene04( int monsterHit, int monsterStr )
{

  printf("  You continue deeper into the mine.\n\n");
  printf("  The tunnel splits into two passeges. Which one do you take? Left or Right? (enter L or R): ");
  gets( buffer );

  if ( buffer[0] == 'L' || buffer[0] == 'l' )
  {
    leftChoice( monsterHit, monsterStr );
  }
  else
  {
    rightChoice( monsterHit, monsterStr );
  }

}

void leftChoice( int monsterHit,  int monsterStr )
{
  printf("\n\n  You see a sign in front of an orange bag:\n");
  printf("\t  Trick or Treat!!\n\n");
  printf("  Do you put a piece of gold in the bag? (y or n)");
  gets( buffer );

  if ( buffer[0] == 'y' || buffer[0] == 'Y' )
  {
    hero.gold-- ;
    printf("  Wise choice.  You continue down the tunnel.\n");
  }
  else
  {
    printf("  Oh No!! You have angered the Great Pumpkin!!\n");
    makeActor( &monster, "Great Pumpkin", monsterHit, monsterStr, 0);
    printf("\n");
    sortie( );
  }
}


void rightChoice( int monsterHit,  int monsterStr )
{
  printf("  You find 10 gold pieces\n");
  hero.gold += 10;
}

 