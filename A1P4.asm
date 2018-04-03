# The initial code on C
# #include <stdio.h>
# int main(void) {
#	int f=1;
#	int x=4;
#	for (int i=1; i<=x; i++) {
#		int y=f;
#		for (int j=1; j<i; j++) f=f+y;
#	}
# }

.text
	add $a0, $zero, 1 # initialize f
	add $a1, $zero, 4 # initialize x
	
	add $v0, $zero, 1 # initialize i loop
	
	sle  $k0, $a1, $v0 # x greater than or equal to i?
	bnez $k0, afterLoops # if not skip the loops
	
loopX: #
	add $a2, $zero, $a0 # initialize y equal to f
	add $v1, $zero, 1 # initialize j loop
	
	slt  $k1, $v0, $a1 # i greater than j?
	bnez $k1, afterLoopJ # if not skip j loop
	
loopJ: #
	add $a0, $a0, $a2 # f = f + y
	
	addi $v1, $v1, 1 # add the step to j loop
	
	slt  $k1, $v0, $v1 # i greater than j?
	beqz $k1, loopJ # if yes repeat j loop
	
afterLoopJ: #
	
	addi $v0, $v0, 1 # add the step to i loop
	
	slt  $k1, $a1, $v0 # x greater than or equal to i?
	beqz $k1, loopX # if yes repeat j loop
	
afterLoops: #