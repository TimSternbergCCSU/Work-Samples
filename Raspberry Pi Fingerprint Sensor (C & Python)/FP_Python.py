'''
Created on Dec 12, 2014

@author: dustin
'''

#FPRun.py

import os
print(os.getcwd())
import time
import sys
import serial
import struct
import time
from urllib.request import urlopen
from grove_rgb_lcd import *

enroll_baseURL = 'http://api.thingspeak.com/update?api_key=LIAJV0091KVK95ZR&field1='
auth_baseURL = 'http://api.thingspeak.com/update?api_key=LIAJV0091KVK95ZR&field2='

fingerID = 0xffff
confidence = 0xffff
templateCount = 0xffff
packageSum = 0x0000

FINGERPRINT_OK = 0x00
FINGERPRINT_PACKETRECIEVEERR = 0x01
FINGERPRINT_NOFINGER = 0x02
FINGERPRINT_IMAGEFAIL = 0x03
FINGERPRINT_IMAGEMESS = 0x06
FINGERPRINT_FEATUREFAIL = 0x07
FINGERPRINT_NOMATCH = 0x08
FINGERPRINT_NOTFOUND = 0x09
FINGERPRINT_ENROLLMISMATCH = 0x0A
FINGERPRINT_BADLOCATION = 0x0B
FINGERPRINT_DBRANGEFAIL = 0x0C
FINGERPRINT_UPLOADFEATUREFAIL = 0x0D
FINGERPRINT_PACKETRESPONSEFAIL = 0x0E
FINGERPRINT_UPLOADFAIL = 0x0F
FINGERPRINT_DELETEFAIL = 0x10
FINGERPRINT_DBCLEARFAIL = 0x11
FINGERPRINT_PASSFAIL = 0x13
FINGERPRINT_INVALIDIMAGE = 0x15
FINGERPRINT_FLASHERR = 0x18
FINGERPRINT_INVALIDREG = 0x1A
FINGERPRINT_ADDRCODE = 0x20
FINGERPRINT_PASSVERIFY = 0x1

FINGERPRINT_STARTCODE = 0xEF01

FINGERPRINT_COMMANDPACKET = 0x01
FINGERPRINT_DATAPACKET = 0x02
FINGERPRINT_ACKPACKET = 0x07
FINGERPRINT_ENDDATAPACKET = 0x08

FINGERPRINT_TIMEOUT = 0xFF
FINGERPRINT_BADPACKET = 0xFE

FINGERPRINT_GETIMAGE = 0x01
FINGERPRINT_IMAGE2TZ = 0x02
FINGERPRINT_REGMODEL = 0x05
FINGERPRINT_STORE = 0x06
FINGERPRINT_LOAD = 0x07
FINGERPRINT_UPLOAD = 0x08
FINGERPRINT_UPLOADIMAGE = 0x0A
FINGERPRINT_DOWNLOADIMAGE = 0x0B
FINGERPRINT_DELETE = 0x0C
FINGERPRINT_EMPTY = 0x0D
FINGERPRINT_VERIFYPASSWORD = 0x13
FINGERPRINT_HISPEEDSEARCH = 0x1B
FINGERPRINT_SEARCH = 0x04
FINGERPRINT_WRITENOTEPAD = 0x18
FINGERPRINT_READNOTEPAD = 0x19
FINGERPRINT_TEMPLATECOUNT = 0x1D
FINGERPRINT_COMMLINK = 0x17
DEFAULTTIMEOUT = 5.0


#Variables
thePassword = 0x00
theAddress = 0xFFFFFFFF
fingerID = 0
confidence = 0
templateCount = 0
shortTime = 0.5
usbport = '/dev/ttyUSB0'
baudrate = 57600
parity = serial.PARITY_NONE
stopbits = serial.STOPBITS_ONE
bytesize = serial.EIGHTBITS
usbportTimeout = 5.0
xonxoff = 0
rtscts = 0

#Set-up serial communication
def begin():

	global ser
	ser = serial.Serial(
                        usbport,
                        baudrate,
                        bytesize,
                        parity,
                        stopbits,
                        usbportTimeout,
                        xonxoff,
                        rtscts)

	time.sleep(shortTime)
	print ("Serial port setup on " + ser.name)

	if(ser.isOpen() == True):
		print("Serial port is open")
		ser.flush()
	else:
		print("Serial port is closed")

#Verify password with the Fingerprint Sensor
def verifyPassword():
    rxPacket = bytearray()

    packet = bytearray([
			FINGERPRINT_VERIFYPASSWORD,
			((thePassword >> 24) & 0xff),
			((thePassword >> 16) & 0xff),
			((thePassword >> 8) & 0xff),
			(thePassword & 0xff)
			])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, 0x0007, packet)
    rxPacket = receivePacket(12)

    rxLength = (rxpacket[8]) - 2

    if((rxLength == 1) and (str(rxpacket[6]) == '7') and (str(rxPacket[9]) == '0')):
        return True
    return False

#Return packet of detected Fingerprint image
def getImage():
    rxPacket = bytearray()
    packet = bytearray([FINGERPRINT_GETIMAGE])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    if((len(rxPacket)) < 12):
        print ("Receive packet error - Rx'd:" + str(len(rxPacket)))
        return False

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Finger collection success")
            setText("FINGERPRINT\nLOADED")
            time.sleep(1)
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '2'):
            #print ("Can't detect finger")
            return False
        elif(str(rxPacket[9]) == '3'):
            print ("Failed to collect finger")
            return False
        else:
            print ("Unknown getImage error")
            return False

#Return packet of character file from original Fingerprint image
def image2Tz(image2TzBuffer):
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_IMAGE2TZ,
        (image2TzBuffer & 0xff)
        ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Generated character file complete")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '6'):
            print ("Failed to generate character file due to over-disorderly fingerprint image")
            return False
        elif(str(rxPacket[9]) == '7'):
            print ("Failed to generate character file due to lackness of character point or over smallness of fingerprint image")
            return False
        elif(str(rxPacket[9]) == '21'):
            print ("Failed to generate image for the lackness of valid primary image")
            return False
        else:
            print ("Unknown image2Tz error")
            return False

#Return acknowledge packet of RegModel
def createModel():
    rxPacket = bytearray()
    packet = bytearray([FINGERPRINT_REGMODEL])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Generate template success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '10'):
            print ("Failed to combine character file")
            return False
        else:
            print ("Unknown createModel error")
            return False

#Return acknowledge packet of Store
def storeModel(storeModelID, storeModelBuffer):
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_STORE,
        (storeModelBuffer & 0xff),
        ((storeModelID >> 8) & 0xff),
        (storeModelID & 0xff)
        ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Template stored success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '11'):
            print ("Addressed PageID is beyond finger library")
            return False
        elif(str(rxPacket[9]) == '24'):
            print ("Error writing flash")
            return False
        else:
            print ("Unknown storeModel error")
            return False

#Return Fingerprint template from flash into Char Buffer 1
def loadModel(loadModelID, loadModelBuffer):
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_LOAD,
        (loadModelBuffer & 0xff),
        ((loadModelID >> 8) & 0xff),
        (loadModelID & 0xff)
        ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Template load success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '12'):
            print ("Error reading template from library or readout template is invalid")
            return False
        elif(str(rxPacket[9]) == '11'):
            print ("Addressed PageID is beyond finger library")
            return False
        else:
            print ("Unknown loadModel error")
            return False

#Transfer a Fingerprint template from the Char Buffer 1 to host computer
def getModel(getModelBuffer):
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_UPLOAD,
        (getModelBuffer & 0xff)
        ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)
    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Ready to tansfer following data packet")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '13'):
            print ("Error uploading template")
            return False
        else:
            print ("Unknown getmodel error")
            return False

#Delete Fingerprint template
def deleteModel(deleteModelID):
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_DELETE,
        ((deleteModelID >> 8) & 0xff),
        (deleteModelID & 0xff),
        0x00,
        0x01
        ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("ID template delete success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '16'):
            print ("Failed to delete ID template")
            return False
        else:
            print ("Unknown deleteModel error")
            return False

#Empty Fingerprint sensor database
def emptyDatabase():
    rxPacket = bytearray()
    packet = bytearray([FINGERPRINT_EMPTY])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Empty library success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '17'):
            print ("Failed to clear finger library")
            return False
        else:
            print ("Unknown emptyDatabase error")
            return False

#Fingerprint search
def fingerSearch():
    rxPacket = bytearray()
    packet = bytearray([
    FINGERPRINT_SEARCH,
    0x01,
    0x00,
    0x00
    ])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(16)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 5) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            setText("AUTHORIZED ID " + str(rxPacket[10]) + str(rxPacket[11]))
            print ("Page ID:" + str(rxPacket[10]) + str(rxPacket[11]))
            print ("Match score:" + str(rxPacket[12]) + str(rxPacket[13]))
            urlopen(auth_baseURL + str(rxPacket[10]) + str(rxPacket[11]))
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '9'):
            print ("No matching finger in the library")
            setText("INVALID\nFINGERPRINT")
            time.sleep(3)
            setText("WAITING FOR\nVALIDFINGER")
            # i = input("Continue? Y/N: ")
            # if(i=='n' or i=='N'):
            #     return "EXIT"
            # else:
            return False
        else:
            print ("Unknown fingerSearch error")
            return False

#Get the template count of the Fingerprint sensor
def getTemplateCount():
    templateCount = 0
    rxPacket = bytearray()
    packet = bytearray([FINGERPRINT_TEMPLATECOUNT])

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, len(packet)+2, packet)
    rxPacket = receivePacket(14)

    rxLength = (rxPacket[8]) - 2

    if((rxLength == 3) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Finger collection success")
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return -1
        else:
            print ("Unknown getTemplateCount error")
            return -1

    templateCount = (rxPacket[10] * 256) + rxPacket[11]

    return templateCount

#Verify communication with Fingerprint Sensor
def checkFPComms():
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_COMMLINK,
        0x00
        ])
    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, 0x0004, packet)
    rxPacket = receivePacket(12)

    if((len(rxPacket)) < 12):
        print ("Receive packet error - Rx'd:" + str(len(rxPacket)))
        return False

    #rxLength = (ord(rxPacket[8])) - 2
    rxLength = rxPacket[8] - 2

    if((rxLength == 1) and ((str(rxPacket[6])) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Communication success")
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '29'):
            print ("Comm port error")
            return False
        else:
            print ("Unknown error")
            return False

#Read notepad for each ID
def getNotepad(pageID):
    fileName = 'FingerprintID' + str(pageID)
    rxPacket = bytearray()
    packet = bytearray([
        FINGERPRINT_READNOTEPAD,
        (pageID & 0xff),
        ])

    #Open file as write only
    try:
        f = open(fileName, "w")
    except:
        print("Error opening/creating file " + fileName)
        return False

    #Send command to read page ID
    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(44)

    rxLength = rxPacket[8] - 2

    if((rxLength == 33) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print("Notepad Read Success")
            #write Rx packet to file
            for i in range(10, (rxLength + 9)):
                f.write((str(rxPacket[i])) + '\n')
            f.write('EOF')
            f.close()
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            f.close()
            return False
        else:
            print ("Unknown error")
            f.close()
            return False

#Write each ID to Notepad
def writeNotepad(pageID):
    rxPacket = bytearray()

    fileName = 'FingerprintID' + str(pageID)

    #Open file as read only
    try:
        f = open(fileName, "r")
    except:
        print("Error opening file " + fileName)
        return False

    packet = bytearray([
        FINGERPRINT_WRITENOTEPAD,
        (pageID & 0xff),
        ])

    #read file with new line for each value - 32 numbers
    lines = f.readlines()

    #get rid of EOF
    lines.pop(32)

    #get rid of '\n'
    for i in range(0, (len(lines))):
        lines[i] = lines[i].replace('\n', '')
    #print("length of lines " + str(len(lines)))
    #print(lines)

    #convert string to int then hex and append to packet
    for i in range(0, len(lines)):
        packet.append((int(lines[i]) & 0xff))

    #add values to packet and convert to hex

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)

    rxLength = rxPacket[8] - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print("Notepad Write Success")
            f.close()
            if(loadModel(pageID, 1) == True):
                if(loadModel(pageID, 2) == True):
                    if(creatModel() == True):
                        if(storeModel(pageID, 1) == True):
                            return True
            return False
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            f.close()
            return False
        else:
            print ("Unknown error")
            f.close()
            return False

#Upload fingerprint image to computer
def uploadImage(uploadImageID):
    fileName = 'FingerprintImage' + uploadImageID
    rxPacket = bytearray()
    imagePacket = bytearray()
    packet = bytearray([
        FINGERPRINT_UPLOADIMAGE])

    #Open file as write only
    try:
        f = open(fileName, "w")
    except:
        print("Error opening/creating file " + fileName)
        return False

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)
    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Ready to tansfer following data packet")
            imagePacket = receivePacket(40032)
            for i in range(0, (len(imagePacket))):
                f.write(str(imagePacket[i]) + '\n')
            f.write('EOF')
            f.close
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '16'):
            print ("Fail to transfer the following data packet")
            return False
        else:
            print ("Unknown uploadImage error")
            return False

#Download fingerprint image to Sensor
def downloadImage(downloadImageID):
    fileName = 'FingerprintImage' + downloadImageID
    rxPacket = bytearray()
    imagePacket = bytearray()
    packet = bytearray([
        FINGERPRINT_DOWNLOADIMAGE])

    #Open file as write only
    try:
        f = open(fileName, "r")
    except:
        print("Error opening file " + fileName)
        return False
    #read lines of the file
    lines = f.readlines()
    print("Length of lines " + str(len(lines)))

    #Get rid of EOF
    lines.pop(len(lines)-1)

    #Get rid of '\n'
    for i in range(0, (len(lines))):
        lines[i] = lines[i].replace('\n', '')
        imagePacket.append((int(lines[i])) & 0xff)
    #print("length of lines " + str(len(lines)))
    #print(lines)

    writePacket(theAddress, FINGERPRINT_COMMANDPACKET, (len(packet)+2), packet)
    rxPacket = receivePacket(12)
    rxLength = (rxPacket[8]) - 2

    if((rxLength == 1) and (str(rxPacket[6]) == '7')):
        #print ("Receive packet acknowledged")
        if(str(rxPacket[9]) == '0'):
            print ("Ready to tansfer following data packet")
            imageTX = ser.write(imagePacket)
            f.close
            return True
        elif(str(rxPacket[9]) == '1'):
            print ("Error receiving packet")
            return False
        elif(str(rxPacket[9]) == '15'):
            print ("Module can't receive the following data packet")
            return False
        else:
            print ("Unknown DownloadImage error")
            return False


#Write data to Fingerprint Sensor
def writePacket(addr, packetType, pLengthTX, packet):
    checksum = bytearray()
    dataToSend = bytearray([
        ((FINGERPRINT_STARTCODE>>8) & 0xff),
        ((FINGERPRINT_STARTCODE) & 0xff),
        ((addr>>24) & 0xff),
        ((addr>>16) & 0xff),
        ((addr>>8) & 0xff),
        ((addr) & 0xff),
        ((packetType) & 0xff),
        ((pLengthTX>>8) & 0xff),
        ((pLengthTX) & 0xff)
        ])

    #print ("dataToSend created")

    #packageSum is used as checksum (arithmatic sum of package id, package length and package contents
    packageSum = ((pLengthTX >>8) & 0xff) + (pLengthTX & 0xff) + packetType
    #print ("packageSum:" + str(packageSum))


    for i in range((len(packet))):
        packageSum = packageSum + (packet[i] & 0xff)

    #bytesTX = ser.write(checksum)
    #ser.flush()

    packet.append((packageSum >> 8) & 0xff)
    packet.append(packageSum & 0xff)

    bytesTX = ser.write(dataToSend)
    bytesTX = ser.write(packet)

#Fast Read data from Fingerprint Sensor and return with package length of 3 ONLY
def receivePacket(pLengthRx):
    timer = 0
    bArrayLoc = 0
    reply = [0]

    while(True):
        bArrayLoc = 0

        while(not ser.readable()):
            time.sleep(0.1)
            timer = timer + 1
            if timer >= ((int(usbportTimeout)) * 10):
                return int(FINGERPRINT_TIMEOUT)
        #print ("read " + str(reply[0]))

        #Waiting for receive packet
        while(reply[bArrayLoc] == 0):
            reply[bArrayLoc] = ser.read(1)
            #Need to add timeout - times out then waits for user input? timeout and goes back to main?
        reply.extend(ser.read(pLengthRx - 1))
        reply[0] = 239
        '''
        #Display received packet
        print ("Display received packet")
        for i in range(0, pLengthRx):
            print ("reply:" + str(i) + " = " + str(reply[i]))
        '''

        return reply

import RPi.GPIO as GPIO

inputPinExit = 7
outputPin = 40

#Get ID # from operator and enroll
def enrollIDLoop():
    #userInput = input("ID # to store the finger as:")
    while(True):
        fID = input("ID # to store the finger or Q to quit:")

        if(fID.isdigit()):
            print ("Enrolling ID #" + fID)
            break
        elif((fID == 'q') or (fID == 'Q')):
            fID = ''
            main(quit=True)
        else:
            print ("Must enter digit only")

    fRun = False
    while(not fRun):
        fRun = enrollFingerprint(fID)
        if(GPIO.input(inputPinExit) == False):
            main()

def enrollFingerprint(enrollID):
    print ("Waiting for valid finger to enroll")
    time.sleep(0.5)

    p = False
    while (not p):
        p = getImage()
        if(p):
            print ("Image taken")
            break
        elif(not p):
            print (".")
        else:
            print ("Unknown Error")

    time.sleep(0.5)
    p = image2Tz(1)

    if(p):
        print ("Image converted")
    elif(not p):
        print ("Image not converted")
        return p
    else:
        print ("Unknown Error")
        return p

    print ("Remove Finger")
    time.sleep(2.0)

    p = False
    print ("Place same finger again")
    time.sleep(1.0)
    while(not p):
        p = getImage()

        if(p):
            print ("Image taken")
            break
        elif(not p):
            print (".")
        else:
            print ("Unknown Error")

    time.sleep(0.5)
    p = image2Tz(2)

    if(p):
        print ("Image converted")
    elif(not p):
        print ("Image not converted")
        return p
    else:
        print ("Unknown Error")
        return p

    #Converted
    time.sleep(0.5)
    p = createModel()

    if(p):
        print ("Fingerprints match")
    elif(not p):
        print ("Fingerprints did not match")
        return p
    else:
        print ("Unknown Error")
        return p

    time.sleep(0.5)
    enrollIDbytes = int(enrollID, 16)
    p = storeModel(enrollIDbytes, 1)

    if(p):
        print ("Stored fingerprint template")
        urlopen(enroll_baseURL + str(enrollID))
        enrollIDLoop()
    elif(not p):
        print ("Store Fingerprint Error")
        return p
    else:
        print ("Unknown Error")
        return p

#Run fingerprint sensor
def runLoop(outputTimeout):
    print ("Waiting for valid finger...")

    while(GPIO.input(inputPinExit) == True):
        if(getFingerprintIDez() == True):
            GPIO.output(outputPin, GPIO.HIGH)
            time.sleep(outputTimeout)
        else:
            GPIO.output(outputPin, GPIO.LOW)

    main()
#Get fingerprint
def getFingerprintID():
    p = False
    while(not p):
        p = getImage()
        if(p):
            print ("Image Taken")
            break
        elif(not p):
            print ("No finger detected")
        else:
            print ("Unknown Error")

    p = image2Tz(1)

    if(p):
        print ("Image converted")
    elif(not p):
        print ("Image not converted")
        return p
    else:
        print ("Unknown Error")
        return p

    p = fingerSearch()

    if(p):
        print ("Found fingerprint")
    elif(not p):
        print ("No fingerprint found")
        return p
    else:
        print ("Unknown Error")
        return p

#Get fingerprint quick
def getFingerprintIDez():

    p = getImage()
    if(not p):
        return 0

    p = image2Tz(1)
    if(not p):
        return -1

    p = fingerSearch()
    if(not p):
        return -1

    #print ("Found fingerprint")
    return (p)

#Upload fingerprint image to computer and save to file
def imageUpload():
    #userInput = input("ID # to store the finger as:")
    while(True):
        userID = input("ID # to store the finger or Q to quit:")

        if(userID.isdigit()):
            break
        elif((userID == 'q') or (userID == 'Q')):
            userID = ''
            main()
        else:
            print ("Must enter digit only")

    print ("Enrolling ID #" + userID)

    print ("Waiting for valid finger to enroll")
    time.sleep(0.5)

    p = False
    while (not p):
        p = getImage()
        if(p):
            print ("Image taken")
            break
        elif(not p):
            print (".")
        else:
            print ("Unknown Error")

    #time.sleep(0.5)
    p = uploadImage(userID)

    if(p):
        print ("Image downloaded and saved")
        return p
    elif(not p):
        print ("Image not downloaded or saved")
        return p
    else:
        print ("Unknown Error")
        return p

#Open image file and download to fingerprint sensor
def imageDownload():
    #userInput = input("ID # to store the finger as:")
    while(True):
        userID = input("ID # to download the finger or Q to quit:")

        if(userID.isdigit()):
            break
        elif((userID == 'q') or (userID == 'Q')):
            userID = ''
            main()
        else:
            print ("Must enter digit only")

    print ("Downloading ID #" + userID)

    p = downloadImage(userID)
    time.sleep(.05)

    if(p):
        print ("Image downloaded to sensor")
    elif(not p):
        print ("Image not downloaded to sensor")
        return p
    else:
        print ("Unknown Error")
        return p

    p = image2Tz(1)
    time.sleep(.05)
    if(p):
        print ("Image converted")
    elif(not p):
        print ("Image not converted")
        return p
    else:
        print ("Unknown Error")
        return p

    p = downloadImage(userID)
    time.sleep(.05)
    if(p):
        print ("Image downloaded to sensor")
    elif(not p):
        print ("Image not downloaded to sensor")
        return p
    else:
        print ("Unknown Error")
        return p

    p = image2Tz(2)
    time.sleep(.05)
    if(p):
        print ("Image converted")
    elif(not p):
        print ("Image not converted")
        return p
    else:
        print ("Unknown Error")
        return p

    #Converted
    p = createModel()
    if(p):
        print ("Fingerprints match")
    elif(not p):
        print ("Fingerprints did not match")
        return p
    else:
        print ("Unknown Error")
        return p

    enrollIDbytes = int(userID, 16)
    p = storeModel(enrollIDbytes, 1)
    if(p):
        print ("Stored fingerprint template")
        return p
    elif(not p):
        print ("Store Fingerprint Error")
        return p
    else:
        print ("Unknown Error")
        return p

#Main
Initialized = False
def Initialize():
	print("Initializing Fingerprint Scanner...")
	lockOnTime = 1
    #set-up output pin
	GPIO.setmode(GPIO.BOARD)
	GPIO.setwarnings(False)
	GPIO.setup(outputPin, GPIO.OUT, initial=GPIO.LOW)
	GPIO.setup(inputPinExit, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    #Set serial port and baudrate
	begin()

	if(checkFPComms()):
		print("Found Fingerprint Sensor. Initialization complete")
		Initialized = True
	else:
		print("Did not find Fingerprint Sensor")
#endinitialize

def Enroll_From_Cpp():
	setText("MODE:\nENROLLMENTT")
	time.sleep(3)
	if(not Initialized):
		Initialize()

	fID = input("ID # to store the finger or Q to quit: ")

	if(fID.isdigit()):
		print ("Enrolling ID #" + fID)
		fRun = False
		while(not fRun):
			fRun = enrollFingerprint(fID)
	elif((fID == 'q') or (fID == 'Q')):
		print("Quitting")
	else:
		print ("Must enter digit only")
#endenroll

def Authenticate_From_Cpp():
	setText("MODE:\nAUTHENITCATION")
	time.sleep(3)
	if(not Initialized):
		Initialize()
	f = open("authenticateResults.txt","w+")
	f.write("0")

	setText("WAITING FOR\nVALIDFINGER")
	print ("Waiting for valid finger...")

	Authenticated = False
	status = True
	while((GPIO.input(inputPinExit) == True) and (not Authenticated) and (status != "EXIT")):
		status = getFingerprintIDez()
		if(status == True):
			GPIO.output(outputPin, GPIO.HIGH)
			#time.sleep(8)
			Authenticated = True
			f = open("authenticateResults.txt","w+")
			f.write("1")
		else:
			GPIO.output(outputPin, GPIO.LOW)
#endauthenticate

def main(**param):
    setText("SYSTEM LOADED\nINITIALIZING")
    time.sleep(1)
    setRGB(0,128,64)
    lockOnTime = 1
    #set-up output pin
    GPIO.setmode(GPIO.BOARD)
    GPIO.setwarnings(False)
    GPIO.setup(outputPin, GPIO.OUT, initial=GPIO.LOW)
    GPIO.setup(inputPinExit, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    #Set serial port and baudrate
    begin()

    if(checkFPComms()):
        print ("Found Fingerprint Sensor")
    else:
        print ("Did not find Fingerprint Sensor")
        main()


    # print ("Waiting for valid finger...")
    # while(GPIO.input(inputPinExit) == True):
    #     if(getFingerprintIDez() == True):
    #         GPIO.output(outputPin, GPIO.HIGH)
    #         time.sleep(8)
    #     else:
    #         GPIO.output(outputPin, GPIO.LOW)

    if not ('quit' in param):
        f = open("mode.txt","r")
        m = f.read()
        print("MODE: " + m)
        if(m == "Enroll"):
            Enroll_From_Cpp()
        elif(m == "Authenticate"):
            Authenticate_From_Cpp()
        else:
            print("INVALID MODE")


    while(False):
        print("1 - Enroll Fingerprints")
        print("2 - Run Fingerprint Sensor")
        print("3 - Save Notepad to File")
        print("4 - Load Notepad from File")
        print("5 - Erase Library")
        print("6 - Upload Fingerprint Image to Computer")
        print("7 - Download Fingerprint Image to Sensor")
        print("E - Exit")
        menuInput = input ("Please select option ")

        if((menuInput.isdigit()) and (menuInput == '1')):
            enrollIDLoop()
            break
        elif((menuInput.isdigit()) and (menuInput == '2')):
            lockOnTime = 8
            runLoop(lockOnTime)
            break
        elif((menuInput.isdigit()) and (menuInput == '3')):
            totalCount = getTemplateCount()
            print ("Template count is " + str(totalCount))
            for i in range(1, totalCount + 1):
                if(getNotepad(i) == True):
                    print("Success Writing ID File for " + str(i))
                else:
                    print("Error Writing ID File")
                    break
        elif((menuInput.isdigit()) and (menuInput == '4')):
            #run writeNotepad(ID) until False (returns false when no ID found)
            writeID = 1
            while((writeNotepad(writeID)) == True):
                writeID += 1
            print("Total ID's entered " + str(writeID - 1))
        elif((menuInput.isdigit()) and (menuInput == '5')):
            if(emptyDatabase() == True):
                pass
            else:
                print("Error erasing library")
        elif((menuInput.isdigit()) and (menuInput == '6')):
            if(imageUpload() == True):
                pass
            else:
                print("Error uploading image and saving to file")
        elif((menuInput.isdigit()) and (menuInput == '7')):
            if(imageDownload() == True):
                pass
            else:
                print("Error opening file and downloading to sensor")
        elif((menuInput == 'E') or (menuInput == 'e')):
            menuInput = ''
            GPIO.cleanup()
            sys.exit()
        else:
            print ("Must select from the menu")

    GPIO.cleanup()
    return 0

if __name__ == '__main__':
    main()

#End
