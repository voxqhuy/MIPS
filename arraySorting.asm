# Sorting Arrays
# Lab 5.4
# Vo Huy
	# Data Memory Location
	.data
array1:	.word 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -100
	.align 2
length1:.word 20
	.align 2
array2:	.word -20, 8, -4, 3, -3, 4, -8, 20
	.align 2
length2:.word 8
	.align 2
array3:	.word -9, -1, 0, 3, 9, 100, 1
	.align 2
length3:.word 7
	.align 2
array4:	.word -99, -100, -1, -3, -9, -99, -100, -3, -1, -9
	.align 2
length4:.word 10
	.align 2
hex:	.space 40
	.align 2
comma:	.asciiz ", "
	.align 2
newline: .asciiz "\n"
	.align 2
original_array:
	.asciiz "The original array: "
sorted_array:
	.asciiz "The sorted array: "
	.text
	.globl main
main:
	#       ORIGINAL ARRAY 1
	li $v0, 4       		
	la $a0, original_array		#"The original array: "
	syscall
	la $a0, array1	
	lw $a1, length1
	jal print_array 		#Original array 1
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	#       SORTING ARRAY 1
	li $v0, 4       		
	la $a0, sorted_array		#"The sorted array: "
	syscall
	la $a0, array1	
	jal selection_sort		#selection_sort(*array1, length1)
	jal print_array			#Sorted array 1
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	
	#       ORIGINAL ARRAY 2
	li $v0, 4       		
	la $a0, original_array		#"The original array: "
	syscall
	la $a0, array2		
	lw $a1, length2
	jal print_array 		
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	#       SORTING ARRAY 2
	li $v0, 4       		
	la $a0, sorted_array		#"The sorted array: "
	syscall
	la $a0, array2
	jal selection_sort		#selection_sort(*array2, length2)
	jal print_array			
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	
	#       ORIGINAL ARRAY 3
	li $v0, 4       		
	la $a0, original_array		#"The original array: "
	syscall
	la $a0, array3		
	lw $a1, length3
	jal print_array 		
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	#       SORTING ARRAY 3
	li $v0, 4       		
	la $a0, sorted_array		#"The sorted array: "
	syscall
	la $a0, array3
	jal selection_sort		#selection_sort(*array3, length3)
	jal print_array			
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	
	#       ORIGINAL ARRAY 4
	li $v0, 4       		
	la $a0, original_array		#"The original array: "
	syscall
	la $a0, array4		
	lw $a1, length4
	jal print_array 		
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	#       SORTING ARRAY 4
	li $v0, 4       		
	la $a0, sorted_array		#"The sorted array: "
	syscall
	la $a0, array4
	jal selection_sort		#selection_sort(*array4, length4)
	jal print_array			
	li $v0, 10			#EXIT
	syscall
	li $v0, 4       		
	la $a0, newline      	 	#newline
	syscall
	
#void SELECTION_SORT(int *nums, int length)
selection_sort:
	addi $sp, $sp, -8		
	sw $ra, 8($sp)			#push $ra to the stack
	
	addi $s0, $a1, 0		#s0 = length
	addi $s1, $zero, 0		#int i = 0
for11:	bge $s1, $s0, after_for11	#if i >= length, exit the loop

	addi $s2, $s1, 0		#index_of_min = i;
	addi $s3, $s1, 0		#int j = i
	j for22
after_for22:
	#SWAPPING ELEMENTS
	sw $a1, 4($sp)			#push a1 of selection_sort (length) to the stack
	#a0 is still *sum
	addi $a1, $s1, 0		#a1 = i
	addi $a2, $s2, 0		#a2 = index_of_min
	jal swap
	lw $a1, 4($sp)			#pop a1 of selection_sort (length) from the stack
	
	add $s1, $s1, 1			#i++
	j for11				#looping for1
for22:	bge $s3, $s0, after_for22	#if j >= length, exit the loop
	
	sll $t0, $s2, 2			#t0 = index_of_min*4 the distance from the element to the base adress
	add $t0, $t0, $a0		#the address of nums[index_of_min]
	lw $t1, ($t0)			#nums[index_of_min]
	
	sll $t0, $s3, 2			#t0 = j*4 the distance from the element to the base adress
	add $t0, $t0, $a0		#the address of nums[j]
	lw $t2, ($t0)			#nums[j]
	
	ble $t1, $t2, skip_new_min
	addi $s2, $s3, 0
skip_new_min:
	add $s3, $s3, 1			#j++
	j for22				#looping for1

after_for11:
	lw $ra, 8($sp)			#pop $ra from the stack for selection_sort function
	addi $sp, $sp, 8		
	jr $ra				#finish selection_sort function
	
#void SWAP(int *nums, index1, index2)
swap:	
	addi $s7, $a0, 0		#the address of the array (the base address)
	
	sll $t4, $a1, 2			#t4 = index1 * 4 = the distance to index1 from the base address
	add $t4, $s7, $t4		#the address of index1
	lw $t5, ($t4)			#int temp = nums[index1]
	
	sll $t6, $a2, 2			#t2 = index2 * 4 = the distance to index2 from the base address
	add $t6, $s7, $t6		#the address of index2
	lw $t7, ($t6)			#t3 = nums[index2]
	
	sw $t7, ($t4)			#nums[index1] = nums[index2]
	sw $t5, ($t6)			#nums[index2] = temp
	jr $ra

#void PRINT_ARRAY(int *nums, int length)
print_array:
	addi $sp, $sp, -4
	sw $ra, 4($sp)			#push $ra of print_array to the stack
	la $s5, ($a0)			#adress of nums
	addi $t1, $a1, 0		#t1 = length
	addi $t7, $a1, -1		#t7 = length - 1
	addi $s4, $zero, 0 		#int i = 0;
loop_myarray:	
	bge $s4, $t1, after_loop_myarray# if i >= length run after_for1
	lw $a0, ($s5)			#load each number to print out
	
	jal print_hex			#print_hex(a0)
	
	beq $s4, $t7, skip_comma	#skip the comma at the end of the sequence
	li $v0, 4 			#print string
	la $a0, comma 			#, "
	syscall
skip_comma:
	addi $s5, $s5, 4		#next number
	addi $s4, $s4, 1		#i++
	j loop_myarray
after_loop_myarray:
	lw $ra, 4($sp)			#pop $ra of print_array from the stack
	addi $sp, $sp, 4
	jr $ra				#going back to jal print_array
	
print_hex:
	addi $sp, $sp, -4
	sw $ra, 4($sp)
	add $s6, $a0, $zero		#s6 = array element
	
	la $s0, hex 			#adress of result
	addi $t0, $zero, 48 		#set $t0 to 48
	sw $t0, 0($s0)          	#store 48('0') at location 0 in result
	addi $t0, $0, 120       	#set $t0 equal to 120
        sw $t0, 4($s0)          	#store 120('x) at location 1 in $a1
	addi $s1, $s0, 36 		# adress of location 9 in result

	addi $s2, $zero, 0 		# int i = 0;
for3:	bge $s2, 8, after_for3		# if i >= 8 run after_for3
	move $a0, $s6 			#set user input as argument 0 for converting hex function
	
	jal convert_hex			#convert_hex(user input)
	
	move $t1, $v0			# update the new adress to convert
	srl $s6, $s6, 4			#shift right 4 bits to deal with the next 4digit number
	addi $s2, $s2, 1 		# i++
	j for3 				# looping	
after_for3:
	# loop through the 'result' array to print out one by one character
	addi $s2, $zero, 0		# int i = 0
for4:	bge $s2, 10, after_for4		# if i >= 10 run after_for4
	li $v0, 4 			# print string
	la $a0, ($s0)			# print each character in result
	syscall
	addi $s0, $s0, 4		# move to the next character
	addi $s2, $s2, 1 		# i++
	j for4 				# looping
after_for4: 				
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	#finished print_hex()
	jr $ra				#going back to jal print_hex	
convert_hex:
	
	andi $s3, $a0, 0x0f 		# get the last 4 digit
	ble $s3, 9, lessThan9
	addi $s3, $s3, 7
lessThan9:
	addi $t3, $s3, 48
	sw $t3, ($s1)			#result[s1] = hex number
	subi $s1, $s1, 4 		#move to the next address on the left
	jr $ra				#going back to jal convert_hex
