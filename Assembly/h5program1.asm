## Tim Sternberg | Homework 5, question 1

	.text
	.globl main
main:

	ori $8, $0, 42
	sll $9, $8, 2 #4x > $9
	addu $9, $9, $8 #4x + x > $9
	addu $9, $9, $8 #5x + x > $9
	addiu $9, $9, -12 #6x - 12 > $9

	

## End of file