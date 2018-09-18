#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "actor.h"
#include "scenes.h"
#include "utilities.h"

extern char buffer[132];   /* external:  there is really only one of these */
extern actor hero;

void intro()
{
  printf("\n\n\n\n");
  printf("  You approach a ruined dwarven mine, ");
  printf("  rummored to be filled with lost treasure, \n");
  printf("  but guarded by ");
  printf("monsters dangerous and most foul.\n\n");
  printf("  None but the brave dare enter.\n\n");
  
  printf("  Do you wish to continue? (y or n) ");
  gets( buffer );

  if ( buffer[0] != 'y' && buffer[0] != 'Y' )
  {
    printf("  You turn tail and run. ");
    printf("  From the trees around you, wood nymphs giggle derisively.\n\n");
    printf("  In your panic, you step on a bear trap and die.\n");
    hero.hitPoints = 0;
    strcpy( hero.name, "Coward" );
  }
  else
  {
    printf("  Spoken like a true Hero!\n");
    printf("  Enter your name, Hero: ");
    gets( buffer );
    while ( strlen( buffer ) < 4 )
    {
      printf("  You call *that* a name for a Hero? Try again: ");
      gets( buffer );
    }
    printf("\n  Now *thats* a Heroic name\n");
    strcpy( hero.name, buffer );
  }
}
