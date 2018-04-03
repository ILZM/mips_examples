.data
	q_amount: .asciiz "Input the number of integers\n"
	q_ints: .asciiz "Input the integers\n"
	a_ints: .asciiz "The result is\n"
	blank: .asciiz " "
	enter: .asciiz "\n"
	
.text
	j main
###################################
output_info_proc:
	add $sp, $sp, -12
	sw $v0, 0($sp)
	sw $a0, 0($sp)
	sw $ra, 8($sp)
	
	add $t0, $v0, $zero
	add $t1, $a0, $zero
	
	add $a0, $t1, $zero
	jal print_int_proc
	
	la $a0, blank
	jal print_text_proc
	
	add $a0, $t0, $zero
	jal print_int_proc
	
	la $a0, enter
	jal print_text_proc
	
	lw $v0, 0($sp)
	lw $a0, 4($sp)
	lw $ra, 8($sp)
	add $sp, $sp, 12
	
	jr $ra
###################################
input_ints_proc:
	add $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)

input_ints_loop:
	jal read_int_proc
	sw $v0, 0($s1)
	
	add $s0, $s0, -1
	add $s1, $s1, 4 	
	
	bne $s0, $zero, input_ints_loop
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	add $sp, $sp, 8
	
	jr $ra
###################################
check_print_ints_proc:
	add $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $a0, 8($sp)
	sw $ra, 12($sp)
	
	la $a0, a_ints
	jal print_text_proc
	
	lw $a0, 8($sp)
	
check_print_ints_proc_loop:
	lw $a0, 0($s1)

	jal prime_check_proc
	jal output_info_proc

	add $s0, $s0, -1
	add $s1, $s1, 4
	
	bne $s0, $zero, check_print_ints_proc_loop
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $a0, 8($sp)
	lw $ra, 12($sp)
	
	add $sp, $sp, 16
	
	jr $ra
###################################
prime_check_proc:
	add $sp, $sp, -4
	sw $ra, 0($sp)

	beq $a0, 0, prime_check_is_prime
	beq $a0, 1, prime_check_is_prime
	beq $a0, 2, prime_check_is_prime
	
	add $v0, $zero, 2
	
prime_check_loop:
	divu $t0, $a0, $v0
	mfhi $t0
	
	beq $t0, 0, prime_check_not_prime
	
	add $v0, $v0, 1
	
	mulu $t0, $v0, $v0
	
	ble $t0, $a0, prime_check_loop
	
prime_check_is_prime:
	add $v0, $a0, $zero

prime_check_not_prime:
	lw $ra, 0($sp)
	add $sp, $sp, 4

	jr $ra
###################################
print_text_proc:
	addi $v0, $zero, 4
	syscall

	jr $ra
###################################
read_int_proc:
	addi $v0, $zero, 5
	syscall

	jr $ra
###################################
print_int_proc:
	addi $v0, $zero, 1
	syscall

	jr $ra
###################################
allocate_heap_proc:
	add $v0, $zero, 9
	syscall
	
	jr $ra
###################################
main:
	la $a0, q_amount
	jal print_text_proc
	
	jal read_int_proc
	add $s0, $zero, $v0 # s0 - n
	
	sll $a0, $s0, 2
	jal allocate_heap_proc
	add $s1, $zero, $v0 # s1 - address

	la $a0, q_ints
	jal print_text_proc

	jal input_ints_proc
	jal check_print_ints_proc