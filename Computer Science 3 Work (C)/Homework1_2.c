/* 
   CS 153 PROGRAM ASSIGNMENT 1 PROBLEM 2

   Quadratic Formula

   Tim Sternberg

   Due 1/28/17
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main()
{
	
	double a,b,c;
	double root1,root2,discriminant;
	int stop;
	
	while (stop != 1)
	{
		printf("Enter a: ");
		fflush( stdout );
		scanf(" %lf", &a);
		
		printf("Enter b: ");
		fflush( stdout );
		scanf(" %lf", &b);
		
		printf("Enter c: ");
		fflush( stdout );
		scanf(" %lf", &c);
		
		if ( ! (a == 0 && b == 0 && c == 0) ) {
			if (a == 0 && b == 0) {
				printf("Error! Both a and b cannot be 0!\n");
			}
			else if (a == 0) {
				root1 = -c/b;
				printf("One root at %lf\n", root1);
			}
			else if ( (discriminant = b*b - 4*a*c) > 0 ) {
				root1 = (-b) + sqrt(discriminant);
				root1 = root1 / (2*a);
				printf("Root1 = %lf\n", root1);
				
				root2 = (-b) - sqrt(discriminant);
				root2 = root2 / (2*a);
				printf("Root2 = %lf\n", root2);
			}
			else if ( (discriminant = b*b - 4*a*c) == 0 ) {
				root1 = -b / (2*a);
				printf("One root: %lf\n", root1);
			}
			else {
				printf("Discriminant less than zero, no real roots\n");
			}
			
		}
		else {
			stop = 1;
			printf("End Program\n");
		}
	}
	
}