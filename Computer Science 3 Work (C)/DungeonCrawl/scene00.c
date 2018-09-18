#include <stdio.h>
#include <stdlib.h>
#include "actor.h"
#include "utilities.h"
 
extern actor hero;

/* Easy first scene  
*
*  monsterHit and monsterStr are the hit points and strength of
*  a monster that might be created in a scene.  But this scene
*  does not use these parameters.
*
*/

void scene00( int monsterHit, int monsterStr )
{
  printf("\n\n  You enter the mine and walk a few feet.\n");
  printf("  You find a piece of gold and pick it up.\n");
  hero.gold += 1;
  printf("  It makes a pleasant clink in your bag of treasure.\n");
  printf("\n");
  printf("  You continue walking into the mine.\n");
  printf("\n  Everything is fine, so far.\n\n\n");
}
