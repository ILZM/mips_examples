.data
	CHARBUFFER: .byte  0,0
	DELIMITERS: .byte  32,44,0,46, -1
	g1: .asciiz "Enter file name: "
	g2: .asciiz "Enter a word to search for: "
.text

# prints a char %x to the screen

.macro print_char (%x)
sw $a0, -4($sp)
sw $v0, -8($sp)
add $v0, $0, 11
add $a0, $0, %x
syscall
lw $v0, -8($sp)
lw $a0, -4($sp)
.end_macro

# reads a char into %x from %y identificator

.macro read_char (%x, %y)
sw 	$a0, -4($sp)
sw 	$v0, -8($sp)
sw 	$a1, -12($sp)
sw 	$a2, -16($sp)

li 	$v0, 14
move 	$a0, %y
la 	$a1, CHARBUFFER
li 	$a2, 1
syscall
lbu	%x, 0($a1)
bne 	$v0, 0, empty
li 	%x, -1

empty:
lw 	$a2, -16($sp)
lw 	$a1, -12($sp)
lw 	$v0, -8($sp)
lw 	$a0, -4($sp)

.end_macro

# if %x is delimiter then %y will be assigned to 1, else to 0

.macro is_delimit (%x, %y)
sw 	$s0, -4($sp)
sw	$t3, -8($sp)
sw	$t4, -12($sp)
la 	$t3, DELIMITERS
li 	$s0, 5
proc_1:
lb 	$t4, 0($t3)
beq 	%x, $t4, proc_2
addi 	$t3, $t3, 1
addi 	$s0, $s0, -1
bne 	$s0, $0, proc_1
li 	%y, 0
j proc_3
proc_2:
li	%y, 1
proc_3:

lw 	$s0, -4($sp)
lw 	$t3, -8($sp)
lw 	$t4, -12($sp)
.end_macro

# deletes a \n symbol from the end of %a

.macro delete_n (%a)
sw 	$t0, -4($sp)
sw 	$t1, -8($sp)
add 	$t0, %a, $0
proc_4:
	lb 	$t1, 0($t0)
	addi 	$t0, $t0, 1
	bne 	$t1, 10, proc_4
sb 	$0, -1($t0)
lw 	$t0, -4($sp)
lw 	$t1, -8($sp)
.end_macro

# reads a string from a user into %a

.macro get_the_string (%a)
sw	$v0, -4($sp)
sw 	$a0, -8($sp)
li 	$v0, 9
li 	$a0, 20
syscall
add 	%a, $v0, $0

li 	$v0, 8
add 	$a0, %a, $0
li 	$a1, 20
syscall

lw 	$v0, -4($sp)
lw 	$a0, -8($sp)
.end_macro

# macro for printing int, mostly for debug purposes

.macro print_integer (%a)
sw 	$a0, -4($sp)
sw 	$v0, -8($sp)
li 	$v0, 1
add 	$a0, %a, $0
syscall
lw 	$a0, -4($sp)
lw 	$v0, -8($sp)
.end_macro

# macro for printing a string

.macro print_the_string (%a)
sw 	$a0, -4($sp)
sw 	$v0, -8($sp)
li	$v0, 4
move	$a0, %a
syscall
lw 	$a0, -4($sp)
lw	$v0, -8($sp)

.end_macro



j main

# a3 - adress of string to write to
# v0 - 0 if eof is reached, 1 if not
# s0 - the stream id

read_delimit:
	li	$s1, 0
	move 	$s2, $a3
	proc_5:
	read_char ($t0, $s0)
	bne 	$t0, -1, if_ok
	li	$v0, 0
	jr	$ra
	if_ok:
	is_delimit ($t0, $t1)
	beq 	$t1, 1, proc_5
	
	proc_6:
	sb 	$t0, 0($s2)
	addi 	$s2, $s2, 1
	read_char ($t0, $s0)
	is_delimit ($t0, $t1)
	bne 	$t1, 1, proc_6
	# adds 0 in the end of string
	sb	$0, ($s2)
	bne 	$t0, -1, not_end_of_file
	
	li 	$v0, 0
	jr 	$ra
	not_end_of_file:
	li 	$v0, 1
	jr 	$ra
	
# 12 bytes for a node
# a1 - adress of string
# v0 - adress of node
create_node_bst:
	li 	$a0, 12
	
	addi 	$v0, $0, 9
	syscall
	sw 	$0, 0($v0)
	sw 	$0, 4($v0)
	sw	$a1, 8($v0)
	jr 	$ra
	
# a1 - insert to
# a2 - 0 if left, 1 if right son
# a0 - node to insert	

insert_node_bst:
	beq 	$a2, 0, left_child
	addi 	$a1, $a1, 4
	left_child:
	
	sw $a0, 0($a1)
	jr $ra

# a0, first string
# a1, second string
# returns -1, if a0 < a1, 0, if a0 = a1, 1 if a0 > a1
comp_string:	
	loop:
	lb 	$t0, 0($a0)
	lb 	$t1, 0($a1)
	
	bne 	$t0, 0, loop_1
	bne 	$t1, 0, loop_2
	li 	$v0, 0
	jr 	$ra
	loop_1:
	bne 	$t1, 0, loop_4
	li	$v0, 1
	jr	$ra
	loop_4:
	
	beq 	$t0, $t1, if_equal
	blt 	$t0, $t1, if_less
	li 	$v0, 1
	jr 	$ra	
	if_equal:
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	j loop	
	if_less:
	li 	$v0, -1
	jr 	$ra	
	loop_2:
	li 	$v0, -1
	jr 	$ra




# a0, searched in
# a1, searched for
# v0, -1, if already exists, 0, ifleft son, 1 if right son
# v1, node to insert to

search_bst:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)
	loop_sb:
	# compare strings
	sw	$a0, -4($sp)
	sw 	$a1, -8($sp)
	addi 	$sp, $sp, -8
	
	lw	$t0, 8($a0)
	move 	$a0, $a1
	move 	$a1, $t0
	
	jal 	comp_string
	
	addi 	$sp, $sp, 8
	lw 	$a0, -4($sp)
	lw	$a1, -8($sp)
	
	# either found, or to the left child or to the right child
	
	beq 	$v0, 0, equal_sb
	beq	$v0, -1, left_child_sb
	j	right_child_sb
	equal_sb:
	# equal, means found
	addi 	$v0, $0, -1
	addi 	$v1, $a0, 0
	
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 4
	jr 	$ra	
	left_child_sb:
	# should be in left child
	lw 	$t0, 0($a0)
	beq 	$t0, 0, no_left_child
	# if left child exists, then call repeat search with it
	addi 	$a0, $t0, 0
	j loop_sb
	no_left_child:
	# no left child, it's the spot!
	addi 	$v1, $a0, 0
	addi 	$v0, $0, 0
	
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 4
	
	jr 	$ra
	right_child_sb:
	# should be in right child
	lw 	$t0, 4($a0)
	beq 	$t0, 0, no_right_child
	# if right child exists, then repeat search in it
	addi 	$a0, $t0, 0
	j loop_sb
	no_right_child:
	# no right child, it's the spot!
	addi 	$v1, $a0, 0
	addi 	$v0, $0, 1
	
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 4
	
	jr 	$ra

# recursion which outputs the elements of bst in ascending order

output:
	# if not a node then return
	bne 	$a1, 0, no_node
	jr 	$ra
	no_node:
	# output the left child first
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)

	addi 	$sp, $sp, -4
	sw 	$a1, 0($sp)
	lw 	$a1, 0($a1)
	jal output
	lw 	$a1, 0($sp)
	
	#output yourself
	
	lw 	$t0, 8($a1)
	print_the_string ($t0)
	print_char (10)	
	
	#output right child
	lw 	$a1, 0($sp)
	lw 	$a1, 4($a1)
	jal 	output
	addi 	$sp, $sp, 4
	
	
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 4	
	jr 	$ra


main:
	# get file name
	la $t0, g1
	print_the_string ($t0)
	get_the_string ($s5)
	# delete \n from the end of file
	delete_n ($s5)
	#open it
	li 	$v0, 13
	move 	$a0, $s5 
	li 	$a1, 0
	li	$a2, 0
	syscall
	move 	$s0, $v0
	li 	$s4, 0
	
	main_loop:
	# allocate memory for new string
	li 	$a0, 20
	li	$v0, 9
	syscall
	move 	$s6, $v0
	move 	$a3, $v0
	
	#read it
	jal 	read_delimit
	# if nothing more to read then proc_8 to next part
	beq 	$v0, 0, proc_8
	
	#makes new node
	move 	$t0, $s6 	
	move 	$a1, $t0
	jal 	create_node_bst	
	addi	$sp, $sp, -4
	sw 	$v0, 0($sp)
	
	# if there were nodes before, current node becomes root
	bne 	$s4, 0, not_first
	
	move 	$s4, $v0	
	addi 	$sp, $sp, 4
	j 	main_loop
	not_first:
	# if not then search the tree for the place to put current node
	addi 	$s7, $s7, 1
	move 	$a0, $s4
	move 	$a1, $s6
	jal 	search_bst
	
	
	#if the string already exists in bst then just repeat everything
	beq 	$v0, -1, main_loop
	
	# insert to the found spot
	
	move 	$a1, $v1
	move 	$a2, $v0
	lw 	$a0, 0($sp)
	addi 	$sp, $sp, 4
	
	jal 	insert_node_bst
					
	j 	main_loop
	
	proc_8:
	
	# output the elements of bst
	
	move 	$a1, $s4
	jal 	output


	# feel some teen spirit in part 2
	teen_spirit:
	
	la $t0, g2
	print_the_string ($t0)
	
	get_the_string ($s5)
	delete_n ($s5)
	
	# if 0 elements in a string then terminate
	lb 	$t0, 0($s5)	
	beq 	$t0, 0, the_end
	
	# search for string in bst
	move 	$a0, $s4
	move 	$a1, $s5	
	jal 	search_bst
	
	bne 	$v0, -1, no_smell
	#found, prints +
	print_char (43)
	print_char (10)
	no_smell:
	j teen_spirit
	the_end:
