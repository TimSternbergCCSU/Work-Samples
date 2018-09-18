/*
	Author: Tim Sternberg
	Class: CS_355
	Assignment: Lab6 Implementing myfind
	Date: 3/23/18
*/

#include <stdio.h>
#include <string.h> 
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <dirent.h>

#include <libgen.h>

void dofind(char* pattern,char* path);

int main(int ac, char *av[]) {
	
	char *pattern = av[1];
	char *path = av[2];
	
	if(av[1] && av[2])
		dofind(av[1],av[2]);
	
	return 0;
}

void dofind(char* pattern,char* path) {
    DIR *dir;
    struct dirent *entry;
	struct stat statbuf;
	int PrintedPath=0;
    if (((dir = opendir (path)) == NULL)) {
		perror("Cannot open ");
	}
	else {
		if(stat(path, &statbuf) != -1) {
			while ((entry = readdir (dir)) != NULL) {
				int i, curLength=0, entryLength=0, newLength=0;

				for(curLength=0; path[curLength]!='\0'; curLength++);
				for(entryLength=0; entry->d_name[entryLength]!='\0'; entryLength++);
				newLength = curLength+entryLength+2; // 2 extra, 1 for \0 and one for the / in between the concat
				char newPath[newLength];

				strcpy(newPath,path);
				strcat(newPath,"/");
				strcat(newPath,entry->d_name);

				stat(newPath, &statbuf);

				if(S_ISDIR(statbuf.st_mode)) { 
					if( strcmp(entry->d_name,".") && strcmp(entry->d_name,"..") ) {
						dofind(pattern,newPath);
					}
				}
				else if(strstr(entry->d_name,pattern)) {
					if(!PrintedPath) {
						PrintedPath=1;
						printf("%s\n",path);
					}
					printf("\t%s  (",entry->d_name);
					printf("%o/",statbuf.st_mode);
					printf( (S_ISDIR(statbuf.st_mode)) ? "d" : "-");
    				printf( (statbuf.st_mode & S_IRUSR) ? "r" : "-");
    				printf( (statbuf.st_mode & S_IWUSR) ? "w" : "-");
    				printf( (statbuf.st_mode & S_IXUSR) ? "x" : "-");
    				printf( (statbuf.st_mode & S_IRGRP) ? "r" : "-");
    				printf( (statbuf.st_mode & S_IWGRP) ? "w" : "-");
    				printf( (statbuf.st_mode & S_IXGRP) ? "x" : "-");
    				printf( (statbuf.st_mode & S_IROTH) ? "r" : "-");
    				printf( (statbuf.st_mode & S_IWOTH) ? "w" : "-");
    				printf( (statbuf.st_mode & S_IXOTH) ? "x" : "-");
    				printf(")\n");
				}
			}
		}
		closedir (dir);
	}
}