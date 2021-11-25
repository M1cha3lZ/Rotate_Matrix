
.text
.globl initialize
initialize:
	addi $sp, $sp, -8
	sw $a1, 0($sp)
	sw $ra, -4($sp) #stores return jump
	li $a1, 0
	li $a2, 0
	li $v0 13
    syscall 
    bltz $v0, failed_initialize
    
	move $a0, $v0 #file addr
	lw $a1, 0($sp) #buffer
	li $a2, 1
	
	li $v0 14 #gets row number
	syscall
	lb $t0, 0($a1)
	andi $t0,$t0,0x0F
	sw $t0, 0($a1)
	jal row_col_check
	move $t6, $t0
	addi $a1, $a1, 4
	
col:
	li $v0 14 #gets col number
	syscall
	lb $t3, 0($a1)
	jal return_check_1
	lb $t0, 0($a1)
	andi $t0,$t0,0x0F
	sw $t0, 0($a1)
	jal row_col_check
	move $t7, $t0
	mul $t7, $t7, $t6
	addi $a1, $a1, 4

buffer_loop:
	beqz $t7, end
	li $v0 14 #gets elem
	syscall
	beqz $v0, end
	lb $t3, 0($a1)
	jal return_check_2
	lb $t0, 0($a1)
	jal num_check
	andi $t0,$t0,0x0F
	sw $t0, 0($a1)
	addi $a1, $a1, 4
	addi $t7, $t7, -1
	bnez $v0, buffer_loop
		
end:
	lw $a1, 0($sp)
	lw $ra, -4($sp) #restores return jump
    addi $sp, $sp, 8
	li $v0, 1
 	jr $ra
		
	return_check_1:
		li $t0, 13
		beq $t0, $t3, col
	new_line_check_1:
		li $t0,10
		beq $t0, $t3, col
		jr $ra
		
	return_check_2: 
		li $t0, 13
		beq $t0, $t3, buffer_loop
	new_line_check_2: 
		li $t0,10
		beq $t0, $t3, buffer_loop
		jr $ra
		
	row_col_check:
		li $t8, 1
		li $t9, 9
		blt $t0, $t8, failed_initialize
		bgt $t0, $t9, failed_initialize
		jr $ra
	num_check:
		li $t8, 48
		li $t9, 57
		blt $t0, $t8, failed_initialize
		bgt $t0, $t9, failed_initialize
		jr $ra

failed_initialize:
	lw $a1, 0($sp)
	li $t7, 83
	jal reset
	lw $ra, -4($sp) #restores return jump
	addi $sp, $sp, 8
	li $v0, -1
	jr $ra
reset:
	
	sw $0, 0($a1)
	addi $a1, $a1, 4
	addi $t7, $t7, -4
	bgtz $t7, reset
	jr $ra
	

.globl write_file
write_file:
	
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	
	li $v0, 13
    li $a1, 1
    li $a2, 0
    syscall 
    move $a0, $v0
    
    
    lw $a1, 0($sp)
    lw $t0, 0($a1)
    move $t8, $t0 #row number in $t8
	addi $t0, $t0, 48
	sb $t0, 0($a1)
    li $a2, 1
    li $v0, 15
    syscall
    li $t1, 10 #new row
    sb $t1, 0($a1)
    li $a2, 1
    li $v0, 15
    syscall
    addi $a1, $a1, 4
    lw $t0, 0($a1)
    move $t9, $t0 #col number in $t9
	addi $t0, $t0, 48
	sb $t0, 0($a1)
    li $a2, 1
    li $v0, 15
    syscall
    
    row_loop:
    	li $t1, 10 #new row
   	 	sb $t1, 0($a1)
    	li $a2, 1
    	li $v0, 15
    	syscall
    	beqz $t8 write_complete
    	addi $t8, $t8, -1
    	move $t5, $t9
    	
    	col_loop:
    	addi $a1, $a1, 4
    	lw $t0, 0($a1)
		addi $t0, $t0, 48
		sb $t0, 0($a1)
    	li $a2, 1
    	li $v0, 15
    	syscall
    	addi $t5, $t5, -1
    	bnez $t5, col_loop
    	j row_loop
    jr $ra
    	
write_complete:
	addi $sp, $sp, 4
    li $v0, 16
    syscall
	jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
	move $t9, $a0
    lw $t8, 0($a0) # row number in $t8
    addi $a0, $a0, 4
    lw $t7, 0($a0) # col number in $t9
    move $a0, $t9 # back to the beginning
    sw $t7, 0($a0) # Storing col in row Initially 9
    addi $a0, $a0, 4 # COl
    sw $t8, 0($a0) 
    addi $a0, $a0, 4 # buffer
    li $t2, -1 
    li $t3, 0
    li $a3, -1
    c_loop:
    	addi $t2, $t2, 1 #col
    	beq $t2, $t7, pop_stack # If the col 
    	move $t0, $t8 # copies to t0 as row
    	r_loop:
    		beqz $t0, c_loop
    		addi $t0, $t0, -1# (r-1)
    		mul $t1, $t7, $t0 # c(r-1)
    		add $t1, $t1, $t2
    		li $t5, 4
    		mul $t1, $t1, $t5 #4 * c(r-1)
    		add $a0, $a0, $t1
    		lw $t6, 0($a0)
    		addi $sp, $sp, -4
    		addi $a3, $a3, 1
    		
    		sw $t6, 0($sp)
    		sub $a0, $a0, $t1
    		j r_loop
	
  
pop_stack:
	li $t5, 4
	beqz $a3, write
	mul $a3, $t5, $a3
	move $t6, $a3
	add $sp, $sp, $a3
	stack_loop:
    	lw $t0, 0($sp)
    	sw $t0, 0($a0)
    	beqz $a3, write
    	addi $a0, $a0, 4
    	addi $sp, $sp, -4
    	addi $a3, $a3, -4
    	j stack_loop
	
write:
	reset_stack:
		
		addi $sp, $sp, 4
		addi $a3, $a3, 4
		bne $t6, $a3, reset_stack
		lw $a3, 0($sp)
		lw $t1, 0($a0)
		addi $sp, $sp, 4
		move $a0, $a1
 	move $a1, $t9
 	j write_file
	jr $ra
end_rotate:
	jr $ra
	
.globl rotate_clkws_180
rotate_clkws_180:
	addi $sp, $sp, -4
	sw $ra, 4($sp)
	move $t9, $a0
	lw $t0, 0($a0)
	addi $a0, $a0, 4
	lw $t1, 0($a0)
	mul $t3, $t0, $t1
	li $t7, 1
	addi $a0, $a0, 4
	loop_180:
  		lw $t2, 0($a0)
  		addi $sp, $sp, -4
  		sw $t2, 0($sp)
  		addi $t3, $t3, -1
  		addi $t7, $t7, 1
  		addi $a0, $a0, 4
  		bnez $t3, loop_180
  		move $a0, $t9
  		addi $a0, $a0, 8
  		
  	pop_180:
  		lw $t0, 0($sp)
  		sw $t0, 0($a0)
  		addi $sp, $sp, 4
  		addi $a0, $a0, 4
  		addi $t7, $t7, -1
 		bnez $t7, pop_180
 		
 	move $a0, $a1
 	move $a1, $t9
 	j write_file
 	
  jr $ra


