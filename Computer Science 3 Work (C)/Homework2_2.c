/* 
	CS 153 PROGRAM ASSIGNMENT 2 PROBLEM 2

	Character Counter

	Tim Sternberg

	Due 1/4/17
*/

#include <stdio.h>

int main()
{
	char filename[] = "C:/Users/Tim/Google Drive/My Stuff/General/C Projects/CS3/words.txt"; /* Name of file */
	
	freopen(filename, "r", stdin); /* Using the specified file as the input */
	
	int CharCount[256] = {0}; /* Holds character 0 -> 256 */
	int c; /* Holds each character */
	int i; /* counts how many times we go through the loop */

    while((c = getchar()) != EOF) /* As long as we're not at the end of the file, read the character */ 
	{
		CharCount[c]++; /* +1 to the element at c in the CharCount table */
    }
	
	for (i=0; i<256; i++) /* 0 > 255 to look through the elements of CharCount table using index i of the for loop */
	{
		if (CharCount[i] > 0 && ((65 <= i && i <= 90) || (97 <= i && i <= 122))) /* if it's an alphabetic letter, then we print how many times it showed up */
		{
			printf("%c occured %d times\n", i, CharCount[i]); /* Converts the value at CharCount[i] to a char and prints it, as well as the int value at CharCount[i] */
		}
	}
	
	return 0;
}