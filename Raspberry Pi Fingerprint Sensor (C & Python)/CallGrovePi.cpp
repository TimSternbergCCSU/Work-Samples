#include "grovepi.h"
#include <wiringPi.h>
#include <stdio.h>
using namespace GrovePi;

static const uint8_t DIGITAL_WRITE = 2;
static const uint8_t PIN_MODE = 5;

// sudo g++ -Wall grovepi.cpp grove_led_blink.cpp -o grove_led_blink.out -> without grovepicpp package installed
// sudo g++ -Wall -lgrovepicpp grove_led_blink.cpp -o grove_led_blink.out -> with grovepicpp package installed

// sudo g++ -Wall -lgrovepicpp -lwiringPi CallGrovePi.cpp -o CallGrovePi.out

void turnMotor()
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
	printf("\tTurning\n");
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

		usleep(1 * 1000);
	}

	digitalWrite (0, LOW);
	digitalWrite (1, LOW);
	digitalWrite (2, LOW);
	digitalWrite (3, LOW);

	printf("\tEndTurning\n");
}

int main()
{
	int LED1_pin = 2;
	int LED2_pin = 3;
	int buzzer_pin = 4;
	try
	{
		initGrovePi(); // initialize communication w/ GrovePi
		writeBlock(PIN_MODE, LED1_pin,OUTPUT);  // setting as output device
		writeBlock(PIN_MODE, LED2_pin,OUTPUT);  // setting as output device.
		writeBlock(PIN_MODE, buzzer_pin,OUTPUT);  // setting as output device
		sleep(1); // wait 1 second

		printf("Attempting to blink 2 LED's, turn a motor, then buzz\n");

		//int i;
		//for(i=0;i<3;i++){
			// HIGH -> ON
			printf("ON\n");
			writeBlock(DIGITAL_WRITE, LED1_pin, (uint8_t)HIGH);
			sleep(1);
			writeBlock(DIGITAL_WRITE, LED2_pin, (uint8_t)HIGH);
			sleep(1);
			turnMotor();
			sleep(1);
			writeBlock(DIGITAL_WRITE, buzzer_pin, (uint8_t)HIGH);
			sleep(1);

			// LOW -> OFF
			writeBlock(DIGITAL_WRITE, LED1_pin, (uint8_t)LOW);
			writeBlock(DIGITAL_WRITE, LED2_pin, (uint8_t)LOW);
			writeBlock(DIGITAL_WRITE, buzzer_pin, (uint8_t)LOW);
			printf("OFF\n");
		//	sleep(0.5);
		//}
	}
	catch(I2CError &error)
	{
		printf(error.detail());
		return -1;
	}

	return 0;
}
