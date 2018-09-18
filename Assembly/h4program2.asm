## Tim Sternberg | Homework 4, question 2

	.text
	.globl main
main:

	ori $1,$0,0x01 #Initializing, putting hex value 1 in register 1 (AKA: 0001)
	
	sll $2,$1,1 #0010 > $2
	sll $3,$1,2 #0100 > $3
	sll $4,$1,3 #1000 > $4
	
	or $5,$1,$2 #0011 > $5
	or $6,$5,$3 #0111 > $6
	or $7,$6,$4 #1111 > $7
	
	sll $8,$7,4 #1111 0000 > $8
	or $9,$7,$8 #1111 1111 > $9
	
	#The following simply shift the $9 left four places, put in $8, compare $8 and $9 using or, and place into $9	
	
	sll $8,$9,4 #1111 1111 0000 > $8 (Note: $9 still holds 0000 1111 1111 at this point)
	or $9,$9,$8 #1111 1111 1111 > $9
	
	sll $8,$9,4
	or $9,$9,$8
	
	sll $8,$9,4
	or $9,$9,$8
	
	sll $8,$9,4
	or $9,$9,$8
	
	sll $8,$9,4
	or $9,$9,$8
	
	sll $8,$9,4
	or $9,$9,$8	
	
	or $1,$0,$9 #We have our final value, fffffffff, and we place in $1 

## End of file