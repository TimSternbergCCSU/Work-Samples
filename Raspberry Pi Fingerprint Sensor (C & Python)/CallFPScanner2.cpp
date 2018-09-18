#include <Python.h>
#include <stdio.h>
#include <stdlib.h>
#include "grovepi.h"
#include <wiringPi.h>
#include <string.h>
using namespace GrovePi;

static const uint8_t DIGITAL_WRITE = 2;
static const uint8_t PIN_MODE = 5;
int LED1_pin = 2;
int LED2_pin = 3;
int buzzer_pin = 4;

// sudo g++ -Wall -I /usr/include/python3.5m/ -lpython3.5m CallFPScanner2.cpp -lgrovepicpp -lwiringPi -o CallFPScanner2.out

void initializeSensors();
void turnMotor(int);
void openThing();

int main(int argc, char *argv[]) {
  FILE * fp;
  fp = fopen("/home/pi/Desktop/fingerprint/Final/mode.txt","w");
  fprintf(fp,argv[1]);
  fclose(fp);

  initializeSensors();
  writeBlock(DIGITAL_WRITE, LED2_pin, (uint8_t)HIGH); // have red on by default

  wchar_t *program = Py_DecodeLocale(argv[0], NULL);
  Py_SetProgramName(program);  /* optional but recommended */
  Py_Initialize();
  PyObject *obj = Py_BuildValue("s", "FP_Python.py");
  FILE *file = _Py_fopen_obj(obj, "r+");
  if(file != NULL) {
      PyRun_SimpleFile(file, "FP_Python.py");
  }
  PyMem_RawFree(program);

  if(argc>1 && (!strcmp(argv[1],"Authenticate"))) {
    fp = fopen("/home/pi/Desktop/fingerprint/Final/authenticateResults.txt","r");
    char c = fgetc(fp);
    if(c=='1') {
      openThing();
    }
    fclose(fp);
  }
  return 0;
}

void openThing() {
  writeBlock(DIGITAL_WRITE, LED1_pin, (uint8_t)HIGH);
  writeBlock(DIGITAL_WRITE, LED2_pin, (uint8_t)LOW);
  writeBlock(DIGITAL_WRITE, buzzer_pin, (uint8_t)HIGH);
  turnMotor(1);

  writeBlock(DIGITAL_WRITE, LED1_pin, (uint8_t)LOW);
  writeBlock(DIGITAL_WRITE, LED2_pin, (uint8_t)LOW);
  writeBlock(DIGITAL_WRITE, buzzer_pin, (uint8_t)LOW);
  sleep(5);
  turnMotor(-1);
}

void initializeSensors() {
  initGrovePi(); // initialize communication w/ GrovePi
  writeBlock(PIN_MODE, LED1_pin,OUTPUT);  // setting as output device
  writeBlock(PIN_MODE, LED2_pin,OUTPUT);  // setting as output device.
  writeBlock(PIN_MODE, buzzer_pin,OUTPUT);  // setting as output device
}

void turnMotor(int StepDir)
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
	int StepCounter = 0;
	int x;
	printf("\tTurning\n");
	for(x=0;x<2000;x++) {
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
