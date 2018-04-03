loop:
	addi $v0, $v0, 1
	
	jal collatz
	
	addi $a0, $v1, 0
	
	bne $v1, 1, loop
	
	j exit
collatz:
	andi $t0, $a0, 1
	
	beq $t0, $zero, label

	add $v1, $a0, $a0
	add $v1, $v1, $a0
	addi $v1, $v1, 1

	jr $ra
label:
	srl $v1, $a0, 1

	jr $ra
exit: