/* CS 153 PROGRAM 8 String Tighten
 AUTHOR: Tim Sternberg
 DATE: 3/22/17
 DESCRIPTION: Create a program which "tightens" any given strings by removing unnecessary spaces
*/

#include <stdio.h>
#include <stdlib.h>

void tighten(char *oldstring, char* newstring, int length)
{
	int i; /* What we'll be incrementing through the string with, and make sure we don't over extend the length */
	int FirstValueYet = 0; /* The true/false value which will tell us whether or not newstring has any characters yet */
	oldstring++; /* Increment oldstring so that it's 1 ahead of newstring */
	for (i=1; i<length && *oldstring != NULL; i++) /* Go until either we're at the end of the string or we meet a null termination */
	{
		char prev = *(oldstring-1); /* The previouss value is the value before the current one at oldstring */
		int isPrevWhitespace = (prev == ' ' || prev == '\t' || prev == '\n' || prev == '\v' || prev == '\f' || prev == '\r'); /* Tells us whether or not prev is whitespace */
		char current = *oldstring; /* The current value is the one that's currently at oldstring */
		int isCurrentWhitespace = (current == ' ' || current == '\t' || current == '\n' || current == '\v' || current == '\f' || current == '\r'); /* Tells us whether or not current is whitespace */
		
		if( !(isCurrentWhitespace && isPrevWhitespace) && (!isPrevWhitespace || FirstValueYet)) /* As long as not both current and prev are whitespace, and prev isn't going to set whitespace as the first character */
		{
			FirstValueYet = 1; /* Setting it equal to 1, which will tell us that we do in fact have our first value */
			*newstring = prev; /* Setting the value that's at new string (which has no important information presumably) equal to prev */
			newstring++; /* Incrementing the pointer to newstring, which will make it so it points to the byte AFTER the one we just used */
		}
		
		oldstring++; /* Always increment oldstring */
		
		if (*oldstring == NULL || i>=length) /*Checking to see if this is the last iteration we're going through. If so, check if the last character in oldstring is a space or not*/
		{
			char prev = *(oldstring-1); /* If it is the last, then we set prev equal to what will be the last character of oldstring */
			int isPrevWhitespace = (prev == ' ' || prev == '\t' || prev == '\n' || prev == '\v' || prev == '\f' || prev == '\r'); /* Whether or not it's whitespace */
			if (!isPrevWhitespace) /*If the last character isn't whitespace, then we add it to newstring*/
			{
				*newstring = prev;
				newstring++;
			}
		}
	}
	*newstring = NULL; /* Terminate the end of newstring with a NULL */
}

int main()
{
	int BUFFERSIZE = 1000; /* Maximum size of each input line is 1 kilobyte (1000 bytes/characters) */
	char oldstring[BUFFERSIZE];
	
	puts("Enter a string: ");
	fflush(stdout);
	while ( gets(oldstring) ) /* Putting a string into oldstring */
	{
		int length=0; /* Initializing length to 0 */
		char *character = oldstring;
		while (*character != NULL) /* Finding the length of the string by looking for its NULL termination */
		{
			length++;
			character++;
		}
		
		char newstring[length]; /* Creating newstring with the actual length of the string */
		tighten(oldstring,newstring,length); /* We tighten the string */
		puts(newstring); /* Print out the tightened string */
		puts("\nEnter a string: "); /* Set up for next time */
		fflush(stdout);
	}
	
	return 0;
}