.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
save_context # criando pilha
	
	
	move $s1, $a2 # recebendo a informa??o do board
	
	move $s2, $a0 #linha
	move $s3, $a1 #coluna
	
	sub $t0, $s2, 1
	move $s5, $t0 # i= row-1
	
	
	
	for_i:
		addi $t0, $s2, 1  # i= row+1
		bgt $s5, $t0, end_for_i   # verifica se s5>t0, se verdadeiro vai para parte de interesse 
		
		sub $t0, $s3, 1
		move $s6, $t0 # j = column -1
		
		for_j:
			addi $t0, $s3, 1  # j = column +1
			bgt $s6, $t0, end_for_j  
			
			blt $s5, $zero, changing_count  # verifica se s5<0
			bge $s5, SIZE, changing_count   # verifica se s5>=SIZE
			blt $s6, $zero, changing_count 
			bge $s6, SIZE, changing_count

			li $t1, -2
			li $t2, SIZE
			mul $t0, $t2, $s5
			add $t0, $t0, $s6
			li $t2, 4
			mul $t0, $t2, $t0
			add $t0, $t0, $s1
			
			lw $t0, 0($t0) # board
			
			bne $t0, $t1, changing_count #se t0!=t1
			
			  # Marca como revelado
			move $a0, $s5
			move $a1, $s6
			move $a2, $s1
    			jal countAdjacentBombs  # Chamada de fun??o para contar as bombas adjacentes
    			move $t1, $v0           # coloca o valor retornado pela fun??o em $t1 (x)
    			
    			li $t2, SIZE
			mul $t0, $t2, $s5
			add $t0, $t0, $s6
			li $t2, 4
			mul $t0, $t2, $t0
			add $t0, $t0, $s1
			
    			sw $t1, 0($t0)          # Armazena x em board[i][j]

    			# Continua a revela??o recursivamente se n?o houver bombas adjacentes
    			beqz $t1, recursive_reveal

    			addi $s6, $s6, 1       # Incrementa j
    			j for_j

	recursive_reveal:
   		move $a0, $s5                # Salva i na pilha
    		move $a1, $s6                # Salva j na pilha
    		move $a2, $s1
    		jal revealNeighboringCells    # Chama revealNeighboringCells recursivamente
    		

	changing_count:
    		addi $s6, $s6, 1        # Incrementa j(column)
    		j for_j

	end_for_j:
		addi $s5, $s5, 1        # Incrementa i (row)
		j for_i

	end_for_i:
    		restore_context         # Restaurando o contexto
		jr $ra                  # Retorno
