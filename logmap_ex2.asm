.data

inity: .float 0.1
iters: .word 30

DISPLAYSPACE: .space 16384
DISPLAYWIDTH: .word 256
DISPLAYHEIGHT: .word 256

BLUE: .word 0x0000ff

.text
	j main
########################################################
set_pixel_color_proc:
	mulu $t0, $a1, $s0
	add $t0, $t0, $a0
	mulu $t0, $t0, 4
	add $t0, $t0, $s2

	sw $a2, 0($t0)

	jr $ra
########################################################
load_blue_proc:
	la $a2, BLUE
	lw $a2, 0($a2)
	
	jr $ra
########################################################
logmap_proc:
	add $sp, $sp, -4
	sw $ra, 0($sp)

	li $a0, 1
	jal convert_int_sfloat
	mov.s $f16, $f0

	sub.s $f0, $f16, $f12
	
	mul.s $f16, $f12, $f14
	mul.s $f0, $f0, $f16
	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	
	jr $ra
########################################################
itermap_proc:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
itermap_loop:
	add $sp, $sp, -4
	sw $a0, 0($sp)

	lw $a0, 0($sp)
	add $sp, $sp, 4
	
	jal logmap_proc
	mov.s $f14, $f0
	
	mov.s $f0, $f12
	jal convert_sfloat_int
	move $v0, $a0
	
	mov.s $f0, $f14
	jal convert_sfloat_int
	move $v0, $a1
	
	jal load_blue_proc
	jal set_pixel_color_proc
	
	add $a0, $a0, -1
	bne $a0, $zero, itermap_loop
	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	
	jr $ra
########################################################
read_int_proc:
	addi $v0, $zero, 5
	syscall

	jr $ra
########################################################
convert_int_sfloat:
	mtc1 $a0, $f0
	cvt.s.w $f0, $f0
	
	jr $ra
########################################################
convert_sfloat_int:
	cvt.w.s $f0, $f0
	mfc1 $v0, $f0
	
	jr $ra
########################################################
main:
	la $t0, DISPLAYWIDTH
	lw $s0, 0($t0)
	
	la $t0, DISPLAYHEIGHT
	lw $s1, 0($t0)
	
	la $s2, DISPLAYSPACE
	
	la $t0, iters
	lw $a0, 0($t0)

	jal read_int_proc
	move $v0, $a0
	jal convert_int_sfloat
	mov.s $f12, $f0
	
	la $t0, inity
      	lwc1 $f12, 0($t0)
	
	la $t0, iters
	lw $a0, 0($t0)
	
	jal itermap_proc