# Tim Sternberg | Homework 7, question 2

	.text
	.globl main
main: 
	
	ori $8, $0, 0 #The sum
	ori $9, $0, 0 #The counter
	ori $10, $0, 100 #The number we're going to
	
loop:
	beq $9, $10, endlp
	sll $0, $0, 0 #load delay
	addiu $9, $9, 2
	addu $8, $8, $9
	j loop
	
endlp: sll $0, $0, 0
	