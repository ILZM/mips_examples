.data
	string: .asciiz "amipsspima"
.text
	j main
find_length:
	add $sp, $sp, -8
	
	sw $a0, 0($sp)
	sw $ra, 4($sp)

	li $v0, 0
while_fl:
	lbu $t0, 0($a0)
	
	beq $t0, 0, found_length
	
	add $a0, $a0, 1
	add $v0, $v0, 1
	
	j while_fl
found_length:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	
	add $sp, $sp, 8

	jr $ra
is_palindrome:
	add $sp, $sp, -12
	
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)

	add $a1, $a0, $v0
	add $a1, $a1, -1
	
	div $t2, $v0, 2
	
	li $t3, 0
loop_p:
	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	
	bne $t0, $t1, different_letters
	
	add $a0, $a0, 1
	add $a1, $a1, -1
	
	add $t3, $t3, 1
	
	bne $t3, $t2, loop_p
palindrom_yes:
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)

	add $sp, $sp 12

	li $v0, 1
	
	jr $ra
different_letters:
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	
	add $sp, $sp 12

	li $v0, 0
	
	jr $ra
main:
	la $a0, string
	
	jal find_length
	jal is_palindrome