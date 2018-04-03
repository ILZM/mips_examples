.text
	j main
collatz_map:
	addi $sp, $sp, -4
	
	sw $ra, 0($sp)
	
	bne 
main:
	
	
	jal collatz_map