.data
	mystring: .asciiz "0 LIKE to program in MIPS ZzZ"
.text
	j main
is_upper:
	add $v0, $zero, $zero

	slti $t1, $a0, 65
	
	bne $t1, 0, notUpperCase
	
	sleu $t1, $a0, 90
	
	bne $t1, 1, notUpperCase
	
	add $v0, $zero, 1	
notUpperCase:
	jr $ra
main:
	la $t0, mystring
whileNotEOS:
	lbu $a0, 0($t0)
	
	jal is_upper
	
	bne $v0, 1, skipChange
	
	add $a0, $a0, 32
	
	sb $a0, 0($t0)
skipChange:	
	add $t0, $t0, 1
	
	bne $a0, 0, whileNotEOS
	
	add $v0, $zero, 4	
	
	la $a0, mystring
	
	syscall
