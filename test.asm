.data
array: .word 1 2 3 4 5 6 7 8 9 10
arraylen: .word 10

.text
main:
	la $a0,array # Disregard this instruction for the counting
	la $t0,arraylen # Disregard this instruction for the counting

	lw $a1,0($t0)
	
	add $v0,$zero,$zero
loop:
	lw $t1,0($a0)
	
	slt $t2,$t1,$v0
	bne $t2,$zero,skip
	
	add $v0,$zero,$t1
skip:
	addi $a0,$a0,4
	addi $a1,$a1,-1
	
	bne $a1,$zero,loop
