# Integers to IEEE 754 single-precision floating-point numbers conversion
# Vo Huy
	# Data Memory Section
	.data
float1:	.asciiz "\nEnter the first number: "
	.align 2
float2:	.asciiz "\nEnter the second number: "
	.align 2
	# Program Memory section
	.text
	.globl main
main:	
	# Prompt the user to enter a number
	li $v0, 4 			#print string
	la $a0, float1 			#"\nEnter the first number: "
	syscall
	# Get the first number
	li $v0, 6 			#read float
	syscall
	swc1 $f0, 0($a0)		#a0 = the first floating number
	addi $sp, $sp, -8
	sw $a0, 8($sp)			#push $a0 to the stack
	
	# Prompt the user to enter a number
	li $v0, 4 			#print string
	la $a0, float2 			"\nEnter the second number: "
	syscall
	lw $a0, 8($sp)			#pop $a0 from the stack
	
	
	# Get the second number
	li $v0, 6 			#read float
	syscall
	swc1 $f0, 0($a1)		#a1 = the second floating number
	
	jal add_float			#add_float(float1, float2)
	j main				#go on asking the user
	
add_float:
	sw $ra, 4($sp)			#push $ra to 
	jal compare_float		#compare_float(float1, float2)
	lw $ra, 4($sp)
	addi $sp, $sp, 4

#compare 2 float numbers and return them with the smaller one first and the bigger one second
compare_float:				
	move $t0, $a0			#t0 = floating1
	move $t1, $a1			#t1 = floating2
	sll $t2, $t0, 1
	srl $t2, $t2, 24		#t2 = the exponent of floating1
	sll $t3, $t1, 1
	srl $t3, $t3, 24		#t3 = the exponent of floating2
	bne $t2, $t3, swap_float
	
	