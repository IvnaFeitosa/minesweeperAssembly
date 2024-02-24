.include "macros.asm"

.globl play

play:
	save_context # criando pilha
	
	move $s1, $a2 # recebendo a informa??o do board
	
	move $s2, $a0 #linha
	move $s3, $a1 #coluna

# if:
sll $t2, $s2, 5
sll $t3, $s3, 2
add $t4, $t2, $t3
add $t3, $t4, $s1
lw  $t4, 0($t3)

li $t7, -1
li $t8, -2
beq $t4, $t7, return0
beq $t4, $t8, do

li $v0, 1
restore_context						# return 1
jr $ra

return0:
restore_context
li $v0, 0						# return 0
jr $ra

do:
move $a0, $s2
move $a1, $s3
move $a2, $s1
jal countAdjacentBombs
move $s5, $v0

sll $t2, $s2, 5
sll $t3, $s3, 2
add $t4, $t2, $t3
add $t3, $t4, $s1
sw  $v0, 0($t3)

# add $t4, $v0, $zero					# board[row][column] = x
beq $v0, $zero, call 
					# if (x != 0)
restore_context
li $v0, 1						# return 1
jr $ra

call:
move $a0, $s2
move $a1, $s3
move $a2, $s1
jal revealNeighboringCells
restore_context
li $v0, 1						# return 1
jr $ra
