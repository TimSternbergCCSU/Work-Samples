# Tim Sternberg | Homework 8

	.text
	.globl main
main: 
	
	li $v0, 4
	la $a0, L
	syscall
	li $v0, 5
	syscall
	move $s0, $v0

	li $v0, 4
	la $a0, S
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
	
	
loop:
	sub $s0, $s0, $s1 #subtracting s0 from s1 and placing the result in s0
	j exit
	nop
	
	#if s0 and s1 are equal, we're done
	beq $s0, $s1, exit
	nop
	
	#If the greater value is less than the smaller value, switch them and then jump back to the loop beginning
	slt $t0, $s1, $s0 #If s1 < s0, then 1 > t0. Otherwise, 0 > t0
	beq $t0, $0, switch
	nop
	j loop
	nop
	
switch:
	move $t0, $s0
	move $s0, $s1
	move $s1, $t0
	j loop
	nop

exit:
	li $v0, 4
	la $a0, gcd
	syscall #printing "GCD: "

	move $a0, $s1
	li, $v0, 1
	syscall #Printing s1
	
	li $v0, 10
	syscall	#ending
	
	
	
.data
	L: .asciiz "Enter large integer: "
	S: .asciiz "Enter small integer: "
	gcd: .asciiz "GCD: "