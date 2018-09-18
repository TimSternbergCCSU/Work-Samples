/*
	Author: Tim Sternberg
	Class: CS_355
	Assignment: Lab4 Implementing ls
	Date: 2/28/18
*/

#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdlib.h> 
#include <string.h> 

void do_ls(char[] ,int[]);
int cstring_cmp(const void*, const void*);

int main(int ac, char *av[])
{
	int switches[] = {0,0,0}; 

	int i,foundDir=0;
	for(i=1; i<ac; i++) {
		if(av[i][0]=='-'){
			int l=1;
			char c;
			while((c=av[i][l])!='\0'){
				char c = av[i][l];
				if(c=='a')
					switches[0]=1;
				else if(c=='s')
					switches[1]=1;
				else if(c=='r')
					switches[2]=1;
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

void do_ls(char dirname[],int switches[])
{
	DIR           *dir_ptr;      /* the directory */
	struct dirent *direntp;      /* each entry    */

	if ((dir_ptr = opendir(dirname)) == NULL)
		fprintf(stderr,"ls1: cannot open %s\n", dirname);
	else
	{
		int i=0;
		char *entries[100]; // By default, 100 entries possible. Array of strings.
		while ((direntp = readdir(dir_ptr)) != NULL) {
			if (!switches[0] || (direntp->d_name[0]!='.')) {
				if (switches[1] || switches[2]) { // If we're supposed to sort, we add to array and increment i
					entries[i] = direntp->d_name;
					i++;
				}
				else
					printf("%s\n", direntp->d_name); // Only print now if not sorting
			}
		}
		
		if (switches[1] || switches[2]) { // Print according to method specified
			qsort(entries,i, sizeof(char *), cstring_cmp); // Quicksort the array of strings
			int o;
			if(switches[1])
				for(o=0; o<i; o++)
					printf("%s\n", entries[o]);
			else
				for(o=i; o>0; o--)
					printf("%s\n", entries[o-1]);
		}
			
		closedir(dir_ptr);
	}
}

/* qsort C-string comparison function */ 
int cstring_cmp(const void *a, const void *b) {
    const char **ia = (const char **)a;
    const char **ib = (const char **)b;
    return strcmp(*ia, *ib);
} 