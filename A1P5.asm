# The solution code on Java
# int length = array.size ( );
# for ( int i = 0; i < length - 1; i++ )
# {
# 	for ( int j = length - 2; j >= 0; j-- )
# 	{
# 		if ( array [ j ] % 2 != 0 && array [ j+1 ] % 2 == 0 )
# 		{
# 			int temp = array [ j+1 ];
# 			array [ j+1 ] = array [ j ];
# 			array [ j ] = temp;
# 		}
# 	}
# }
.data
array: .word 8 2 3 12 31 32 3 2 1
length: .word 9
# 2 4 6 8 10 1 3 5 7 9
.text
	la $s0, length
	lw $v0, 0($s0) # length = array.size
	
	li $a0, 0 # i = 0
	li $s4, 0
	
	addi $v1, $v0, -1 # length - 1
loopI:
	addi $s2, $s0, -8 # prepare the adress array [ length - 2 ]
	addi $a1, $v0, -2 # j = length - 2
loopJ:
	lw $t0, 0($s2) # load array [ j ]
	lw $t1, 4($s2) # load array [ j + 1 ]
	
	andi $s3, $t0, 1 # check for parity of array [ j ]
	beqz $s3, skipSwap

	andi $s3, $t1, 1 # check for parity of array [ j + 1 ]
	bnez $s3, skipSwap

	sw $t1, 0($s2)
	sw $t0, 4($s2)
skipSwap:
	addi $s2, $s2, -4 # array [ j-- ]
	addi $a1, $a1, -1 # j-
	
	sle $s3, $s4, $a1 # ?
	bnez $s3, loopJ

	addi $a0, $a0, 1 # i++
	
	slt $s3, $a0, $v1 # ?
	bnez $s3, loopI