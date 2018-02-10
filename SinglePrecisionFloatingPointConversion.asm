# Integers to IEEE 754 single-precision floating-point numbers conversion
# Vo Huy
	# Data Memory Section
	.data
number:	.asciiz "Enter a number: "
	# Program Memory section
	.text
	.globl main
main:	
	# Prompt the user to enter a number
	li $v0, 4 		#print string
	la $a0, number 		#"Enter a number: "
	syscall
	# Get the number
	li $v0, 5 		#read integer
	syscall
	add $s0, $v0, $zero	#s0 = user input
	
	# TODO CONVERSIOIN
	
	j main			#go on asking the user