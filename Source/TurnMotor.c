#include <wiringPi.h>
#include <stdio.h>

// gcc -Wall -o TurnMotor TurnMotor.c -lwiringPi

int main (void)
{
	wiringPiSetup();
	pinMode (0, OUTPUT) ;
	pinMode (1, OUTPUT) ;
	pinMode (2, OUTPUT) ;
	pinMode (3, OUTPUT) ;
	
	int StepPins[] = {0,1,2,3};
	int Seq[8][4] = {
			{1,0,0,1},
			{1,0,0,0},
			{1,1,0,0},
			{0,1,0,0},
			{0,1,1,0},
			{0,0,1,0},
			{0,0,1,1},
			{0,0,0,1}
	};
	int StepCount = 8;
	int StepDir = 1;
	int StepCounter = 0;
	int x;
	printf("Start\n");
	for(x=0;x<3000;x++) {
		int pin;
		for(pin=0; pin<4; pin++) {
			int xpin=StepPins[pin];
			if(Seq[StepCounter][pin] != 0)
				digitalWrite (xpin, HIGH);
			else
				digitalWrite (xpin, LOW);
		}
		
		StepCounter += StepDir;
		
		// If we reach the end of the sequence start again
		if (StepCounter>=StepCount)
			StepCounter = 0;
		if (StepCounter<0)
			StepCounter = StepCount+StepDir;	
		
		delay(1);
	} 
	
	digitalWrite (0, LOW);
	digitalWrite (1, LOW);
	digitalWrite (2, LOW);
	digitalWrite (3, LOW);	
	
	printf("End\n");
	return 0 ;
}