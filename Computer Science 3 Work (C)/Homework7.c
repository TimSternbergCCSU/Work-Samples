/* CS 153 PROGRAM 7 Chutes and Ladders
 AUTHOR: Tim Sternberg
 DATE: 3/13/17
 DESCRIPTION: Create a single player game of Chutes and Ladders
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int throwDie()
{
	static int initialized = 0;
	int num;
	
	if ( !initialized )
	{
		srand( time(NULL) );
		initialized = 1;
	}
	num = rand()%6 + 1 ;
	return num;
}

int main()
{
	/* First element is null, since we're not using it */
	int data[101] = {NULL,38,0,0,14,0,0,0,0,31,0,0,0,0,0,0,6,0,0,0,0,42,0,0,0,0,0,0,84,0,0,0,0,0,0,0,44,0,0,0,0,0,0,0,0,0,0,26,0,11,0,67,0,0,0,0,53,0,0,0,0,0,19,0,60,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,100,0,0,0,0,0,0,24,0,0,0,0,0,73,0,75,0,0,78,0,0};
	int moves = 0;
	int position = 0;
	
	while (position != 100)
	{
		int roll = throwDie();
		printf("Roll: %d\n",roll);
		
		if (position+roll <= 100)
		{
			position = position + roll;
			printf("   You advance to square %d\n",position);
			
			if (data[position] > position)
			{
				printf("   Great! You land on a ladder and climb to square %d\n",data[position]);
				position = data[position];
			}
			else if (data[position] != 0 && data[position] < position)
			{
				printf("   Oh No! You land on a chute and slide to square %d\n",data[position]);
				position = data[position];
			}
		}
		else
			printf("   Your roll would exceed position 100. You did not move\n");
		
		moves++;
		
		fflush( stdout );
		getchar();
	}
	
	printf("You reached the goal in %d moves!",moves);
}