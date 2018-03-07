# Sample for loop
# Lab 4.2

	# Data Memory Section
	.data

	# Program Memory Section
	.text
	.globl main
	
main:

	# Assign values to registers
	addi $s0, $zero, 0 # int i = 0;
	addi $s1, $zero, 0 # int sum = 0;
	addi $t0, $zero, 10 # store the index limit: 10 in this case
	
for:	bge $s0, $t0, after_for # if i > 10 run after_for
	add $s1, $s1, $s0 # sum += i;
	addi $s0, $s0, 1 # i++
	j for # looping
	
after_for:
	
	
