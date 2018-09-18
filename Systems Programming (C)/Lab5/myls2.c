/*
	Author: Tim Sternberg
	Class: CS_355
	Assignment: Lab5 Implementing ls2
	Date: 3/05/18
*/

#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdlib.h> 
#include <string.h> 
#include <sys/ioctl.h>

void do_ls(char[] ,int[]);
int cstring_cmp(const void*, const void*);
int calculateNumColumns(int, int);

static int switches[] = {0,0}; 

int main(int ac, char *av[]) {
	int i,foundDir=0;
	for(i=1; i<ac; i++) {
		if(av[i][0]=='-'){
			int l=1;
			char c;
			while((c=av[i][l])!='\0'){
				char c = av[i][l];
				if(c=='r')
					switches[0]=1;
				else if(c=='s')
					switches[1]=1;
				l++;
			}
		}
		else {
			foundDir=1; // Letting us know that there was at least one directory specified
			printf("%s:\n", av[i]);
			char *dirname = av[i];
			do_ls(dirname,switches);
		}
	}
	
	if(!foundDir) // If there was no directory specified, then look in current directory
		do_ls(".",switches);
	
	return 1;
}

void do_ls(char dirname[],int switches[]) {
	DIR           *dir_ptr;      /* the directory */
	struct dirent *direntp;      /* each entry    */

	if ((dir_ptr = opendir(dirname)) == NULL)
		fprintf(stderr,"ls1: cannot open %s\n", dirname);
	else {
		int gap=3,i=0,maxLen=0;
		char *entries[100]; // By default, 100 entries possible. Array of strings.
		while ((direntp = readdir(dir_ptr)) != NULL) {
			char *namePtr = direntp->d_name;
			if(namePtr[0]!='.') {
				int o; for(o=0; namePtr[o]!='\0'; o++);
				if(o>maxLen) maxLen=o;
				entries[i] = namePtr;
				i++;
				//printf("%s\n",namePtr);
			}
		}
		
		int columns = calculateNumColumns(maxLen,gap);
		if(!(columns%2)) columns--;
		int rows = (int)(i/columns);
		//if(i%columns != 0) rows++;
		//printf("%d %d\n",columns,rows);
		
		
		if (switches[0] || switches[1]) // Print according to method specified
			qsort(entries,i, sizeof(char *), cstring_cmp); // Quicksort the array of strings
		
		int printed[i+1];
		int o; 
		for(o=0; o<i+1; o++) printed[o]=0;
		int row = 0;
		for(o=0; o<=i; o++) {
			int column = o % (columns);
			if(column==0 && row!=0) printf("\n");
			row = row + (!(o%columns));
			int entryNum = column*(rows+1) + row;
			if(entryNum <= i+1 && !printed[entryNum]) {
				char *entry = entries[entryNum-1];
				//printf("%s%d%d\n", entry, row, column);
				printf("%s", entry);
				
				int u; for(u=0; entry[u]!='\0'; u++);
				
 				if(column==(columns-1));
					//printf("\n");
				else {
					int p; 
					for(p=0; p<(maxLen-u+gap); p++) 
						printf(" ");
				}
				printed[entryNum] = 1;
			}
			//else printf("%d_",entryNum);
		}
		
		printf("\n");
		closedir(dir_ptr);
	}
}

/* qsort C-string comparison function */ 
int cstring_cmp(const void *a, const void *b) {
    const char **ia = (const char **)a;
    const char **ib = (const char **)b;
	if(switches[0])
		return strcmp(*ib, *ia);
	else
		return strcmp(*ia, *ib);
} 

int calculateNumColumns(int maxLen, int gap) {
	struct winsize wbuf;
	if(ioctl(0,TIOCGWINSZ,&wbuf) != -1) {
		return wbuf.ws_col/(maxLen + gap);
	}
}