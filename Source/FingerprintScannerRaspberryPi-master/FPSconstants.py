'''
Created on Dec 10, 2014

@author: dustin
'''
#FPSconstants.py
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
