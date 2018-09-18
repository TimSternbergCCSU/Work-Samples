/*
// CS 153 PROGRAM ASSIGNMENT #4
//
// Dice Game
//
// Tim Sternberg
//
// Due 2/18/17
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

char input[132];   /* user input buffer */
int PlayerThrewAgain=0; /* Variable used to identifiy whether the player threw a second time. ==1 if so. ==0 if not. Declared with global scope so multiple methods can access it */

int throwDie()
{
	static int initialized = 0;
	int num;
	
	if ( !initialized )
	{
		/* printf("Initializing Die!!!\n\n"); */
		srand( time(NULL) );
		initialized = 1;
	}
	num = rand()%6 + 1 ;
	return num;
}

int GreatestOfThree(int a, int b, int c) /* A pure function which returns the greatest of three values */
{
	if (a >= b && a >= c)
		return a;
	else if (b >= c)
		return b;
	else
		return c;
}

int humanTurn()
{
	char answer;
	int toss1,toss2,toss3;
	int greatest;
	
	printf("Player's Turn: (hit enter)");
	fflush( stdout );
	gets( input ); /* pause for dramatic effect */
	
	toss1 = throwDie();
	toss2 = throwDie();
	toss3 = throwDie();
	printf("You throw: %d, %d, %d\n",toss1,toss2,toss3);
	greatest = GreatestOfThree(toss1,toss2,toss3);
	printf("The maximum is %d\n",greatest );
	
	printf("Do you wish to throw again? [Y or N] ");
	fflush( stdout );
	answer = getchar(); /* scanf("%c",&answer); */
	
	if (answer == 'Y' || answer == 'y')
	{
		PlayerThrewAgain = 1; /* Setting ==1 so that when it's the computer's turn, it knows that the playered rolled again */
		toss1 = throwDie();
		toss2 = throwDie();
		toss3 = throwDie();
		printf("You throw: %d, %d, %d\n",toss1,toss2,toss3);
		greatest = GreatestOfThree(toss1,toss2,toss3);
		printf("Your final score is %d\n",greatest);
	}
	else;
	
	return greatest;
}

int computerTurn()
{
	int toss1,toss2,toss3,toss4;
	int greatest;
	
	printf("\nComputer's Turn:\n");
	
	toss1 = throwDie();
	toss2 = throwDie();
	toss3 = throwDie();
	
	if (PlayerThrewAgain == 1) /* That means that the player threw a second time */
	{	
		PlayerThrewAgain = 0; /* Resetting the value to 0, for (possibly) the next round */
		toss4 = throwDie(); /* Throwing a fourth die */
		printf("Computer throws: %d, %d, %d, %d\n",toss1,toss2,toss3,toss4); /* Including the fourth throw in the print */
		greatest = GreatestOfThree(greatest,toss4,0); /* Getting the greatest of the previous three, plus the new throw, and 0 (which won't make a difference) */
		
	}
	else
	{
		printf("Computer throws: %d, %d, %d\n",toss1,toss2,toss3); /* Simply print out the computer's three throws we already calculated */
		greatest = GreatestOfThree(toss1,toss2,toss3); /* Calculate the greatest of three */
	}
	
	printf("Computer's Score is %d\n",greatest ); /* Printing out the greatest value calculated, whether it be of four or three throws */
		
	return greatest;
}


int main(int argc, char *argv[])
{
	int round, humanWins=0, computerWins=0 ;
	int humanToss, computerToss;
	const int numberOfRounds = 7;
  
	/* Play the Rounds */
	for ( round = 1; round<=numberOfRounds; round++ )
	{
		printf("\nRound %d\n\n", round );
		
		humanToss = humanTurn();
		computerToss = computerTurn();
    
		/* Determine Winner of the Round */
		if ( humanToss > computerToss )
		{
			humanWins++;
			printf("Human wins the round. Human: %3d. computer: %3d\n",
			humanWins, computerWins );
		}
		else /* In the case of a tie, or the computer has a higher score, the computer wins the round */
		{
			computerWins++;
			printf("Computer wins the round. Human: %3d. computer: %3d\n",
			humanWins, computerWins );
		}
	}

	/* Determine Winner of the Game */
	if ( humanWins > computerWins )
		printf("\n\nWINNER!! The human wins the game!\n");
	else if ( computerWins > humanWins )
		printf("\n\nThe computer wins the game!\n");
	else
		printf("\n\nTie Game!\n");
	
	fflush( stdout );
	return 0;
}