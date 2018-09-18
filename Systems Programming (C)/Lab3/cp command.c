#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

#define BUFFERSIZE 4096
#define COPYMODE 0644

int main(int ac, char *av[])
{
    int  in_fd, out_fd, n_chars;
    char buf[BUFFERSIZE];

    /* check arguments */
    if (ac != 3){
    	fprintf(stderr, "usage: %s source destination\n", *av);
        return 1;
    }

    /* open files */
    if ((in_fd=open(av[1], O_RDONLY)) == -1) {
        perror("Cannot open source file");
        return 1;
    }

    if ((out_fd=creat( av[2], COPYMODE)) == -1) {
        perror("Cannot creat destination file");
        return 1;
    }

    /* copy files */
    while ((n_chars = read(in_fd, buf, BUFFERSIZE)) > 0)
        if (write(out_fd, buf, n_chars) != n_chars) {
            perror("Write error");
            return 1;
    }

    if (n_chars == -1) {
        perror("read error");
        return 1;
    }

    /* close files	*/
    if (close(in_fd) == -1 || close(out_fd) == -1) {
        perror("Error closing file(s)	");
        return 1;
    }

    return 0;
}