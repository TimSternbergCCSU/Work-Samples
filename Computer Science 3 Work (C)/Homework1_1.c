/* 
   CS 153 PROGRAM ASSIGNMENT 1 PROBLEM 1

   BMI

   Tim Sternberg

   Due 1/28/17
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	double weight,height,bmi;
	char Status;
	
	printf("Enter weight: ");
	fflush( stdout );
	scanf(" %lf", &weight);
	
	printf("Enter height: ");
	fflush( stdout );
	scanf(" %lf", &height);
	
	bmi = (weight * 4.88) / (height*height);
	
	printf("BMI: %lf | ", bmi);
	
	if (bmi < 20)
		printf("Underweight");
	else if (bmi < 26)
		printf("Normal weight");
	else if (bmi < 30)
		printf("Slightly overweight");
	else if (bmi < 40)
		printf("Overweight");
	else 
		printf("Extremely overweight;");
	
}