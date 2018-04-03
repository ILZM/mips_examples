#ISSUE: The program does not want to print the string of the the binary number.
# Apparently, the problem is that store byte operator does not convert 0 decimal to 0 ascii.
# For example, to print 0 from data storage it needs to be 1768693808

.data
	result_string: .space 33
.text
	j main
num_to_string:
	add $t0, $a0, $zero
	add $t1, $a3, $zero
	
	mulu $s1, $t1, 4
	
	add $a2, $a2, $s1
	
loop:
	divu $t0, $a1
	
	mfhi $t2	# remainder
	mflo $t0	# quotient
	
	move $s0, $t2  
	
	sb $s0, -4($a2)
	
	add $a2, $a2, -4
	add $t1, $t1, -1
	bne $t1, 0, loop

	jr $ra
main:
	addi $a0, $zero, 28
	addi $a1, $zero, 8
	la $a2, result_string
	addi $a3, $zero, 4
	
	jal num_to_string         #procedure call
              
	add $v0, $zero, 4	
	la $a0, result_string
	syscall