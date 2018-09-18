## Tim Sternberg | Homework 6, question 1

	.text
	.globl main
main: # 27xy + 16x − 12y + 55

	lui $1, 0x1000 # address 0x1000 > $1
	lw $2, 0($1) # x > $2
	lw $3, 4($1) # y > $3
	
	addiu $4, $0, 27 # 27 > $4
	addiu $5, $0, 16 # 16 > $5
	addiu $6, $0, 12 # 12 > $6
	addiu $7, $0, 55 # 55 > $7
	
	mult $4, $2
	mflo $8 # 27x > $8
	mult $8, $3
	mflo $8 # 27xy > $9
	
	mult $5, $2
	mflo $9 # 16x > $9 # 16x > $9
	
	addu $8, $8, $9 # 27xy + 16x > $8
	
	mult $6, $3
	mflo $9 # 12y > $9
	
	subu $8, $8, $9 # (12xy + 16x) - 12y > $8
	
	addi $8, $8, 55 # (12xy + 16x - 12y) + 55 > $8
	
	sw $8, 8($1)

.data

	x: .word 10
	y: .word 15
	answer: .word 0