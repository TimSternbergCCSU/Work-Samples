/* 
	CS 153 PROGRAM ASSIGNMENT 3

	Amicable Numbers

	Tim Sternberg

	Due 2/11/17
*/

#include <stdio.h>

int sumDivisors (int N)
{
	int trial=2, sum=1; /* Starting the trial number at 2, and setting sum = 1, since every number is divisible by 1 */
	while (trial*trial <= N) /* while trial*trial is greater than N */
	{
		if (N%trial == 0)
		{
			/* Add the divisors to the sum */
			sum += trial;
			sum += N/trial;
		}
		trial++;
	}
	
	return sum;
}

int main()
{
	int N, low, upper;
	
	printf("Enter a lower limit: ");
	fflush(stdout);
	scanf(" %d", &low);
	
	printf("Enter an upper limit: ");
	fflush(stdout);
	scanf(" %d", &upper);
	
	for (N=low; N <= upper; N++)
	{
		int S = sumDivisors(N); /* Potential amicable pair to N */
		int Ssum = sumDivisors(S); /* Sums of S (S being the sums of N). If it's an amicable pair, Ssum Should equal N */
		
		if (S == N)
			printf("%d is a perfect number\n",N);
		else if (Ssum == N && S > N )
			printf("%d is an amicable pair with %d\n",N,S);
		
		fflush(stdout);
	}
	
	return 0;
}