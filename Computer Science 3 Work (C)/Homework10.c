/* CS 153 PROGRAM 10 CIPHER
 AUTHOR: Tim Sternberg
 DATE: 4/15/17
 DESCRIPTION: Create a program which encodes messages
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

static unsigned int X;

void startRandom( unsigned int seed )
{
	X = seed;
}

unsigned int random()
{
	// Our a,b,m values which will remain the same. Initialized as constant and static to clearly show this
	const static int a = 998;
	const static int c = 53;
	const static int m = 997;
	
	X = (a*X + c) % m; // Presumably there will be overflow, so there's not need to do the mod operator. However it's good to do it anyway
	
	return X; // Returning our pseudo random number
}

int main(int argc, char *argv[])
{
	int key = atoi( argv[1] ); // Converting the string key to an int
	startRandom( key ); // Initializing our random number generator to the seed provided in the command line
	
	int exit_status = EXIT_SUCCESS;
	FILE *plaintext,*ciphertext;
	
	char b; // b will be the current character being manipulatd

	plaintext = fopen(argv[2],"rb"); // Our plain text is the THIRD element in the command that was entered
	ciphertext = fopen(argv[3],"wb"); // Ciphered text is FOURTH element
	if (plaintext != NULL) // As long as the plain text file exists
	{
		while ((b = fgetc(plaintext)) != EOF) // As long as it's not the end of the file
		{
			b = (b^random()) % 256; // b = (b XOR pseudo-random-number) MOD 256
			fputc(b,ciphertext); // Write that to the ciphered text file
		}
	}
	else // If the plaintext file doesn't exis
	{
		perror(*argv);
		exit_status = EXIT_FAILURE;
	}

	if (fclose(plaintext) != 0 || fclose(ciphertext) != 0) // Closing the files
	{
		perror("fclose");
		exit(EXIT_FAILURE);
	}
	
	return exit_status;
}