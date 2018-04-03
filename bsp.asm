.data
	TOP: .word ROOT
	ROOT: .word NODE1,NODE2
	.float 5.0
	NODE1: .word 0,0
	.float 3.3
	NODE2: .word NODE3,0
	.float 8.7
	NODE3: .word 0,0
	.float 6.3
	
	ZERO: .float 0.0
###################################################
.text
	j main
###################################################
# a0 - the size of the value in bytes
# v0 - the address of the value
make_node_bst:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	
	addi $v0, $zero, 9
	add $a0, $a0, 8
	syscall
	
	# 0(v0) = left child
	# 4(v0) - right child
	# 8(v0) - value
	
	sw $zero, 0($v0)
	sw $zero, 4($v0)

	lw $a0, 0($sp)
	add $sp, $sp, 4
	
	jr $ra
###################################################
# a0 - the address of the new node
# a1 - the address of the current node
# a2 - left or right child of the current node
insert_bst:
	beq $a2, 1, insert_bst_right_child

	sw $a0, 0($a1)

	j insert_bst_skip_right_child
	
insert_bst_right_child:
	sw $a0, 4($a1)
	
insert_bst_skip_right_child:
	jr $ra
###################################################
# f2 - float to compare
# $f0 - float to compare
# v0 - returns the result; 0 - left, 1 - equal, 2 - left
compare_float_proc:
	c.eq.s $f0, $f2

	bc1t compare_float_notequal

	add $v0, $zero, 1
	
	j compare_float_return

compare_float_notequal:
	c.lt.s $f0, $f2
	
	bc1t compare_float_larger
	
	add $v0, $zero, 2
	
	j compare_float_return
	
compare_float_larger:
	add $v0, $zero, 0
	
compare_float_return:
	jr $ra
###################################################
# a0 - the address of  the root
# f12 - the number to search
# v0 - -1 in the case the tree already ccntains the value and v1 - value's adreess
# otherwise, v1 - the node address for insertion and v0 - 0 or 1 depending on the side
search_bst_proc:
	add $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)

search_bst_while:
	mov.s $f0, $f12
	lwc1 $f2, 8($a0) # get the node value

	jal compare_float_proc

	beq $v0, 1, search_bst_found_value
	beq $v0, 0, search_bst_left_child
	
	lw $t0, 4($a0)

	bne $t0, $zero, search_bst_right_child_notnull

	add $a1, $a0, $zero
	add $a0, $t0, $zero
	add $a2, $zero, 1

	jal insert_bst

	add $v0, $zero, 0
	add $v1, $t0, $zero

	j search_bst_end

search_bst_right_child_notnull:
	move $t0, $a0

	j search_bst_while

search_bst_found_value:
	add $v0, $zero, -1
	add $v1, $zero, $a0

	j search_bst_end

search_bst_left_child:
	lw $t0, 0($a0)

	bne $t0, $zero, search_bst_left_child_notnull

	add $a1, $a0, $zero
	add $a0, $t0, $zero
	add $a2, $zero, 0

	jal insert_bst

	add $v0, $zero, 0
	add $v1, $t0, $zero

	j search_bst_end

search_bst_left_child_notnull:
	move $a0, $t0

	j search_bst_while

search_bst_end:
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	add $sp, $sp, 8
	
	jr $ra
###################################################
main:	
	lwc1 $f8, ZERO
	
	lw $a0, TOP
	
main_input_loop:
	add $v0, $zero, 6
	syscall
	
	c.eq.s $f8, $f0
	
	bc1t main_end
	
	mov.s $f12, $f0
	
	jal search_bst_proc
	
	beq $v0, -1, main_found
	
	j main_input_loop
	
main_end:

main_found:
	add $v0, $zero, 1
	add $a0, $v1, $zero
	syscall