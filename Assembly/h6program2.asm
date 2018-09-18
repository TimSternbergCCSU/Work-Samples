## Tim Sternberg | Homework 6, question 2

	.text
	.globl main
main: #15x^3 - 9x^2 + 10x + 24

	lui $1, 0x1000 # address 0x1000 > $1
	lw $2, 0($1) # x > $2
	
	ori $7, $0, 15 # 15 > $7
	mult $2, $7
	mflo $7 # 15x - 9 > $7 
	addiu $7, $7, -9 # 15x - 9 > $7 
	mult $7, $2
	mflo $7 # 15x^2 - 9x > $7
	addiu $7, $7, 10 # 15x^2 - 9x + 10 > $7 
	mult $7, $2
	mflo $7 # 15x^3 - 9x^2 + 10x > $7 
	addiu $7, $7, 24 # 15x^3 - 9x^2 + 10x + 24 > $7
	
	sw $7, 4($5) # $7 > poly

.data

	x: .word 10
	poly: .word 0