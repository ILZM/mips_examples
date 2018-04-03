.data
array: .word 1 6 2 10 29
alength: .word 5

.text
	li $s1, 1

	la $v0, alength
	lw $s0, 0($v0) # s0 = arraylength;

	add $s2, $s0, $zero # pseudolength = arraylength;
while:
	li $t0, 0 # max = 0;
	li $t1, 0 # maxindex = 0;

	li $a0, 0 # i = 0;

	la $v1, array # refresh iterator
loopmax:
	lw $t8, 0($v1) # load array[i]

	slt $t9, $t0, $t8 # if max < array[i]
	beqz $t9, skipassignmax

	add $t0, $t8, $zero # max = array[i];
	add $t1, $v1, $zero # maxindex = i;
skipassignmax:
	addi $a0, $a0, 1 for ( int i = 0; i < length; i++ )

	addi $v1, $v1, 4

	slt $t9, $a0, $s0 
	bnez $t9, loopmax

	li $t2, 0 # lessmax = 0;
	li $t3, 0 # lessmaxindex = 0;

	li $a0, 0 # i = 0;

	la $v1, array # refresh iterator
looplessmax:
	lw $t8, 0($v1) # load array[i]

	slt $t9, $t2, $t8 # if lessmax < array[i]
	slt $s7, $t8, $t0 # if array[i] < max

	add $s6, $t9, $s7

	beq $s6, $s1, skipassignlessmax

	add $t2, $t8, $zero # lessmax = array[i];
	add $t3, $v1, $zero # lessmaxindex = i;
skipassignlessmax:
	addi $a0, $a0, 1

	addi $v1, $v1, 4

	slt $t9, $a0, $s0
	bnez $t9, looplessmax

	sub $t4, $t0, $t2 # difference = max - lessmax;

	sw $t4, 0($t1) # array[maxindex] = difference;
	sw $zero, 0($t3) # array[lessmaxindex] = 0;

	subi $s2, $s2, 1 # pseudolength--;

	slt $t9, $s1, $s2 # while(pseudolength > 1)
	bnez $t9, while

	add $v0, $t4, $zero