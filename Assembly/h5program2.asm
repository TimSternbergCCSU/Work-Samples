## Tim Sternberg | Homework 5, question 2

	.text
	.globl main
main: #3x^2 + 5x - 12

	ori $8, $0, 5 #Initializing, putting 5 into $8
	
	mult $8,$8 # x*x
	mflo $9 # x*x > $9
	ori $10, $0, 3 # 3 > $10
	mult $9, $10 # 3 * x^2
	mflo $9 # 3 * x^2 > $9
	ori $10, $0, 5 #5 > $10
	mult $8, $10 # 5 * x
	mflo $10 # 5*x > $10
	addu $9, $9, $10 # 3x^2 + 5x > $9
	addiu $9, $9, -12 # 3x^2 + 5x - 12 > $9
	
	
## End of file