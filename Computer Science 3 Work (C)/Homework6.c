/* CS 153 PROGRAM 6 – Pi Dart
 AUTHOR: Tim Sternberg
 DATE: 3/5/17
 DESCRIPTION: Calculate pi by keeping track of X amount of "randomly" placed darts fall within a circle
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

void throwDart(double *x, double *y) /* x and y are pointers to the adresses of the x and y values in main */
{
	static int initialized = 0;
	
	if ( !initialized )
	{
		srand( time(NULL) );
		initialized = 1;
	}
	
	/* Random number between -1.0 and 1.0, calculating by dividing the random number by half the maximum number it could be, and then subtracting 1 */
	/* Need to cast a double, since rand() returns an int */
	*x = (double)rand()/(RAND_MAX/2) - 1;
	*y = (double)rand()/(RAND_MAX/2) - 1;
}

int main()
{
	int i;
	double x,y;
	int numOfThrows,numInsideCircle=0;
	
	printf("Please enter a number of throws: ");
	fflush( stdout );
	scanf("%d",&numOfThrows);
	
	for(i=0;i<numOfThrows;i++)
	{
		throwDart(&x,&y); /* Giving throwDart the adresses of the x and y values */
		double distance = x*x + y*y; /*Distance from center */
		if( distance <= 1 )
		{
			numInsideCircle++;
		}
	}
	printf("Throws: %d | Estimation of pi: %lf\n",numOfThrows,(double)(4*numInsideCircle)/numOfThrows);
}