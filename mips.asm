# All MIPS operations
# Lab 5.2
	# Data Memory Section
	.data
	# Program Memory section
	.text
	.globl start
	
start:	addi $t0, $zero, 0x00000000
	addiu $t1, $t0, 0x00000001
	add $t2, $t0, $t1
	add $t5, $t1, $t2	# t5 = 2
	addu $t3, $t0, $t1
	
	and $t4, $t0, $t1
	andi $t4, $t0, 1
	
	beq $t1, $t2, test_beq
	bne $t1, $t0, test_bne
test_beq:
	nop
	j test_j
test_bne:
	nop
	jal test_jal
test_j:	lui $t0, 0xffff
	nor $t4, $t0, $t1
	or $t4, $t0, $t1
	ori $t4, $t0, 1
	
	slt $t4, $t0, $t1
	slti $t4, $t0, 1
	
	sll $t4, $t1, 2
	srl $t3, $t4, 1
	sllv $t4, $t1, $t5
	srlv $t3, $t4, $t1
	sw $t1, 0($t3)
	
	sub $t3, $t0, $t1
	subu $t3, $t0, $t1

test_jal:
	lw $t3, 0($t1)
	jr $ra
	
	li $v0, 10 
	syscall