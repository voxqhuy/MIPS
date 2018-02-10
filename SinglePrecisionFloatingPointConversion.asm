# Integers to IEEE 754 single-precision floating-point numbers conversion
# Vo Huy
	# Data Memory Section
	.data
number:	.asciiz "Enter a number: "
	.align 2
hex:	.space 40
	# Program Memory section
	.text
	.globl main
main:	
	# Prompt the user to enter a number
	li $v0, 4 			#print string
	la $a0, number 			#"Enter a number: "
	syscall
	# Get the number
	li $v0, 5 			#read integer
	syscall
	add $a0, $v0, $zero		#a0 = user_input
	jal conversion			#conversion(int user_input)
	
	add $a0, $v0, $zero		#a0 = converted_number
	jal print_hex			#print_hex(converted_number)
	j main				#go on asking the user
conversion:
	addi $s0, $a0, 0		#s0 = the integer
	bne $s0, 0, not_zero		#Check if the integer is 0
	addi $v0, $zero, 0		#return 0
	jr $ra
not_zero:				#The number is not zero
	#Check if it is negative
	srl $s1, $s0, 31		#Shift right to move the sign bit to the most right bit (1st bit)
	beq $s1, 0, positive		#The sign bit is 0, it is positive
nagtive:#Convert it to positive
	not $s0, $s0			#convert all 1s to 0s and 0s to 1s
	addi $s0, $s0, 1		#add 1
positive:
	sll $s1, $s1, 31		#s1 = either 0x1000000 if the int is neg, or 0x00000000 if the int is positive
	addi $s2, $zero, 0		#int exponent = 0
	addi $t0, $s0, 0		#t0 = s0
while:	beq $t0, 1, end_while		#if the integer is 1, the exponent will be 0, break
	srl $t0, $t0, 1			#shift right until get to the furthest '1' on the left
	addi $s2, $s2, 1		#exponent += 1
	j while
end_while:
	addi $t0, $zero, 32		#t0 = 32
	sub $t1, $t0, $s2		#t1 is the position of 1st number of the fraction part, counted from the right=32 - exponent
	addi $s2, $s2, 127		#Exponent in the biased form = exponent + 127
	#separate the fraction part
	sllv $s0, $s0, $t1		
	srl $s0, $s0, 9			#s0 = the fraction part
	#Add 3 parts together: sign bit, exponent, and the fraction part to get the converted number
	add $s1, $s1, $s2		#result = sign bit + exponent
	add $s1, $s1, $s0		#result = result + fraction part
	
	addi $v0, $s1, 0		#return the converted number
	jr $ra

#print_hex(int num)
print_hex:
	addi $sp, $sp -4
	sw $ra, 4($sp)			#push $ra to the stack
	
	add $s6, $a0, $zero		#s6 = converted_number
	
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
	lw $ra, 4($sp)			#pop $ra from the stack
	addi $sp, $sp, 4	
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
	
	