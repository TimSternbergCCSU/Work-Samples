/*
// CS 153 PROGRAM ASSIGNMENT #5
//
// Homebrew math functions
//
// Tim Sternberg
//
// Due 3/4/17
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double myexp( double x )
{
	int n;
	double sum=1, term=1;
	
	for(n = 1; n <= 500 && term > 0; n++)
	{
		term = term * (x/n);
		sum += term;
	}
	
	return sum;
}

double mylog( double y )
{
	if (y > 0.0) {
		double x = (y-1)/(y+1);
		int n;
		double sum=x, term=x; /* Initialize the sum and term to the x value */
		for(n = 3; n <= 1000 && term > 0; n+=2) /* Starting from 3, since we already initialize the sum and term to x, essentially counting that as n=1. That way we can calculate the term the way it is */
		{
			term = term * x*x * (1.0/n) * (n-2); /* multipling the current term by x^2, dividing by n, and then essentially multipling out the old 1/n by multipling it by that n (which is n-2). If n=1, we couldn't do this */
			sum += term; /* adding the term to the sum */
		}
		sum *= 2; /* multipling the sum by 2 after the inside of it has been calculated */
		return sum;
	}
	else 
		return 0; /* if the y is less than or equal to 0 then simply return 0 */
			
}

double mypow( double x, double p)
{
	return myexp( p*mylog(x) ); /* Raising e to the power*ln(x) */
}

int main()
{
	double x, p ;
	
	printf("Enter x: " );
	fflush( stdout );
	scanf(" %lf", &x );
	
	printf("Enter p: " );
	fflush( stdout );
	scanf(" %lf", &p );
	
	printf("\nActual e^x: %18.14f\n", exp( x ) );
	printf("My e^x: %18.14f\n", myexp( x ) );
	
	printf("\nActual log(x): %18.14f\n", log( x ) );
	printf("My log(x): %18.14f\n", mylog( x ) );
	
	printf("\nActual pow(x,p): %18.14f\n", pow( x, p ) );
	printf("My pow(x,p): %18.14f\n", mypow( x,p ) );
	
	fflush( stdout );
}