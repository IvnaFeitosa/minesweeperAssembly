.include "macros.asm"

.globl checkVictory

checkVictory:
	save_context
	move $s6, $a0

li $s7, 0					# int count = 0
li $s1, 0					# int i = 0	

begin_for_i_it:	
li $t0, SIZE
bge $s1, $t0, end_for_i_it			# i < SIZE
li $s2, 0					# int j = 0

begin_for_j_it:
li $t0, SIZE
bge $s2, $t0, end_for_j_it			# j <= SIZE
sll $t0, $s1, 5
sll $t1, $s2, 2
add $t0, $s6, $t0
add $t0, $t1, $t0
lw $t1, 0 ($t0)
blt $t1, $zero, end_of_it			# board[i][j] >= 0
addi $s7, $s7, 1				# count++

end_of_it:
addi $s2, $s2, 1
j begin_for_j_it

end_for_j_it:
addi $s1, $s1, 1
j begin_for_i_it

end_for_i_it:
li $t2, SIZE
mul $t1, $t2, $t2
subi $t1, $t1, BOMB_COUNT
bge $s7, $t1, return_1				# count < SIZE * SIZE - BOMB_COUNT
li $v0, 0					# return 0
j end

return_1:
li $v0, 1					# return 1

end:
restore_context
jr $ra
