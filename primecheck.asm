.text
	j main
prime_check:
	add $sp, $sp, -4
	
	sw $ra, 0($sp)

	beq $a0, 0, is_prime
	beq $a0, 1, is_prime
	beq $a0, 2, is_prime

	divu $t0, $a0, 2
	
	add $v0, $zero, 2
	
	li $t3, 0
loop:
	divu $t1, $a0, $v0
	mfhi $t2
	
	beq $t2, 0, not_prime
	
	add $v0, $v0, 1
	
	add $t3, $t3, 1
	
	bne $t3, $t0, loop
is_prime:
	li $v0, 0
not_prime:
	lw $ra, 0($sp)
	
	add $sp, $sp, 4

	jr $ra
main:
	jal prime_check