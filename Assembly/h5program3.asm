## Tim Sternberg | Homework 5, question 3

	.text
	.globl main
main: #(3x + 7)/(2x − y)

	ori $7, $0, 5  #x = 5  > $7
	ori $8, $0, 4 #y = 4 > $8
	
	ori $9, $0, 3
	mult $9, $7
	mflo $9
	addiu $9, $9, 7
	
	ori $10, $0, 2
	mult $10, $7
	mflo $10
	subu $10, $10, $8
	
	div $9, $10
	mflo $9
	mfhi $10
	

	
## End of file