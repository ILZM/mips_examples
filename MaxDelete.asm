.data
array: .word 3 2 1
alength: .word 3

.text
	li $a0, 0 # i loop

	la $v0, alength
	lw $s0, 0($v0)

	la $v1, array

	li $t0, 0
loop:
	lw $s1, 0($v1)

	slt $s5, $t0, $s1
	beqz $s5, skipassign
	
	add $t0, $zero, $s1
skipassign:
	addi $a0, $a0, 1

	addi $v1, $v1, 4

	slt $s1, $a0, $s0 # i and length
	bnez $s1, loop
	
	li $a0, 0 # i loop
	
	la $v1, array # refresh the adress of the array
loop2:
	lw $s1, 0($v1)
	
	bne $s1, $t0, skipshift
loop3:
	add $t9, $zero, $v1 # save the previous adress
	addi $v1, $v1, 4

	lw $s1, 0($v1) # k + 1

	sw $s1, 0($t9)

	addi $a0, $a0, 1
	
	slt $s1, $a0, $s0 # i and length
	bnez $s1, loop3
	beqz $s1, skipall
skipshift:
	addi $a0, $a0, 1
	
	addi $v1, $v1, 4
	
	slt $s1, $a0, $s0 # i and length
	bnez $s1, loop2
skipall:
	li $s1, 0
	
	sw $s1, 0($t9)