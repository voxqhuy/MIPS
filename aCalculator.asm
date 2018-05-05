# A calculator
# Lab 9
	# Data Memory Section
	.data
	# Program Memory section
	.text
	.globl start
start:	
	#a registers are operations
	#t values are numbers

	addi $a0, $a0, 0x00000079		#add
	addi $a1, $a1, 0x0000007B		#subtract
	addi $a2, $a2, 0x0000007C		#multiply
	addi $a3, $a3, 0x0000E04A		#divide

	addi $at, $at, 0x0000005A		#enter regular keyboard (not numpad)

	addi $t0, $t0, 0x00000069		#1
	addi $t1, $t1, 0x00000072		#2
	addi $t2, $t2, 0x0000007A		#3
	addi $t3, $t3, 0xE012E070		#4
	addi $t4, $t4, 0x00000073		#5
	addi $t5, $t5, 0x00000074		#6
	addi $t6, $t6, 0x0000006C		#7
	addi $t7, $t7, 0x0000006C		#8
	addi $t8, $t8, 0x00000075		#9
	addi $t9, $t9, 0x0000007D		#0
getting_num1:
	addi $s7, $zero, 0	# num1 = 0
	addi $s5, $zero, 0	# number = 0
	
getting_first_num:	
	# Note: all io instructions assume they are working in VHDL
	lw $s3, 0($s0)  # io instruction 0x8000 0000: loads keyboard value to $s3
	
	addi $s4, $zero, 0	# position = 0
	bne $s3, $t0, not_one
	addi $s5, $zero, 1	# number = 1
	j got_number
not_one:
	bne $s3, $t1, not_two
	addi $s5, $zero, 2	# number = 2
	j got_number
not_two:
	bne $s3, $t2, not_three
	addi $s5, $zero, 3	# number = 3
	j got_number
not_three:
	bne $s3, $t3, not_four
	addi $s5, $zero, 4	# number = 4
	j got_number
not_four:
	bne $s3, $t4, not_five
	addi $s5, $zero, 5	# number = 5
	j got_number
not_five:
	bne $s3, $t5, not_six
	addi $s5, $zero, 6	# number = 6
	j got_number
not_six:
	bne $s3, $t6, not_seven
	addi $s5, $zero, 7	# number = 7
	j got_number
not_seven:
	beq $s3, $t7, not_eight
	addi $s5, $zero, 8	# number = 8
	j got_number
not_eight:
	bne $s3, $t8, not_nine
	addi $s5, $zero, 9	# number = 9
	j got_number
not_nine:
	bne $s3, $t9, not_number
	addi $s5, $zero, 0	# number = 0
	j got_number
not_number:
	beq $s3, $at, done_first_num # pressed enter, break the loop
got_number:
	sll $s2, $s4, 2		# s2 = pos * 4
	sllv $s1, $s5, $s2	# s1 = number << pos*4
	add $s7, $s7, $s1	# num += s1
		
	add $s4, $t8, 1		# position++
	j getting_first_num	# keep looping

done_first_num:
	addi $sp, $sp, 12
	sw $s7, 12($sp)		# 12($sp) = num1
	
getting_operation:
	# Note: all io instructions assume they are working in VHDL
	lw $s3, 0($s0)  # io instruction 0x8000 0000: loads keyboard value to $s3
got_op:	sw $s3, 8($sp) 	# 8($sp) = operation
	

	addi $s7, $zero, 0	# num2 = 0
	addi $s5, $zero, 0	# number = 0
	
getting_second_num:	
	# Note: all io instructions assume they are working in VHDL
	lw $s3, 0($s0)  # io instruction 0x8000 0000: loads keyboard value to $s3
	
	addi $s4, $zero, 0	# position = 0
	bne $s3, $t0, not_one
	addi $s5, $zero, 1	# number = 1
	j got_number
not_one2:
	bne $s3, $t1, not_two
	addi $s5, $zero, 2	# number = 2
	j got_number
not_two2:
	bne $s3, $t2, not_three
	addi $s5, $zero, 3	# number = 3
	j got_number
not_three2:
	bne $s3, $t3, not_four
	addi $s5, $zero, 4	# number = 4
	j got_number
not_four2:
	bne $s3, $t4, not_five
	addi $s5, $zero, 5	# number = 5
	j got_number
not_five2:
	bne $s3, $t5, not_six
	addi $s5, $zero, 6	# number = 6
	j got_number
not_six2:
	bne $s3, $t6, not_seven
	addi $s5, $zero, 7	# number = 7
	j got_number
not_seven2:
	beq $s3, $t7, not_eight
	addi $s5, $zero, 8	# number = 8
	j got_number
not_eight2:
	bne $s3, $t8, not_nine
	addi $s5, $zero, 9	# number = 9
	j got_number
not_nine2:
	bne $s3, $t9, not_number
	addi $s5, $zero, 0	# number = 0
	j got_number
not_number2:
	beq $s3, $at, done_second_num # pressed enter, break the loop
got_number2:
	sll $s2, $s4, 2		# s2 = pos * 4
	sllv $s1, $s5, $s2	# s1 = number << pos*4
	add $s7, $s7, $s1	# num += s1
		
	add $s4, $t8, 1		# position++
	j getting_second_num	# keep looping

done_second_num:
	sw $s7, 4($sp)		# 4($sp) = num2

calculation:
	lw $t0, 12($sp)
	lw $t1, 8($sp)
	lw $t2, 4($sp)
	addi $sp, $sp, 12
 
	# add, subtract, multiply, or divide

	bne $t1, $a0, not_add
	add $s7, $t0, $t2
	j done_calculation
not_add: 
	bne $t1, $a1, not_subtract
	sub $s7, $t0, $t2
	j done_calculation
not_subtract: 
	bne $t1, $a2, not_multiply
	mul $s7, $t0, $t2
	j done_calculation
not_multiply:
	bne $t1, $a3, not_divide
	div $s7, $t0, $t2
not_divide:
done_calculation:

framebuffer:
	# not necessarily $s7, whatever register has the answer
	sw $s7, 1($s0)  # io instruction 0x8000 0001: stores address value to frame_buffer
	sw $s7, 2($s0)  # io instruction 0x8000 0002: stores data value to frame_buffer
	sw $s7, 3($s0)  # io instruction 0x8000 0003: sets wren value high to frame_buffer
	sw $s7, 4($s0)  # io instruction 0x8000 0004: sets wren value low to frame_buffer  

	li $v0, 10 
	syscall
