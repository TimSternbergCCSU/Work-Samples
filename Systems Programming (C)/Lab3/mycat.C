/*
	Author: Tim Sternberg
	Class: CS_355
	Assignment: Lab3 Implementing cat
	Date: 3/28/18
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define BUFFERSIZE 4096

void printBuffer(char *buf,int n_chars);
int isWhiteSpace(char *buf,int n_chars);
static int switches[] = {0,0,0,0};
static int numLines = 1;
static char curLine[BUFFERSIZE];
static int continuingFromBuffer = 0;

int main(int ac, char *av[]) {
	int n_chars, src;
    char buf[BUFFERSIZE];

    /* check arguments */
    if (ac <= 1){ /* need at least the source file */
    	fprintf(stderr, "usage: %s source destination\n", *av);
        return 1;
    }
	
	/* check what each arguement is */
	int i;
	for(i=1; i<ac; i++) {
		/* determining which switches are enabled */
		if(av[i][0]=='-'){
			int l=1;
			char c;
			while((c=av[i][l])!='\0'){
				char c = av[i][l];
				if(c=='b')
					switches[0]=1;
				else if(c=='e')
					switches[1]=1;
				else if(c=='n')
					switches[2]=1;
				else if(c=='s')
					switches[3]=1;
				l++;
			}
		}
		else {
			/* open file to copy from */
			if ((src=open(av[i], O_RDONLY | O_APPEND)) == -1) {
				perror("Cannot open source file");
				return 1;
			}
			
			/* print what's in the file */
			while ((n_chars = read(src, buf, BUFFERSIZE)) > 0) {
				printBuffer( buf,n_chars );
			}

			if (n_chars == -1) {
				perror("read error");
				return 1;
			}
			
			/* close current src */
			if (close(src) == -1) {
				perror("Error closing file(s)	");
				return 1;
			}
			
			//printf("\n");
		}
			
	}
	
    return 0;
}

void printBuffer(char *buf,int n_chars) {
	int i, chars_on_line=0, printLine=0;
	
	for(i=0; i<n_chars; i++) {
		char c = buf[i];
		int lineOfWhiteSpace=isWhiteSpace(curLine,chars_on_line);
		
		if(c=='\n' || i+1>=n_chars){
			/* As long as we're not continuing from another file, it isn't a line of whitespace with -s or -b enabled, */
			/* Or switches[2] is in enabled, then */
			//if(continuingFromBuffer) {
			//	printf("\n");
			//	continuingFromBuffer=0;
			//}
			if((!continuingFromBuffer||switches[3]) && !(lineOfWhiteSpace&&switches[3]) && ( (switches[0]&&!lineOfWhiteSpace) || (switches[2]&&!switches[0]) )) {
				printf("     %d  ",numLines);
				numLines++;
			}
			else if(continuingFromBuffer)
				continuingFromBuffer=0;
			
			printLine=1;
		}
		if(c!='\n'){
			curLine[chars_on_line] = c;
			chars_on_line++;			
		}
		
		if(printLine){
			printLine=0;
			
			if(i+1<n_chars){ /* Assuming we're not at the end of the buffer */
				if(switches[1] && i!=n_chars){ /*Swap what was supposed to be on the last line with $ */
					curLine[chars_on_line] = curLine[chars_on_line-1];
					curLine[chars_on_line-1] = '$';
					chars_on_line++;
				}
				curLine[chars_on_line] = '\0'; /* The reason there's two different places this happens, is because this HAS to happen before we reset chars_on_line */
				chars_on_line=0;
			}
			else{ /* If we are at the end of the buffer, tell the next one (if there is) that we left off somewhere */
				continuingFromBuffer=1;
				curLine[chars_on_line] = '\0';
			}
			
			if(!switches[3] || !lineOfWhiteSpace){ /* If we're allowed to print */
				printf("%s",curLine);
				if(c=='\n')
					printf("\n");
			}
		}
	}
}

int isWhiteSpace(char *buf,int n_chars) {
	int i;
	for(i=0; i<n_chars; i++){
		unsigned char c = buf[i];
		if(!(c==' ' || c=='\t' || c=='\n' || c=='\n' || c=='\v' || c=='\f' || c=='\r')){
			return 0;
		}
	}
	return 1;
}