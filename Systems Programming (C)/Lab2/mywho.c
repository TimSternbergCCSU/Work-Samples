/*
	Author: Tim Sternberg
	Class: CS_355
	Assignment: Lab2 Implementing who
	Date: 3/28/18
*/

#include <stdio.h>
#include <stdlib.h>
#include <utmp.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>

#define SHOWHOST      /* include remote machine on output */

void show_info( struct utmp *utbufp );
void printTime ( time_t *rawtime );

int main()
{
   struct utmp   current_record;   /* read info into here       */
   int    utmpfd;                  /* read from this descriptor */
   int    reclen = sizeof(current_record);

   if ( (utmpfd = open(UTMP_FILE, O_RDONLY)) == -1 ){
      perror( UTMP_FILE );         /* UTMP_FILE is in utmp.h    */
      exit(1);
   }

   while ( read(utmpfd, &current_record, reclen) == reclen )
	   if (current_record.ut_type == USER_PROCESS)
		show_info(&current_record);

   close(utmpfd);
   return 0;         /* went ok */
}
/*
 *  show info()
 *   displays contents of the utmp struct in human readable form
 *   *note* these sizes should not be hardwired
 */
void show_info( struct utmp *utbufp )
{
   printf("%-8.8s ", utbufp->ut_name);   /* the logname  */
   
   printf("%-8.8s     ", utbufp->ut_line);   /* the tty      */
   
   time_t curtime = utbufp->ut_time;
   printTime(&(utbufp->ut_time));		/* the time of login */
   
#ifdef   SHOWHOST
   printf("(%s) ", utbufp->ut_host);     /* the host     */
#endif
   printf("\n");                        /* newline      */
}

void printTime ( time_t *rawtime )
{
	struct tm *info = localtime( rawtime );
	
	int Year = 1900+info->tm_year;
	printf("%d-",Year);
	int Month = info->tm_mon;
	printf("%02d-",Month+1); /* need a +1 here, since we can't have month 0 */
	int Day = info->tm_mday;
	printf("%02d ",Day);
	int Hour = info->tm_hour;
	printf("%02d:",Hour);
	int Min = info->tm_min;
	printf("%02d ",Min);
}