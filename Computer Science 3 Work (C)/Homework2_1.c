/* 
	CS 153 PROGRAM ASSIGNMENT 2 PROBLEM 1

	Normal Distribution

	Tim Sternberg

	Due 1/4/17
*/

#define _USE_MATH_DEFINES
#include <math.h>
#include <stdio.h>

double normal( double x, double sigma, double mu) /* Pure function, takes in x, sigma, and mu to calculate the normal function */
{
	const double pi = M_PI; /* Pi */
	
	double denom = sigma * sqrt(2 * pi); /* This will be the value 1 / (sigma)*(2*pi)^1/2 */
	
	double eEXP = x-mu; /* eExp is the value e^STUFF */
	eEXP = eEXP / sigma;
	eEXP = eEXP*eEXP;
	eEXP = -(eEXP / 2);
	eEXP = exp(eEXP); /* The exponent part was calculated, now we're just taking e^STUFF */
	
	return eEXP/denom; /* Taking e^STUFF / the denominator we calculated before */
}

int main()
{
	int i; /* Index for the for loop */
	double x,mu,sigma; /* Input values for the normal function */
	
	/* Notice we calculate mean and sigma first, and then only calculate x within the for loop */
	printf("Enter mean: ");
	fflush( stdout );
	scanf(" %lf", &mu);
	
	printf("Enter sigma: ");
	fflush( stdout );
	scanf(" %lf", &sigma);
	
	if (sigma>0) /* Sigma needs to be something GREATER than 0 */
		for (i=0; i<4; i++) /* Running through four times */
		{
			printf("Enter a value for x: ");
			fflush( stdout );
			scanf(" %lf", &x);
			
			printf("f(%g) = %g\n",x,normal(x,sigma,mu)); /* Printing the returned value from the normal function */
		}
	else
		printf("Error! Sigma must be greater than 0!\n"); /* If sigma is <= 0 */
	
}