# Tim Sternberg | Homework 7, question 3

	.text
	.globl main
main: 
	
	lui $1, 0x1000
	lw $2, 0($1)
	lw $3, 4($1)
	lw $4, 0($1)
	lw $5, 4($1)
	sll $0, $0, 0
	
loop:
	addi $4, $4, -1
	addi $5, $5, -1
	beq $4, $0, savex
	beq $5, $0, savey
	j loop
	
	
savex:
	sw $2, 8($1)
	j endlp
	
savey:
	sw $3, 8($1)
	j endlp
	
endlp: 
	sll $0, $0, 0
	lw $6, 8($1)
	
.data
	x:    .word 10
	y:    .word 5
	min:  .word 0