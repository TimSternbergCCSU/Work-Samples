#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <pwd.h>
#include <utmp.h>

#define SHOWHOST      /* include remote machine on output */

int stop = 0;

void CtrD_Pressed();
int ttyValid(char*,char*);

int main( int ac, char *av[]) {
  int fd;
  char buf[BUFSIZ],ttybuf[128]="/dev/";

  // check args
  if (ac!=3) {
    fprintf(stderr, "usage: write0 ttyname\n");
    return 1;
  }

  // open devices
  strcat(ttybuf,av[2]);
  fd = open( ttybuf, O_WRONLY );
  if (fd==-1) {
    perror(av[1]);
    return 1;
  }

  // is tty open on user?
  if(ttyValid(av[2],av[1]) < 0) {
    printf("mywrite: pi2 is not logged in on %s\n",av[2]);
    return 1;
  }

  // start signal
  signal( SIGINT, CtrD_Pressed );

  // getting hostname
  char hostname[1024];
  gethostname(hostname, 1024);

  // getting current time
  time_t time_raw_format;
	struct tm * ptr_time;
	time ( &time_raw_format );
	ptr_time = localtime ( &time_raw_format );

  // printing welcome message
  sprintf(buf,"\nMessage from %s@%s on %s at %i:%i...\n",hostname,av[1],av[2],ptr_time->tm_hour,ptr_time->tm_min);
  write(fd, buf, strlen(buf));

  // loop until EOF on input
  while( (fgets(buf, BUFSIZ, stdin) != NULL) && !stop) {
    if( write(fd, buf, strlen(buf)) == -1)
      break;
  }

  write(fd, "EOF\n", 4);
  close( fd );
  return 0;
}

void CtrD_Pressed() {
  stop = 1;
}

int ttyValid(char *tty, char *user) {
  struct utmp   current_record;   /* read info into here       */
  int    utmpfd;                  /* read from this descriptor */
  int    reclen = sizeof(current_record);

  if ( (utmpfd = open(UTMP_FILE, O_RDONLY)) == -1 ){
     perror( UTMP_FILE );         /* UTMP_FILE is in utmp.h    */
     return -1;
  }

  while ( read(utmpfd, &current_record, reclen) == reclen )
    if (current_record.ut_type == USER_PROCESS)
      if(!strcmp(current_record.ut_line,tty) && !strcmp(current_record.ut_name,user))
        return 0; // if the tty sent in matches to a user, then we're all set

  close(utmpfd);
  return -1;         /* went ok */
}
