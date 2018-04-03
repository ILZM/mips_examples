.data 
	DISPLAYSPACE: .space 65536 # reserve space at the beginning of .data segment for the bitmap 
	DISPLAYSIZE: .word 128
	RADIUS: .word 128

	RED: .word 0xff0000
	GREEN: .word 0x00ff00
	BLUE: .word 0x0000ff
.text 
	j main
#################################################
load_red_proc:
	la $a2, RED
	lw $a2, 0($a2)

	jr $ra
#################################################
load_green_proc:
	la $a2, GREEN
	lw $a2, 0($a2)

	jr $ra
#################################################
load_blue_proc:
	la $a2, BLUE
	lw $a2, 0($a2)

	jr $ra
#################################################
set_pixel_color_proc:
	add $sp, $sp, -4
	sw $t0, 0($sp)

	mulu $t0, $a1, $s0
	add $t0, $t0, $a0
	mulu $t0, $t0, 4
	add $t0, $t0, $s2

	sw $a2, 0($t0)

	lw $t0, 0($sp)
	add $sp, $sp, 4

	jr $ra
#################################################
# v0 - radius
draw_circle_proc:
	add $sp, $sp, -4
	sw $ra, 0($sp)

	add $t0, $zero, $v0 # get the radius

	mulu $t2, $t0, $t0 # t2 - radius^2

	add $t1, $zero, $v0 # t1 - y loop
	add $t1, $t1, -1

draw_circle_proc_loopY:	
	add $t0, $zero, $v0 # t0 - x loop
	add $t0, $t0, -1

draw_circle_proc_loopX:
	mulu $t3, $t0, $t0
	mulu $t4, $t1, $t1

	add $t3, $t3, $t4
	
	jal load_blue_proc
	
	bge $t3, $t2, draw_circle_proc_skip_red
	
	jal load_red_proc
	
draw_circle_proc_skip_red:
	add $a0, $t0, $zero # pass x
	add $a1, $t1, $zero # pass y

	jal set_pixel_color_proc

	add $t0, $t0, -1 # decrease x

	bne $t0, -1, draw_circle_proc_loopX

	add $t1, $t1, -1 # decrease y

	bne $t1, -1, draw_circle_proc_loopY

	lw $ra, 0($sp)
	add $sp, $sp, 4

	jr $ra
#################################################
main:
	la $t0, DISPLAYSIZE
	lw $s0, 0($t0) # s0 holds border x

	la $t0, DISPLAYSIZE
	lw $s1, 0($t0) # s1 holds border y

	la $s2, DISPLAYSPACE

	la $t0, RADIUS
	lw $s3, 0($t0)
	
	add $v0, $s3, $zero
	jal draw_circle_proc