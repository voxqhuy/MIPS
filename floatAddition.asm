# Integers to IEEE 754 single-precision floating-point numbers conversion
# Vo Huy
	# Data Memory Section
	.data
float1:	.asciiz "\nEnter the first number to add: "
	.align 2
float2:	.asciiz "Enter the second number to add: "
	.align 2
result:	.asciiz "Result: "
	.align 2
new_line:
	.asciiz "\n"
	# Program Memory section
	.text
	.globl main
main:	
	# Prompt the user to enter a number
	li $v0, 4 			#print string
	la $a0, float1 			#"\nEnter the first number to add: "
	syscall
	# Get the first number
	li $v0, 6 			#read float
	syscall
	addi $sp, $sp, -12
	swc1 $f0, 12($sp)		#save float1 to the stack
	
	# Prompt the user to enter a number
	li $v0, 4 			#print string
	la $a0, float2 			#"\nEnter the second number to add: "
	syscall
	
	# Get the second number
	li $v0, 6 			#read float
	syscall
	swc1 $f0, 8($sp)		#save float2 to the stack
	li $v0, 4
	la $a0, result			#"Result: "
	syscall
	
	lw $a0, 12($sp)			#a0 = the first floating number
	lw $a1, 8($sp)			#a1 = the second floating number
	jal add_float			#add_float(float1, float2)
	
	sw $v0, 8($sp)			#get the sum and save to the stack
	swc1 $f0, 8($sp)		#loat the sum back to $f0
	li $v0, 2			#print float
	syscall				#print sum
	li $v0, 4
	la $a0, new_line		#print new line
	syscall
	
	j main				#go on asking the user
	
add_float:
	sw $ra, 4($sp)			#push $ra to the stack
	jal compare_float		#compare_float(float1, float2)
	lw $ra, 4($sp)
	addi $sp, $sp, 12
	
	# add mentisa 1 and 2
	# subtract 2 - 1
	# add 2 + 1 if same sign
	# renormalize
	move $s0, $v0			#s0 = the smaller floating number
	move $s1, $v1			#s1 = the bigger floating number
	srl $s2, $s1, 31		#s2 = the result 
	sll $s2, $s2, 31		#s2 keeps the sign bit larger
	
	sll $t0, $s0, 1
	srl $t0, $t0, 24		#t0 = the smaller number's exponent
	sll $t1, $s1, 1
	srl $s4, $t1, 24		#t1 = the bigger number's exponent
	sub $t0, $t1, $t0		#t0 = the difference between 2 exponents
	
	sll $t2, $s0, 9
	srl $t2, $t2, 9			#t2 = the smaller number's mentisa
	sll $t3, $s1, 9
	srl $t3, $t3, 9			#t3 = the bigger number's mentisa
	
	#Start shifting the mentisa of the smaller number
	addi $t2, $t2, 0x00800000	#make t2 the full mentisa of the smaller number
	srlv $t2, $t2, $t0
	addi $t3, $t3, 0x00800000	#make t3 the full mentisa of the bigger number
	
	srl $t0, $s0, 31		#t0 = the sign bit of the smaller number
	srl $t1, $s1, 31		#t1 = the sign bit of the bigger number
	bne $t0, $t1, dif_sign
same_sign:
	add $s3, $t2, $t3		#s3 = the pre-normalized mentisa of the result
	j normalizing_mentisa
dif_sign:
	sub $s3, $t3, $t2		#s3 = the pre-normalized mentisa of the result
normalizing_mentisa:
	#check if the mentisa is already normalized
	srl $t0, $s3, 23		#t0 = the 24th bit
	bne $t0, 1, is_unnormalized	#if t0 is not equal to 1, the mentisa is not normalized yet
is_normalized:
	sll $s3, $s3, 9			
	srl $s3, $s3, 9			#s3 = normalized mantisa
	j finished_normalizing
is_unnormalized:
	bleu $s3, 0x00800000, over_flow_right
over_flow_left:
	srl $s3, $s3, 1			#s3 = normalized mantisa
	addi $s4, $s4, 1		#s4 = the normalized exponent
	j finished_normalizing
over_flow_right:
	addi $t0, $s3, 0		#t0 = unnormalized mantisa
	srl $t0, $t0, 1			#start shifting it to the right
	addi $t1, $zero, 1		#use t1 to figure out the most significant bit
	addi $t2, $zero, 0		#int i = 0
	addi $t3, $zero, 23		#n = 23, the number of times we shift (used for the for loop)
for:	beq $t0, 0, after_for
	addi $t1, $t1, 1
	srl $t0, $t0, 1
	addi $t2, $t2, 1
	j for
after_for:
	addi $t2, $zero, 24		#int t2 = 24
	sub $t1, $t2, $t1		#t1 = t2 - t1 = the number of bits we need to shift the pre-normalized mentisa
	sllv $s3, $s3, $t1		#s3 = normalized mantisa
	add $s4, $s4, $t1		#s4 = the normalized exponent
	j finished_normalizing
	
finished_normalizing:
	sll $s4, $s4, 23		#shift the exponent to where it should be
	add $s2, $s2, $s4		#add the exponent part to the result
	sll $s3, $s3, 9
	srl $s3, $s3, 9			#shift the mantisa to where it should be
	add $s2, $s2, $s3		#add the mantisa part to the result
	move $v0, $s2			#move the result to v0
	jr $ra				#finish add_float(), return the result

#compare 2 float numbers and return them with the smaller one first and the bigger one second
compare_float:				
	move $t0, $a0			#t0 = floating1
	move $t1, $a1			#t1 = floating2
	sll $t2, $t0, 1
	srl $t2, $t2, 24		#t2 = the exponent of floating1
	sll $t3, $t1, 1
	srl $t3, $t3, 24		#t3 = the exponent of floating2
	bge $t2, $t3, swap_float	#if floating1's exponent > floating2's exponent, swap them
	move $v0, $t0
	move $v1, $t1
	jr $ra				#v0's exponent is smaller
swap_float:
	move $v0, $t1
	move $v1, $t0
	jr $ra				#v0's exponent is smaller
	
	
