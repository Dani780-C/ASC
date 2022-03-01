.data 
	retea: .space 1600
	roles: .space 80
	queue: .space 80
	visited: .space 80
	sir: .space 20
	n: .word 20
	index: .asciiz " index "
	controller: .asciiz "controller"
	host: .asciiz "host"
	switch: .asciiz "switch"
	switch_malitios: .asciiz "switch malitios"
	newline: .asciiz "\n"
	spatiu: .byte ' '
	punct_virgula: .byte ';'
	doua_puncte: .byte ':'
	yes: .asciiz "\nYes"
	no: .asciiz "\nNo"
.text

main:
	li $v0, 5
	syscall
	
	move $t0, $v0     
	
	li $v0, 5
	syscall
	
	move $t1, $v0     

	li $t2, 0         
	
	et_citire_legaturi:
		
		bge $t2, $t1, et_citire_roles
	
		li $v0, 5
		syscall

		move $s0, $v0

		li $v0, 5
		syscall
			
		move $s1, $v0
		
		mul $t4, $s0, $t0
		add $t4, $t4, $s1
		mul $t4, $t4, 4

		li $t5, 1
	
		sw $t5, retea($t4)

		mul $t4, $s1, $t0
		add $t4, $t4, $s0
		mul $t4, $t4, 4
	
		sw $t5, retea($t4)

		addi $t2, 1
			
		j et_citire_legaturi

et_citire_roles:
	
	li $t1, 0
	li $t3, 0
	et_citire:
		bge $t1, $t0, et_numar_cerinta
		
		li $v0, 5
		syscall
		
		sw $v0, roles($t3)
		
		addi $t1, 1
		addi $t3, 4
		
		j et_citire

et_numar_cerinta:
	
	li $v0, 5
	syscall
	
	beq $v0, 1, et_rezolvare_cerinta1
	beq $v0, 2, et_rezolvare_cerinta2
	beq $v0, 3, et_rezolvare_cerinta3 

et_rezolvare_cerinta1:

	li $t1, 0
	li $t2, 0

	et_identificare_switch_malitios:

	bge $t1, $t0, et_exit
	lw $t4, roles($t2)
	beq $t4, 3, et_identificare_legaturi
	
	et_continuare:

	addi $t2, 4
	addi $t1, 1
	
	j et_identificare_switch_malitios

et_afisare_newline:

	la $a0, newline
	li $v0, 4
	syscall
        
	j et_continuare
	
et_identificare_legaturi:
	
	la $a0, switch_malitios
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	
	lb $a0, doua_puncte
	li $v0, 11
	syscall

	mul $t5, $t1, $t0
	li $t6, 0

	et_linie_switch_malitios:
	
	bge $t6, $t0, et_afisare_newline
	
	add $t7, $t5, $t6
	mul $t7, $t7, 4

	lw $t8, retea($t7)
	
	beq $t8, 1, et_afisare_legatura
	
	et_continuare_1:
		
		addi $t6, 1
		j et_linie_switch_malitios
	
et_afisare_legatura:
	
	mul $t9, $t6, 4
	
	lw $s0, roles($t9)
	
	beq $s0, 1, et_afisare_host
	beq $s0, 2, et_afisare_switch
	beq $s0, 3, et_afisare_switch_malitios
	beq $s0, 4, et_afisare_controller_logic
				
et_afisare_host:
	
	lb $a0, spatiu
	li $v0, 11
	syscall
	
	la $a0, host
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	lb $a0, punct_virgula
	li $v0, 11
	syscall
	
	j et_continuare_1

et_afisare_switch:
	
	lb $a0, spatiu
	li $v0, 11
	syscall
	
	la $a0, switch
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	lb $a0, punct_virgula
	li $v0, 11
	syscall
	
	j et_continuare_1

et_afisare_switch_malitios:
	
	lb $a0, spatiu
	li $v0, 11
	syscall
	
	la $a0, switch_malitios
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	lb $a0, punct_virgula
	li $v0, 11
	syscall
	
	j et_continuare_1	

et_afisare_controller_logic:
	
	lb $a0, spatiu
	li $v0, 11
	syscall
	
	la $a0, controller
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t6
	li $v0, 1
	syscall
	
	lb $a0, punct_virgula
	li $v0, 11
	syscall
	
	j et_continuare_1

et_rezolvare_cerinta2:
	
	li $t1, 0               	
	li $t2, 0			
	li $t3, 1			
	sw $t1, queue($t2)  
	sw $t3, visited($t2)
	et_bfs:
		bgt $t1, $t2, et_verificare_visited
		mul $t4, $t1, 4 
		lw $t5, queue($t4)      		 
   		mul $t6, $t5, 4
		lw $t7, roles($t6)
		beq $t7, 1, et_afisare_host_bfs
		
		et_continuare_bfs:
			li $t8, 0
			et_linie_nod_curent:
				bge $t8, $t0, et_incrementare_index_curent
				mul $t9, $t5, $t0
				add $t9, $t9, $t8
				mul $t9, $t9, 4
				lw $s0, retea($t9)
				beq $s0, 1, et_extend_queue
				et_continuare_linie_nod_curent:
				addi $t8, 1
				j et_linie_nod_curent
et_extend_queue:
	
	mul $s1, $t8, 4
	lw $s2, visited($s1)
	beq $s2, 1, et_continuare_linie_nod_curent
	sw $t3, visited($s1)
	addi $t2, 1
	mul $s2, $t2, 4
	sw $t8, queue($s2)
	j et_continuare_linie_nod_curent

et_incrementare_index_curent:

	addi $t1, 1
	j et_bfs

et_afisare_host_bfs:
	
	la $a0, host
	li $v0, 4
	syscall
	
	la $a0, index
	li $v0, 4
	syscall
	
	move $a0, $t5
	li $v0, 1
	syscall
	
	lb $a0, punct_virgula
	li $v0, 11
	syscall
	
	lb $a0, spatiu
	li $v0, 11
	syscall
	
	j et_continuare_bfs 	

et_verificare_visited:
	li $t1, 0
	et_parcurgere:
		bge $t1, $t0, et_afisare_yes
		mul $t2, $t1, 4
		lw $t3, visited($t2)
		beq $t3, 0, et_afisare_no
		addi $t1, 1
		j et_parcurgere
et_afisare_yes:
	
	la $a0, yes
	li $v0, 4
	syscall
		
	j et_exit

et_afisare_no:
	
	la $a0, no
	li $v0, 4
	syscall 
	
	j et_exit
		
et_rezolvare_cerinta3:

	li $v0, 5
	syscall
	
	move $s1, $v0
	
	li $v0, 5
	syscall
	
	move $s2, $v0
	
	li $v0, 8
	lw $a1, n
	la $a0, sir
	syscall	
			
	li $t1, 0               	
	li $t2, 0			
	li $t3, 1			
	sw $s1, queue($t2)
	mul $t4, $s1, 4  
	sw $t3, visited($t4)

	et_bfs_fara_switch_malitios:
		bgt $t1, $t2, et_decriptare
		mul $t4, $t1, 4 
		lw $t5, queue($t4)
		beq $t5, $s2, et_afisare_mesaj		 
			li $t8, 0
			et_linie_nod_curent_3:
				bge $t8, $t0, et_incrementare_index_curent_3
				mul $t9, $t5, $t0
				add $t9, $t9, $t8
				mul $t9, $t9, 4
				lw $s0, retea($t9)
				beq $s0, 1, et_extend_queue_3
				et_continuare_linie_nod_curent_3:
				addi $t8, 1
				j et_linie_nod_curent_3
et_extend_queue_3:
	
	mul $s3, $t8, 4
	lw $s4, visited($s3)
	beq $s4, 1, et_continuare_linie_nod_curent_3
	lw $s5, roles($s3)
	sw $t3, visited($s3)
	beq $s5, 3, et_continuare_linie_nod_curent_3
	addi $t2, 1
	mul $s4, $t2, 4
	sw $t8, queue($s4)
	j et_continuare_linie_nod_curent_3

et_incrementare_index_curent_3:

	addi $t1, 1
	j et_bfs_fara_switch_malitios

et_decriptare:
	
	li $t1, 0
	
	et_parcurgere_sir_de_caractere:
			
		lb $t2, sir($t1)
		beqz $t2, et_afisare_mesaj

		blt $t2, 'k', et_aduna_16
		
		addi $t2, -10
		sb $t2, sir($t1)	
		addi $t1, 1
		j et_parcurgere_sir_de_caractere

et_aduna_16:
	
	addi $t2, 16
	sb $t2, sir($t1)
	addi $t1, 1
	j et_parcurgere_sir_de_caractere
	
et_afisare_mesaj:
	la $a0, sir
	li $v0, 4
	syscall
	j et_exit
et_exit:
	li $v0, 10
	syscall
