## Tim Sternberg | Homework 4, question 1

	.text
	.globl main
main:

	ori $1,$0,0xABCD #Placing the hexadecimal value 0x000ABCD in register 1
	ori $2,$0,0x1234 #Placing the hexadecimal value 0x00001234 in register 2
	sll $2,$2,16 #Shifting 0x00001234 left 16 places, so now it's 0x12340000
	addu $1,$2,$1 #adding together 0x12340000 and 0x0000ABCD so we have our 0x1234ABCD. Placed in register 1
	
## End of file