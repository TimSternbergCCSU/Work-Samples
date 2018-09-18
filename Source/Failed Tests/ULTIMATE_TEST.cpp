#include <iostream>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include "GPIOClass.h"

using namespace std;

int main (void)
{

    string inputstate;
	//GPIOClass* gpio11 = new GPIOClass("11"); //create new GPIO object to be attached to  GPIO11
	//GPIOClass* gpio12 = new GPIOClass("12"); //create new GPIO object to be attached to  GPIO12
	//GPIOClass* gpio13 = new GPIOClass("13"); //create new GPIO object to be attached to  GPIO13
	//GPIOClass* gpio15 = new GPIOClass("15"); //create new GPIO object to be attached to  GPIO15
	GPIOClass* gpios[] = {
		new GPIOClass("11"),
		new GPIOClass("12"),
		new GPIOClass("13"),
		new GPIOClass("15"),
	};
	

    gpios[0]->export_gpio(); //export GPIO11
    gpios[1]->export_gpio(); //export GPIO12
	gpios[2]->export_gpio(); //export GPIO13
    gpios[3]->export_gpio(); //export GPIO15

    cout << " GPIO pins exported" << endl;

    gpios[0]->setdir_gpio("out");
	gpios[1]->setdir_gpio("out");
	gpios[2]->setdir_gpio("out");
	gpios[3]->setdir_gpio("out");

    cout << " Set GPIO pin directions" << endl;

	//int StepPins[] = {17,18,27,22};
	int Seq[8][4] = {{1,0,0,1},
			   {1,0,0,0},
			   {1,1,0,0},
			   {0,1,0,0},
			   {0,1,1,0},
			   {0,0,1,0},
			   {0,0,1,1},
			   {0,0,0,1}
	};
	//int StepCount = 8;
	int StepDir = 1;
	int StepCounter = 0;
	int x;
	for(x=0;x<100;x++) {
		int pin;
		for(pin=0; pin<4; pin++) {
			//int xpin=StepPins[pin];
			if(Seq[StepCounter][pin] != 0)
				gpios[pin]->setval_gpio("1");
			else
				gpios[pin]->setval_gpio("0");
		}
		
		StepCounter += StepDir;
	}
	
    // while(0)
    // {
        // usleep(500000);  // wait for 0.5 seconds
        // gpio17->getval_gpio(inputstate); //read state of GPIO17 input pin
        // cout << "Current input pin state is " << inputstate  <<endl;
        // if(inputstate == "0") // if input pin is at state "0" i.e. button pressed
        // {
            // cout << "input pin state is "Pressed ".n Will check input pin state again in 20ms "<<endl;
                // usleep(20000);
                    // cout << "Checking again ....." << endl;
                    // gpio17->getval_gpio(inputstate); // checking again to ensure that state "0" is due to button press and not noise
            // if(inputstate == "0")
            // {
                // cout << "input pin state is definitely "Pressed". Turning LED ON" <<endl;
                // gpio4->setval_gpio("1"); // turn LED ON

                // cout << " Waiting until pin is unpressed....." << endl;
                // while (inputstate == "0"){
                // gpio17->getval_gpio(inputstate);
                // };
                // cout << "pin is unpressed" << endl;

            // }
            // else
                // cout << "input pin state is definitely "UnPressed". That was just noise." <<endl;

        // }
        // gpio4->setval_gpio("0");

    // }
    cout << "Exiting....." << endl;
    return 0;
}