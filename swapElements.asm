# Swap 2 elements in an array
# Lab 5.3
# Vo Huy

	# Data Memory Location
	.data
array:	.word -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 100
	.align 2
length:	.word 20
	.align 2
user_input1:
	.asciiz "Enter the first index: "
	.align 2
user_input2:
	.asciiz "Enter the second index: "
	.text
	.globl main
	
main:
	#Prompt user to enter the indexes
	li $v0, 4 		#print string
	la $a0, user_input1	#"Enter the first index: "
	syscall
	li $v0, 5		#read integer
	syscall
	move $a1, $v0		#argument 2: int index 1
	
	li $v0, 4
	la $a0, user_input2	#"Enter the second index: "
	syscall
	li $v0, 5		
	syscall
	move $a2, $v0		#argument 3: int intdex 2
	
	la $a0, array		#argument 1: int *nums
	
	jal swap
		
	li $v0, 10		# EXIT
	syscall
swap:	
	addi $s0, $a0, 0	#the address of the array (the base address)
	
	sll $t0, $a1, 2		#t0 = index1 * 4 = the distance to index1 from the base address
	add $t0, $s0, $t0	#the address of index1
	lw $t1, ($t0)		#int temp = nums[index1]
	
	sll $t2, $a2, 2		#t2 = index2 * 4 = the distance to index2 from the base address
	add $t2, $s0, $t2	#the address of index2
	lw $t3, ($t2)		#t3 = nums[index2]
	
	sw $t3, ($t0)		#nums[index1] = nums[index2]
	sw $t1, ($t2)		#nums[index2] = temp
	
	jr $ra