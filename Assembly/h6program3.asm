# Tim Sternberg | Homework 6, question 3

	.text
	.globl main
main: # 

	lui $1, 0x1000 # address 0x1000 > $1
	lw $2, 0($1) # x > $2
	lw $3, 4($1) # a > $3 
	lw $4, 8($1) # b > $4
	lw $5, 12($1) #c > $5
	lw $6, 16($1) #d > $6

	mult $3, $2
	mflo $7 # ax > $7
	addu $7, $7, $4 # ax + b > $7
	mult $7, $2 
	mflo $7 # ax^2 + bx > $7
	addu $7, $7, $5 # ax^2 + bx + c > $7
	mult $7, $2 
	mflo $7 # ax^3 + bx^2 + cx > $7
	addu $7, $7, $6 # ax^3 + bx^2 + cx + d > $7
	
	sw $7, 20($1) # $7 > poly

.data

	x: .word 1
	a: .word -7
	b: .word 15
	c: .word -32
	d: .word 25
	poly: .word 0