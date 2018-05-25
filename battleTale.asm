


##############################################################################################################
#
#                                   BATTLETALE - por LEONARDO G.COELHO
#
# Inspirado no jogo Undertale, de Toby Fox
#
##############################################################################################################
#
# Tamanho: 512 x 512 / 4 x 4 (0 A 65532)
#
# Necessario:	- MIPS Assembler and Runtime Simulator (MARS 4.5 + maior)
#		- Bitmap Display
#		- Keyboard and Display MMIO Simulator
#
# Posicao de memoria inicial do Bitmap Display: 0x10008000 ($gp)
#
# OBS.: (1) Tempo de loading varia de maquina para maquina;
#       (2) Deixar marcado "Permit extended (pseudo) instructions and formats" e "Delayed branching" em Settings;
#
# (C)2017 Leonardo G Coelho. Undertale eh uma obra de Toby Fox. Todos direitos reservados.
#
##############################################################################################################
#
#	==== COMANDOS ([!] CHECAR SE CAPSLOCK ESTA DESATIVADO [!]) ==== 
#	"1234" = mover / selecionar
#	"x" = confirmar
#	"z" = voltar / atacar
#
#	==== INSTRUCOES ====
# Ola! Eu sou Flowey. Flowey, a flor. Eu quero testar voce para ver se tem mesmo determinacao. Seu objetivo é simples, meu chapa:
# Derrote o annoying dog.
# Para isso, lute contra ele para acabar com sua vida, ou mostre piedade dele e apenas argumente com ele.
# Caso sua vida esteja acabando, utilize um item para recupera-la, mas lembre-se, voce so possui um item.
# Para se defender de annoying dog, voce deve passar pelos puzzles sem falhar, caso contrario ira tomar um pequeno dano.
# Boa sorte! ;)
#
##############################################################################################################
#
# Registradores:
#	==== SPRITES ====
#	$t0 = SPRITE DOG;
#	$t1 = SPRITE HEART;
#	$t2 = SPRITE MENU;
#	$t3 = SPRITE DISPLAY 2;
#	$t4 = SPRITE DISPLAY 1;
#	$t5 = SPRITE FUNDO;
#	$t6 = SPRITE BAR;
#	==== OUTROS ====
#	$t7 = ENDERECO DO TECLADO;
#	$t8 = VALOR DA TECLA;
#	$t9 = REGISTRADOR AUX 1;
#	==== STATUS ====
#	$s0 = VIDA CHAR (20);
#	$s1 = VIDA DOG (20);
#	$s2 = SPARE DOG (20);
#	==== COR ====
#	$s3 = COR DECLARACAO (SUBROTINA);
#	==== OUTROS ====
#	$s4 = NUMERO DE PIXELS;
#	$s5 = REGISTRADOR AUX 2; (Life damage)
#	$s6 = DELAY;
#	$s7 = ;
#	$k0 = ;
#	$k1 = ;
#
##############################################################################################################

.text
.globl main

#========== MAIN ==========
	main:
		jal def_fundo
		nop
		jal cor_preto
		nop
		jal fundo1
		nop
		jal cor_branco
		nop
		jal startMsg
		nop
		
	start:
		jal lerTeclado
		nop
		beq $t7, 105, instr
		nop
		bne $t7, 120, start
		nop
		
	main2:
		addi $s0, $0, 20
		addi $s1, $0, 20
		addi $s5, $0, 20
		addi $s2, $0, 7
		
		jal cor_preto
		nop
		jal fundo1
		nop
		jal def_fundo
		nop
		jal cor_verde
		nop
		jal fundo2
		nop
		jal def_fundo
		nop
		
		jal cor_branco
		nop
		jal def_dog
		nop
		jal dog
		nop
		
		jal cor_branco
		nop
		jal lifeNum
		nop
		jal def_lifeBar
		nop
		jal lifeBar
		nop
		jal cor_branco
		nop
		jal def_lifeBar
		nop
		jal lifeBar2
		nop
		jal def_lifeBar
		nop
		jal cor_branco
		nop
		jal lifeBar3
		nop
		#
		jal def_display1
		nop
		jal cor_branco
		nop
		jal display1
		nop
		jal menu
		nop
		
	update:	
		jal def_display2
		nop
		jal cor_branco
		nop
		jal msg2
		nop

		jal lifeNum
		nop
		jal menu
		nop
		beq $s0, $0, death
		nop
		beq $s2, $0, win
		nop
		beq $s1, $0, badWin
		
		jal lerTeclado
		nop
		beq $t7, 49, fight
		nop
		beq $t7, 50, mercy
		nop
		beq $t7, 51, item
		nop
		beq $t7, 105, instr
		nop
		jal dogMov
		nop
		j update
		nop
		
		j endGame
		nop

	death:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal fundo1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal gameOver
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4 
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		beq $t7, 120, end
		nop
			
		j death
		nop
	
	end:
		addi $v0, $0, 10
		syscall
	
	win:
		beq $s0, 20, win2
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		sw $s3, 16096($t0)
		sw $s3, 16100($t0)
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal winMsg
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $v0, $0, 10
		syscall
		
	win2:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay8
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		la $a0, achievement1
		addi $v0, $0, 4
		syscall
		
		addi $v0, $0, 10
		syscall
	
	badWin:
		addi $s1, $0, 0
	
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		sw $s3, 21184($t0)
		sw $s3, 21188($t0)
		sw $s3, 21696($t0)
		sw $s3, 21700($t0)
		sw $s3, 21224($t0)
		sw $s3, 21228($t0)
		sw $s3, 21736($t0)
		sw $s3, 21740($t0)
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		sw $s3, 19136($t0)
		sw $s3, 19140($t0)
		sw $s3, 19648($t0)
		sw $s3, 19652($t0)
		sw $s3, 19176($t0)
		sw $s3, 19180($t0)
		sw $s3, 19688($t0)
		sw $s3, 19692($t0)
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal areaDam
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal died
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay8
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		la $a0, achievement2
		addi $v0, $0, 4
		syscall
		
		j death
		nop
		
	

#========== FUNCOES ==========
	damageFunc:

	instr:
		la $a0, instrMgs
		li $v0, 4
		syscall
		
		j menu
		nop

	delay:	ori $s6, $0, 96
	
	loop:	sub $s6, $s6, 1
		bne $s6, $0, loop
		nop
		jr $ra
		nop
		
	delay2:	ori $s6, $0, 1500
	
	loop2:	sub $s6, $s6, 1
		bne $s6, $0, loop2
		nop
		jr $ra
		nop
		
	delay2_1: ori $s6, $0, 10000
	
	loop2_1: sub $s6, $s6, 1
		bne $s6, $0, loop2_1
		nop
		jr $ra
		nop
		
	delay3:	ori $s6, $0, 8000
	
	loop3:	sub $s6, $s6, 1
		bne $s6, $0, loop3
		nop
		jr $ra
		nop
		
	delay4:	ori $s6, $0, 7000
	
	loop9:	sub $s6, $s6, 1
		bne $s6, $0, loop9
		nop
		jr $ra
		nop
		
	delay5:	ori $s6, $0, 5000
	
	loop5:	sub $s6, $s6, 1
		bne $s6, $0, loop5
		nop
		jr $ra
		nop
		
	delay6:	ori $s6, $0, 3000
	
	loop6:	sub $s6, $s6, 1
		bne $s6, $0, loop6
		nop
		jr $ra
		nop
		
	delay7:	ori $s6, $0, 10000
	
	loop7:	sub $s6, $s6, 1
		bne $s6, $0, loop7
		nop
		jr $ra
		nop
		
	delay8:	ori $s6, $0, 1000000
	
	loop8:	sub $s6, $s6, 1
		bne $s6, $0, loop8
		nop
		jr $ra
		nop
		
	delay10: ori $s6, $0, 3000
	
	loop10:	sub $s6, $s6, 1
		bne $s6, $0, loop10
		nop
		jr $ra
		nop
		
	delay11:ori $s6, $0, 100000
	
	loop11:	sub $s6, $s6, 1
		bne $s6, $0, loop11
		nop
		jr $ra
		nop

	dogMov:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dog_mov2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop
		
	outSubrot:
		nop
		jr $ra
		nop

	lerTeclado:
		lui $t6, 0xFFFF
		ori $t6, $t6, 0x0004
		lb $t7, 0($t6)
		jr $ra
		nop
		
	outFunc:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j update
		nop
		
			
	endGame:
		addi $v0, $zero, 10		# Codigo 10 syscall: sair do programa
		syscall	
		nop
		
	outItem:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dogMov
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
			
		beq $t7, 120, update
		
		j outItem
		nop
		
	covertDam:
		addi $t9, $0, 1
		addi $k1, $s0, -20
		mult $k1, $t9
		mflo $k1
		
		jr $ra
		nop
		
	menu:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_menu
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_laranja
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal fButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal mButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal iButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop
		
	fight:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
	
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal fButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay8
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		beq $t7, 122, update
		nop
		beq $t7, 120, attackDog
		nop
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dogMov
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal fight
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop
		
	mercy:
		beq $s2, 0, win
		nop
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal mButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		beq $t7, 122, update
		nop
		beq $t7, 120, attack1
		nop
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dogMov
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal mercy
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop
		
	item:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal iButton
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dogMov
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		beq $t7, 120, itemOp
		nop
		beq $t7, 122, update
		nop
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal item
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop
		
	itemOp:	
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal delay6
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
	
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal dogMov
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
			
		beq $t7, 49, item1 # +5
		nop
		beq $t7, 50, item2 # +2
		nop
		beq $t7, 51, item3 # +10
		nop
		beq $t7, 52, item4 # -20
		nop
		beq $t7, 122, update
		nop

		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal itemOp
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		jr $ra
		nop

#==================== Item =======================
	item1:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s0, $s0, 5
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		
		addi $s0, $0, 20
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		add $s5, $s0, $0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outItem
		nop
		
		item1_1:
			add $s5, $s0, $0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lifeNum
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal def_lifeBar
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lifeBar
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			j outItem
			nop
		
	item2:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s0, $s0, 2
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		
		addi $s0, $0, 20
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		add $s5, $s0, $0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outItem
		nop
	item3:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s0, $s0, 5
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		
		addi $s0, $0, 10
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		add $s5, $s0, $0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lerTeclado
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outItem
		nop
		
	item4:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal lifeNum
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s0, $s0, 5
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		
		addi $s0, $0, -20
		slti $k0, $s0, 20
		
		beq $k0, 1, item1_1
		nop
		add $s5, $s0, $0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		
		j damage
		nop
		
		
#=============== Attack Dog ===================
	attackDog:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_vermelho
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s5, $0, 112
		addi $t3, $t3, -140
		
		loop4:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay2
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop4
			nop
			
			beq $s5, 50, badWin
			nop
			beq $s5, 51, badWin
			nop
			beq $s5, 52, badWin
			nop
			beq $s5, 53, badWin
			nop
			beq $s5, 54, badWin
			nop
			beq $s5, 55, badWin
			nop
			beq $s5, 56, badWin
			nop
			beq $s5, 57, badWin
			nop
			beq $s5, 58, badWin
			nop
			beq $s5, 59, badWin
			nop
			beq $s5, 60, badWin
			nop
			beq $s5, 61, badWin
			nop
			beq $s5, 62, badWin
			nop
			beq $s5, 63, badWin
			nop
			beq $s5, 64, badWin
			nop
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			j damage
			nop

#=============== Attack =======================
	attack1:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_preto
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal msg2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s7, $0, 2
		
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_branco
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_vermelho
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal heart
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $s5, $0, 41
		beq $s2, 7, loop_M1
		nop
		beq $s2, 6, loop_M2
		nop
		beq $s2, 5, loop_M3
		nop
		beq $s2, 4, loop_M4
		nop
		beq $s2, 3, loop_M5
		nop
		beq $s2, 2, loop_M6
		nop
		beq $s2, 1, loop_M7
		nop
			
		loop_M1:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay2_1
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M1
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M2:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay3
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M2
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M3:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay4
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M3
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M4:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay5
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M4
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M5:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay6
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M5
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M6:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay2
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M6
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
		loop_M7:
			beq $s5, $0, damage
			nop
			addi $t3, $t3, 4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_branco
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay7
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal cor_preto
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal areaDam
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $s5, $s5, -1
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			bne $t7, 122, loop_M7
			nop
			
			beq $s5, 18, damDog
			nop
			beq $s5, 19, damDog
			nop
			beq $s5, 20, damDog
			nop
			beq $s5, 21, damDog
			nop
			beq $s5, 22, damDog
			nop
			beq $s5, 23, damDog
			nop
			beq $s5, 24, damDog
			nop
			
			j damage
			nop
			
			damage:
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal dogMov
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal def_lifeBar
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_preto
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal lifeNum
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
			
				addi $s0, $s0, -1
				beq $s0, $0, death
				nop
				
				addi $k1, $k1, 1
			
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal damageBar
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal def_display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_preto
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal display2
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal def_display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_branco
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal lifeNum
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_preto
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal heart
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
			
				j update
				nop
			
			damDog:
				addi $s2, $s2, -1
				
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal dogMov
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal def_display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_preto
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal display2
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal def_display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_branco
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal display1
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal cor_preto
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
				addi $sp, $sp, -4 #tiramos o espaço de memoria
				sw $ra, ($sp)
				jal heart
				nop
				lw $ra, ($sp)
				addi $sp, $sp ,4
			
				j update
				nop
			
		
		attack1_1:
			beq $k1, 150, outSubrot
			nop
		
			addi $t7, $0, 0
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal lerTeclado
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			beq $t7, 120, func1
			nop
			beq $t7, 122, func2
			nop
			
			addi $t7, $0, 0
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal dogMov
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $t7, $0, 0
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal delay2
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			addi $k1, $k1, 1
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal attack1_1
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4 
			
			jr $ra
			nop
			
		func1:
			addi $s7, $0, -1
			beq $s7, 0, no1
			nop
			
			addi $t1, $t1, -56
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal heart
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			jr $ra
			nop
			
			no1:
				addi $s7, $0, 1
				jr $ra
				nop
			
		func2:
			addi $s7, $0, 1
			beq $s7, 4, no2
			nop
			
			addi $t1, $t1, 56
			addi $sp, $sp, -4 #tiramos o espaço de memoria
			sw $ra, ($sp)
			jal heart
			nop
			lw $ra, ($sp)
			addi $sp, $sp ,4
			
			jr $ra
			nop
			
			no2:
				addi $s7, $0, 3
				jr $ra
				nop
		
		area_1_1:
			beq $t9, 14, outSubrot
			nop
			addi $t1, $t1, 56
			jal areaDam
			nop	
			addi $t3, $t3, 4
			j area_1_1
			nop
		
		areaDam:
			sw $s3, 34988($t3)
			sw $s3, 35500($t3)
			sw $s3, 36012($t3)
			sw $s3, 36524($t3)
			sw $s3, 37036($t3)
			sw $s3, 37548($t3)
			sw $s3, 38060($t3)
			sw $s3, 38572($t3)
			sw $s3, 39084($t3)
			sw $s3, 39596($t3)
			sw $s3, 40108($t3)
			sw $s3, 40620($t3)
			sw $s3, 41132($t3)
			sw $s3, 41644($t3)
			sw $s3, 42156($t3)
			sw $s3, 42668($t3)
			sw $s3, 43180($t3)
			sw $s3, 43692($t3)
			sw $s3, 44204($t3)
			sw $s3, 44716($t3)
			sw $s3, 45228($t3)
			sw $s3, 45740($t3)
			sw $s3, 46252($t3)
			sw $s3, 46764($t3)
			sw $s3, 47276($t3)
			sw $s3, 47788($t3)
			sw $s3, 48300($t3)
			sw $s3, 48812($t3)
			sw $s3, 49324($t3)
			sw $s3, 49836($t3)
			sw $s3, 50348($t3)
			sw $s3, 50860($t3)
			sw $s3, 51372($t3)
			sw $s3, 51884($t3)
			sw $s3, 52396($t3)
			
			jr $ra
			nop

#============= Damage Number Screen ===============		
	lifeNum:
		beq $s0, 0, lifeNum_0
		nop
		beq $s0, 1, lifeNum_1
		nop
		beq $s0, 2, lifeNum_2
		nop
		beq $s0, 3, lifeNum_3
		nop
		beq $s0, 4, lifeNum_4
		nop
		beq $s0, 5, lifeNum_5
		nop
		beq $s0, 6, lifeNum_6
		nop
		beq $s0, 7, lifeNum_7
		nop
		beq $s0, 8, lifeNum_8
		nop
		beq $s0, 9, lifeNum_9
		nop
		beq $s0, 10, lifeNum_10
		nop
		beq $s0, 11, lifeNum_11
		nop
		beq $s0, 12, lifeNum_12
		nop
		beq $s0, 13, lifeNum_13
		nop
		beq $s0, 14, lifeNum_14
		nop
		beq $s0, 15, lifeNum_15
		nop
		beq $s0, 16, lifeNum_16
		nop
		beq $s0, 17, lifeNum_17
		nop
		beq $s0, 18, lifeNum_18
		nop
		beq $s0, 19, lifeNum_19
		nop
		beq $s0, 20, lifeNum_20
		nop
		move $s0, $0
		nop
		
		j lifeNum
		nop
		
	lifeNum_0:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4

		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
		
	lifeNum_1:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
		
	lifeNum_2:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
		
	lifeNum_3:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
		
	lifeNum_4:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_4
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
		
	lifeNum_5:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_5
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_6:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_6
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_7:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20

		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_7
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_8:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20

		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_8
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_9:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20

		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_9
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_10:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_11:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_12:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_13:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_14:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_4
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_15:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_5
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_16:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_6
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_17:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_7
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_18:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_8
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_19:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_9
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop
	
	lifeNum_20:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t6, $t6, 20
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal num_0
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j outSubrot
		nop

#========== DECLARACAO ==========

	#STATUS
	status:
		addi $s0, $zero, 20		# VIDA DO CHAR
		addi $s1, $zero, 25		# VIDA DO DOG
		addi $s2, $zero, 6		# SPARE (TOLERANCIA) DO DOG
		jr $ra
		nop

	#CORES (SUBROTINA | $s3)
	cor_preto:
		addi $s3, $zero, 0x0A0A0A	# PRETO
		jr $ra
		nop
	cor_branco:
		addi $s3, $zero, 0xFFFFFF	# BRANCO
		jr $ra
		nop
	cor_vermelho:
		addi $s3, $zero, 0xFF0000	# VERMELHO
		jr $ra
		nop
	cor_amarelo:
		addi $s3, $zero, 0xFFFF00	# AMARELO
		jr $ra
		nop
	cor_verde:
		addi $s3, $zero, 0x007700	# VERDE
		jr $ra
		nop
	cor_laranja:
		addi $s3, $zero, 0xFF8C00	# LARANJA
		
	#DEFINICAO DOS PIXELS
	def_fundo:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t5, $zero, $s4 		# MAPEAMENTO
		move $t5, $gp			# INICIO
		jr $ra
		nop
	def_heart:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t1, $zero, $s4 		# MAPEAMENTO
		move $t1, $gp			# INICIO
		jr $ra
		nop
	def_dog:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t0, $zero, $s4 		# MAPEAMENTO
		move $t0, $gp			# INICIO
		jr $ra
		nop
	def_display2:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t3, $zero, $s4 		# MAPEAMENTO
		move $t3, $gp			# INICIO
		jr $ra
		nop
	def_display1:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t4, $zero, $s4 		# MAPEAMENTO
		move $t4, $gp			# INICIO
		jr $ra
		nop
	def_menu:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t2, $zero, $s4 		# MAPEAMENTO
		move $t2, $gp		# INICIO
		jr $ra
		nop
		
	def_lifeBar:
		addi $s4, $zero, 16384		# NUMERO DE PIXELS  (512*512) / (4*4)
		add $t6, $zero, $s4 		# MAPEAMENTO
		move $t6, $gp			# INICIO
		jr $ra
		nop

#===================== Display =====================		
	display1:
		#Cima
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Baixo
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1_3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Esquerda
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1_2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Direita
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display1_4
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Fim
		addi $t9, $zero, 0
		jr $ra
		nop
	
	display1_1: # Cima
		beq $t9, 235, outSubrot
		nop
		beq $t9, 117, display1_1_1
		nop
		sw $s3, 33812($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 4
		j display1_1
		nop
		
		display1_1_1:
			addi $t4, $t4, 44
			addi $t9, $t9, 1
			j display1_1
			nop
		
	display1_2: # Esquerda
		beq $t9, 72, outSubrot
		nop
		beq $t9, 35, display1_2_1
		nop
		sw $s3, 34836($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 512
		j display1_2
		nop
		
		display1_2_1:
			addi $t4, $t4, -17916
			addi $t9, $t9, 1
			j display1_2
			nop
		
	display1_3: # Baixo
		beq $t9, 235, outSubrot
		nop
		beq $t9, 117, display1_3_1
		nop
		sw $s3, 52756($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 4
		j display1_3
		nop
		
		display1_3_1:
			addi $t4, $t4, 44
			addi $t9, $t9, 1
			j display1_3
			nop
	
	display1_4: # Direita
		beq $t9, 79, outSubrot
		nop
		beq $t9, 39, display1_4_1
		nop
		sw $s3, 34276($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 512
		j display1_4
		nop
		
		display1_4_1:
			addi $t4, $t4, -19964
			addi $t9, $t9, 1
			j display1_4
			nop
			
			
	display2:
		#Cima
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2_1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Baixo
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2_3
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Esquerda
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2_2
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Direita
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_display1
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $zero, 0
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal display2_4
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		#Fim
		addi $t9, $zero, 0
		jr $ra
		nop
	
	display2_1: # Cima
		beq $t9, 92, outSubrot
		nop
		beq $t9, 46, display2_1_1
		nop
		sw $s3, 33956($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 4
		j display2_1
		nop
		
		display2_1_1:
			addi $t4, $t4, 332
			addi $t9, $t9, 1
			j display2_1
			nop
		
	display2_2: # Esquerda
		beq $t9, 75, outSubrot
		nop
		beq $t9, 38, display2_2_1
		nop
		sw $s3, 34468($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 512
		j display2_2
		nop
		
		display2_2_1:
			addi $t4, $t4, -18940
			addi $t9, $t9, 1
			j display2_2
			nop
		
	display2_3: # Baixo
		beq $t9, 92, outSubrot
		nop
		beq $t9, 46, display2_3_1
		nop
		sw $s3, 52900($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 4
		j display2_3
		nop
		
		display2_3_1:
			addi $t4, $t4, 332
			addi $t9, $t9, 1
			j display2_3
			nop
	
	display2_4: # Direita
		beq $t9, 79, outSubrot
		nop
		beq $t9, 39, display2_4_1
		nop
		sw $s3, 34132($t4)
		
		addi $t9, $t9, 1
		addi $t4, $t4, 512
		j display2_4
		nop
		
		display2_4_1:
			addi $t4, $t4, -19964
			addi $t9, $t9, 1
			j display2_4
			nop

#========== ACTION BUTTONS ==========	
	fButton:			# FIGHT	
		sw $s3, 59960($t2)
		sw $s3, 59964($t2)
		sw $s3, 59968($t2)
		sw $s3, 59972($t2)
		sw $s3, 59976($t2)
		sw $s3, 59980($t2)
		sw $s3, 59984($t2)
		sw $s3, 59988($t2)
		sw $s3, 59992($t2)
		sw $s3, 59996($t2)
		sw $s3, 60000($t2)
		sw $s3, 60004($t2)
		sw $s3, 60008($t2)
		sw $s3, 60012($t2)
		sw $s3, 60016($t2)
		sw $s3, 60020($t2)
		sw $s3, 60024($t2)
		sw $s3, 60028($t2)
		sw $s3, 60032($t2)
		sw $s3, 60036($t2)
		sw $s3, 60040($t2)
		sw $s3, 60044($t2)
		sw $s3, 60048($t2)
		sw $s3, 60052($t2)
		sw $s3, 60056($t2)
		sw $s3, 60060($t2)
		sw $s3, 60064($t2)
		sw $s3, 60068($t2)
		sw $s3, 60072($t2)
		sw $s3, 60076($t2)
		#
		sw $s3, 60472($t2)
		sw $s3, 60588($t2)
		#
		sw $s3, 60984($t2)
		sw $s3, 61008($t2)
		sw $s3, 61020($t2)
		sw $s3, 61024($t2)
		sw $s3, 61028($t2)
		sw $s3, 61036($t2)
		sw $s3, 61040($t2)
		sw $s3, 61044($t2)
		sw $s3, 61052($t2)
		sw $s3, 61056($t2)
		sw $s3, 61060($t2)
		sw $s3, 61068($t2)
		sw $s3, 61076($t2)
		sw $s3, 61084($t2)
		sw $s3, 61088($t2)
		sw $s3, 61092($t2)
		sw $s3, 61100($t2)
		#
		sw $s3, 61496($t2)
		sw $s3, 61516($t2)
		sw $s3, 61532($t2)
		sw $s3, 61552($t2)
		sw $s3, 61564($t2)
		sw $s3, 61580($t2)
		sw $s3, 61588($t2)
		sw $s3, 61600($t2)
		sw $s3, 61612($t2)
		#
		sw $s3, 62008($t2)
		sw $s3, 62016($t2)
		sw $s3, 62024($t2)
		sw $s3, 62044($t2)
		sw $s3, 62048($t2)
		sw $s3, 62052($t2)
		sw $s3, 62064($t2)
		sw $s3, 62076($t2)
		sw $s3, 62084($t2)
		sw $s3, 62092($t2)
		sw $s3, 62096($t2)
		sw $s3, 62100($t2)
		sw $s3, 62112($t2)
		sw $s3, 62124($t2)
		#
		sw $s3, 62520($t2)
		sw $s3, 62532($t2)
		sw $s3, 62556($t2)
		sw $s3, 62576($t2)
		sw $s3, 62588($t2)
		sw $s3, 62596($t2)
		sw $s3, 62604($t2)
		sw $s3, 62612($t2)
		sw $s3, 62624($t2)
		sw $s3, 62636($t2)
		#
		sw $s3, 63032($t2)
		sw $s3, 63040($t2)
		sw $s3, 63048($t2)
		sw $s3, 63068($t2)
		sw $s3, 63084($t2)
		sw $s3, 63088($t2)
		sw $s3, 63092($t2)
		sw $s3, 63100($t2)
		sw $s3, 63104($t2)
		sw $s3, 63108($t2)
		sw $s3, 63116($t2)
		sw $s3, 63124($t2)
		sw $s3, 63136($t2)
		sw $s3, 63148($t2)
		#
		sw $s3, 63544($t2)
		sw $s3, 63660($t2)
		#
		sw $s3, 64056($t2)
		sw $s3, 64060($t2)
		sw $s3, 64064($t2)
		sw $s3, 64068($t2)
		sw $s3, 64072($t2)
		sw $s3, 64076($t2)
		sw $s3, 64080($t2)
		sw $s3, 64084($t2)
		sw $s3, 64088($t2)
		sw $s3, 64092($t2)
		sw $s3, 64096($t2)
		sw $s3, 64100($t2)
		sw $s3, 64104($t2)
		sw $s3, 64108($t2)
		sw $s3, 64112($t2)
		sw $s3, 64116($t2)
		sw $s3, 64120($t2)
		sw $s3, 64124($t2)
		sw $s3, 64128($t2)
		sw $s3, 64132($t2)
		sw $s3, 64136($t2)
		sw $s3, 64140($t2)
		sw $s3, 64144($t2)
		sw $s3, 64148($t2)
		sw $s3, 64152($t2)
		sw $s3, 64156($t2)
		sw $s3, 64160($t2)
		sw $s3, 64164($t2)
		sw $s3, 64168($t2)
		sw $s3, 64172($t2)
		#
		jr $ra
		nop
		
	mButton:			# Mercy
		sw $s3, 60100($t2)
		sw $s3, 60104($t2)
		sw $s3, 60108($t2)
		sw $s3, 60112($t2)
		sw $s3, 60116($t2)
		sw $s3, 60120($t2)
		sw $s3, 60124($t2)
		sw $s3, 60128($t2)
		sw $s3, 60132($t2)
		sw $s3, 60136($t2)
		sw $s3, 60140($t2)
		sw $s3, 60144($t2)
		sw $s3, 60148($t2)
		sw $s3, 60152($t2)
		sw $s3, 60156($t2)
		sw $s3, 60160($t2)
		sw $s3, 60164($t2)
		sw $s3, 60168($t2)
		sw $s3, 60172($t2)
		sw $s3, 60176($t2)
		sw $s3, 60180($t2)
		sw $s3, 60184($t2)
		sw $s3, 60188($t2)
		sw $s3, 60192($t2)
		sw $s3, 60196($t2)
		sw $s3, 60200($t2)
		sw $s3, 60204($t2)
		sw $s3, 60208($t2)
		sw $s3, 60212($t2)
		sw $s3, 60216($t2)
		#
		sw $s3, 60612($t2)
		sw $s3, 60728($t2)
		#
		sw $s3, 61124($t2)
		sw $s3, 61132($t2)
		sw $s3, 61148($t2)
		sw $s3, 61160($t2)
		sw $s3, 61168($t2)
		sw $s3, 61176($t2)
		sw $s3, 61180($t2)
		sw $s3, 61184($t2)
		sw $s3, 61192($t2)
		sw $s3, 61196($t2)
		sw $s3, 61208($t2)
		sw $s3, 61212($t2)
		sw $s3, 61216($t2)
		sw $s3, 61224($t2)
		sw $s3, 61232($t2)
		sw $s3, 61240($t2)
		#
		sw $s3, 61636($t2)
		sw $s3, 61648($t2)
		sw $s3, 61656($t2)
		sw $s3, 61672($t2)
		sw $s3, 61676($t2)
		sw $s3, 61680($t2)
		sw $s3, 61688($t2)
		sw $s3, 61704($t2)
		sw $s3, 61712($t2)
		sw $s3, 61720($t2)
		sw $s3, 61736($t2)
		sw $s3, 61744($t2)
		sw $s3, 61752($t2)
		#
		sw $s3, 62148($t2)
		sw $s3, 62164($t2)
		sw $s3, 62184($t2)
		sw $s3, 62188($t2)
		sw $s3, 62192($t2)
		sw $s3, 62200($t2)
		sw $s3, 62204($t2)
		sw $s3, 62208($t2)
		sw $s3, 62216($t2)
		sw $s3, 62220($t2)
		sw $s3, 62232($t2)
		sw $s3, 62252($t2)
		sw $s3, 62264($t2)
		#
		sw $s3, 62660($t2)
		sw $s3, 62672($t2)
		sw $s3, 62680($t2)
		sw $s3, 62696($t2)
		sw $s3, 62704($t2)
		sw $s3, 62712($t2)
		sw $s3, 62728($t2)
		sw $s3, 62732($t2)
		sw $s3, 62736($t2)
		sw $s3, 62744($t2)
		sw $s3, 62764($t2)
		sw $s3, 62776($t2)
		#
		sw $s3, 63172($t2)
		sw $s3, 63180($t2)
		sw $s3, 63196($t2)
		sw $s3, 63208($t2)
		sw $s3, 63216($t2)
		sw $s3, 63224($t2)
		sw $s3, 63228($t2)
		sw $s3, 63232($t2)
		sw $s3, 63240($t2)
		sw $s3, 63248($t2)
		sw $s3, 63256($t2)
		sw $s3, 63260($t2)
		sw $s3, 63264($t2)
		sw $s3, 63276($t2)
		sw $s3, 63288($t2)
		#
		sw $s3, 63684($t2)
		sw $s3, 63800($t2)
		#
		sw $s3, 64196($t2)
		sw $s3, 64200($t2)
		sw $s3, 64204($t2)
		sw $s3, 64208($t2)
		sw $s3, 64212($t2)
		sw $s3, 64216($t2)
		sw $s3, 64220($t2)
		sw $s3, 64224($t2)
		sw $s3, 64228($t2)
		sw $s3, 64232($t2)
		sw $s3, 64236($t2)
		sw $s3, 64240($t2)
		sw $s3, 64244($t2)
		sw $s3, 64248($t2)
		sw $s3, 64252($t2)
		sw $s3, 64256($t2)
		sw $s3, 64260($t2)
		sw $s3, 64264($t2)
		sw $s3, 64268($t2)
		sw $s3, 64272($t2)
		sw $s3, 64276($t2)
		sw $s3, 64280($t2)
		sw $s3, 64284($t2)
		sw $s3, 64288($t2)
		sw $s3, 64292($t2)
		sw $s3, 64296($t2)
		sw $s3, 64300($t2)
		sw $s3, 64304($t2)
		sw $s3, 64308($t2)
		sw $s3, 64312($t2)
		#
		jr $ra
		nop
	
	iButton:			# Item
		sw $s3, 60240($t2)
		sw $s3, 60244($t2)
		sw $s3, 60248($t2)
		sw $s3, 60252($t2)
		sw $s3, 60256($t2)
		sw $s3, 60260($t2)
		sw $s3, 60264($t2)
		sw $s3, 60268($t2)
		sw $s3, 60272($t2)
		sw $s3, 60276($t2)
		sw $s3, 60280($t2)
		sw $s3, 60284($t2)
		sw $s3, 60288($t2)
		sw $s3, 60292($t2)
		sw $s3, 60296($t2)
		sw $s3, 60300($t2)
		sw $s3, 60304($t2)
		sw $s3, 60308($t2)
		sw $s3, 60312($t2)
		sw $s3, 60316($t2)
		sw $s3, 60320($t2)
		sw $s3, 60324($t2)
		sw $s3, 60328($t2)
		sw $s3, 60332($t2)
		sw $s3, 60336($t2)
		sw $s3, 60340($t2)
		sw $s3, 60344($t2)
		sw $s3, 60348($t2)
		sw $s3, 60352($t2)
		sw $s3, 60356($t2)
		#
		sw $s3, 60752($t2)
		sw $s3, 60868($t2)
		#
		sw $s3, 61264($t2)
		sw $s3, 61280($t2)
		sw $s3, 61316($t2)
		sw $s3, 61320($t2)
		sw $s3, 61324($t2)
		sw $s3, 61332($t2)
		sw $s3, 61336($t2)
		sw $s3, 61340($t2)
		sw $s3, 61348($t2)
		sw $s3, 61352($t2)
		sw $s3, 61356($t2)
		sw $s3, 61364($t2)
		sw $s3, 61372($t2)
		sw $s3, 61380($t2)
		#
		sw $s3, 61776($t2)
		sw $s3, 61792($t2)
		sw $s3, 61832($t2)
		sw $s3, 61848($t2)
		sw $s3, 61860($t2)
		sw $s3, 61876($t2)
		sw $s3, 61880($t2)
		sw $s3, 61884($t2)
		sw $s3, 61892($t2)
		#
		sw $s3, 62288($t2)
		sw $s3, 62296($t2)
		sw $s3, 62300($t2)
		sw $s3, 62304($t2)
		sw $s3, 62308($t2)
		sw $s3, 62312($t2)
		sw $s3, 62344($t2)
		sw $s3, 62360($t2)
		sw $s3, 62372($t2)
		sw $s3, 62376($t2)
		sw $s3, 62388($t2)
		sw $s3, 62392($t2)
		sw $s3, 62396($t2)
		sw $s3, 62404($t2)
		#
		sw $s3, 62800($t2)
		sw $s3, 62816($t2)
		sw $s3, 62856($t2)
		sw $s3, 62872($t2)
		sw $s3, 62884($t2)
		sw $s3, 62900($t2)
		sw $s3, 62908($t2)
		sw $s3, 62916($t2)
		#
		sw $s3, 63312($t2)
		sw $s3, 63328($t2)
		sw $s3, 63364($t2)
		sw $s3, 63368($t2)
		sw $s3, 63372($t2)
		sw $s3, 63384($t2)
		sw $s3, 63396($t2)
		sw $s3, 63400($t2)
		sw $s3, 63404($t2)
		sw $s3, 63412($t2)
		sw $s3, 63420($t2)
		sw $s3, 63428($t2)
		#
		sw $s3, 63824($t2)
		sw $s3, 63940($t2)
		#
		sw $s3, 64336($t2)
		sw $s3, 64340($t2)
		sw $s3, 64344($t2)
		sw $s3, 64348($t2)
		sw $s3, 64352($t2)
		sw $s3, 64356($t2)
		sw $s3, 64360($t2)
		sw $s3, 64364($t2)
		sw $s3, 64368($t2)
		sw $s3, 64372($t2)
		sw $s3, 64376($t2)
		sw $s3, 64380($t2)
		sw $s3, 64384($t2)
		sw $s3, 64388($t2)
		sw $s3, 64392($t2)
		sw $s3, 64396($t2)
		sw $s3, 64400($t2)
		sw $s3, 64404($t2)
		sw $s3, 64408($t2)
		sw $s3, 64412($t2)
		sw $s3, 64416($t2)
		sw $s3, 64420($t2)
		sw $s3, 64424($t2)
		sw $s3, 64428($t2)
		sw $s3, 64432($t2)
		sw $s3, 64436($t2)
		sw $s3, 64440($t2)
		sw $s3, 64444($t2)
		sw $s3, 64448($t2)
		sw $s3, 64452($t2)
		#
		jr $ra
		nop
								
#========== SPRITES ==========	

#================== Life Bar ==========================	
	damageBar:
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal def_lifeBar
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		addi $t9, $0, 0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_vermelho
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j damageBar1
		nop
		
	damageBar1:
		beq $t9, $k1, outSubrot
		nop
		
		sw $s3, 55016($t6)
		sw $s3, 55528($t6)
		sw $s3, 56040($t6)
		sw $s3, 56552($t6)
		addi $t6, $t6, -4
		addi $t9, $t9, 1
		j damageBar1
		nop
		
	lifeBar:
		addi $t9, $0, 0
		
		addi $sp, $sp, -4 #tiramos o espaço de memoria
		sw $ra, ($sp)
		jal cor_amarelo
		nop
		lw $ra, ($sp)
		addi $sp, $sp ,4
		
		j lifeBar1
		nop
		
	lifeBar1:
		beq $t9, $s5, outSubrot
		nop
		
		sw $s3, 54940($t6)
		sw $s3, 55452($t6)
		sw $s3, 55964($t6)
		sw $s3, 56476($t6)
		addi $t6, $t6, 4
		addi $t9, $t9, 1
		j lifeBar1
		nop
		
	lifeBar2:
	
		sw $s3, 54904($t6)
		sw $s3, 54912($t6)
		sw $s3, 54920($t6)
		sw $s3, 54924($t6)
		
		sw $s3, 55416($t6)
		sw $s3, 55424($t6)
		sw $s3, 55432($t6)
		sw $s3, 55440($t6)	
		
		sw $s3, 55928($t6)
		sw $s3, 55932($t6)
		sw $s3, 55936($t6)
		sw $s3, 55944($t6)
		sw $s3, 55948($t6)
		
		sw $s3, 56440($t6)
		sw $s3, 56448($t6)
		sw $s3, 56456($t6)
		# Numero
		sw $s3, 57124($t6)
		sw $s3, 56616($t6)
		sw $s3, 56108($t6)
		sw $s3, 55600($t6)
		sw $s3, 55092($t6)
		#
		sw $s3, 55108($t6)
		sw $s3, 55112($t6)
		sw $s3, 55116($t6)
		sw $s3, 55128($t6)
		sw $s3, 55132($t6)
		sw $s3, 55136($t6)
		sw $s3, 55140($t6)
		
		sw $s3, 55628($t6)
		sw $s3, 55632($t6)
		sw $s3, 55640($t6)
		sw $s3, 55644($t6)
		sw $s3, 55648($t6)
		sw $s3, 55652($t6)
		
		sw $s3, 56136($t6)
		sw $s3, 56140($t6)
		sw $s3, 56144($t6)
		sw $s3, 56152($t6)
		sw $s3, 56160($t6)
		sw $s3, 56164($t6)
		
		sw $s3, 56644($t6)
		sw $s3, 56648($t6)
		sw $s3, 56664($t6)
		sw $s3, 56672($t6)
		sw $s3, 56676($t6)
		
		sw $s3, 57156($t6)
		sw $s3, 57160($t6)
		sw $s3, 57164($t6)
		sw $s3, 57168($t6)
		sw $s3, 57176($t6)
		sw $s3, 57180($t6)
		sw $s3, 57184($t6)
		sw $s3, 57188($t6)
		
		jr $ra
		nop
		
	lifeBar3:
		sw $s3, 55108($t6)
		sw $s3, 55112($t6)
		sw $s3, 55116($t6)
		sw $s3, 55128($t6)
		sw $s3, 55132($t6)
		sw $s3, 55136($t6)
		sw $s3, 55140($t6)
		
		sw $s3, 55628($t6)
		sw $s3, 55632($t6)
		sw $s3, 55640($t6)
		sw $s3, 55644($t6)
		sw $s3, 55648($t6)
		sw $s3, 55652($t6)
		
		sw $s3, 56136($t6)
		sw $s3, 56140($t6)
		sw $s3, 56144($t6)
		sw $s3, 56152($t6)
		sw $s3, 56160($t6)
		sw $s3, 56164($t6)
		
		sw $s3, 56644($t6)
		sw $s3, 56648($t6)
		sw $s3, 56664($t6)
		sw $s3, 56672($t6)
		sw $s3, 56676($t6)
		
		sw $s3, 57156($t6)
		sw $s3, 57160($t6)
		sw $s3, 57164($t6)
		sw $s3, 57168($t6)
		sw $s3, 57176($t6)
		sw $s3, 57180($t6)
		sw $s3, 57184($t6)
		sw $s3, 57188($t6)
		
		jr $ra
		nop

#========== FUNDO ==========
	fundo1:
		beq $s4, $zero, def_fundo		# Se o contador == 0, volta para a funcao
		nop					# Senao
		sw $s3, 0($t5)			
		addi $t5, $t5, 4
		addi $s4, $s4, -1
		j fundo1
		nop
	fundo2:
		sw $s3, 3600($t5)##
		sw $s3, 3604($t5)
		sw $s3, 3608($t5)
		sw $s3, 3612($t5)
		sw $s3, 3616($t5)
		sw $s3, 3620($t5)
		sw $s3, 3624($t5)
		sw $s3, 3628($t5)
		sw $s3, 3632($t5)
		sw $s3, 3636($t5)
		sw $s3, 3640($t5)
		sw $s3, 3644($t5)
		sw $s3, 3648($t5)
		sw $s3, 3652($t5)
		sw $s3, 3656($t5)
		sw $s3, 3660($t5)
		sw $s3, 3664($t5)
		sw $s3, 3668($t5)
		sw $s3, 3672($t5)
		sw $s3, 3676($t5)
		sw $s3, 3680($t5)
		sw $s3, 3684($t5)
		sw $s3, 3688($t5)
		sw $s3, 3692($t5)
		sw $s3, 3696($t5)
		sw $s3, 3700($t5)
		sw $s3, 3704($t5)
		sw $s3, 3708($t5)
		sw $s3, 3712($t5)
		sw $s3, 3716($t5)
		sw $s3, 3720($t5)
		sw $s3, 3724($t5)
		sw $s3, 3728($t5)
		sw $s3, 3732($t5)
		sw $s3, 3736($t5)
		sw $s3, 3740($t5)
		sw $s3, 3744($t5)
		sw $s3, 3932($t5)#
		sw $s3, 3936($t5)
		sw $s3, 3940($t5)
		sw $s3, 3944($t5)
		sw $s3, 3948($t5)
		sw $s3, 3952($t5)
		sw $s3, 3956($t5)
		sw $s3, 3960($t5)
		sw $s3, 3964($t5)
		sw $s3, 3968($t5)
		sw $s3, 3972($t5)
		sw $s3, 3976($t5)
		sw $s3, 3980($t5)
		sw $s3, 3984($t5)
		sw $s3, 3988($t5)
		sw $s3, 3992($t5)
		sw $s3, 3996($t5)
		sw $s3, 4000($t5)
		sw $s3, 4004($t5)
		sw $s3, 4008($t5)
		sw $s3, 4012($t5)
		sw $s3, 4016($t5)
		sw $s3, 4020($t5)
		sw $s3, 4024($t5)
		sw $s3, 4028($t5)
		sw $s3, 4032($t5)
		sw $s3, 4036($t5)
		sw $s3, 4040($t5)
		sw $s3, 4044($t5)
		sw $s3, 4048($t5)
		sw $s3, 4052($t5)
		sw $s3, 4056($t5)
		sw $s3, 4060($t5)
		sw $s3, 4064($t5)
		sw $s3, 4068($t5)
		sw $s3, 4072($t5)
		sw $s3, 4076($t5)
		
		sw $s3, 4112($t5)##
		sw $s3, 4184($t5)
		sw $s3, 4220($t5)
		sw $s3, 4256($t5)
		sw $s3, 4444($t5)#
		sw $s3, 4480($t5)
		sw $s3, 4516($t5)
		sw $s3, 4588($t5)
		
		sw $s3, 4624($t5)##
		sw $s3, 4696($t5)
		sw $s3, 4732($t5)
		sw $s3, 4768($t5)
		sw $s3, 4956($t5)#
		sw $s3, 4992($t5)
		sw $s3, 5028($t5)
		sw $s3, 5100($t5)
		
		sw $s3, 4112($t5)##
		sw $s3, 4184($t5)
		sw $s3, 4220($t5)
		sw $s3, 4256($t5)
		sw $s3, 4444($t5)#
		sw $s3, 4480($t5)
		sw $s3, 4516($t5)
		sw $s3, 4588($t5)
		
		sw $s3, 5136($t5)##
		sw $s3, 5208($t5)
		sw $s3, 5244($t5)
		sw $s3, 5280($t5)
		
		sw $s3, 5648($t5)##
		sw $s3, 5720($t5)
		sw $s3, 5756($t5)
		sw $s3, 5792($t5)
		
		sw $s3, 6160($t5)##
		sw $s3, 6232($t5)
		sw $s3, 6268($t5)
		sw $s3, 6304($t5)
		
		sw $s3, 6672($t5)##
		sw $s3, 6744($t5)
		sw $s3, 6780($t5)
		sw $s3, 6816($t5)
		
		sw $s3, 7184($t5)##
		sw $s3, 7256($t5)
		sw $s3, 7292($t5)
		sw $s3, 7328($t5)
		
		sw $s3, 7696($t5)##
		sw $s3, 7768($t5)
		sw $s3, 7804($t5)
		sw $s3, 7840($t5)
		
		sw $s3, 8208($t5)##
		sw $s3, 8280($t5)
		sw $s3, 8316($t5)
		sw $s3, 8352($t5)
		
		sw $s3, 8720($t5)##
		sw $s3, 8792($t5)
		sw $s3, 8828($t5)
		sw $s3, 8864($t5)
		
		sw $s3, 9232($t5)##
		sw $s3, 9304($t5)
		sw $s3, 9340($t5)
		sw $s3, 9376($t5)
		
		sw $s3, 9744($t5)##
		sw $s3, 9816($t5)
		sw $s3, 9852($t5)
		sw $s3, 9888($t5)
		
		sw $s3, 10256($t5)##
		sw $s3, 10328($t5)
		sw $s3, 10332($t5)
		sw $s3, 10336($t5)
		sw $s3, 10340($t5)
		sw $s3, 10344($t5)
		sw $s3, 10348($t5)
		sw $s3, 10352($t5)
		sw $s3, 10356($t5)
		sw $s3, 10360($t5)
		sw $s3, 10364($t5)
		sw $s3, 10368($t5)
		sw $s3, 10372($t5)
		sw $s3, 10376($t5)
		sw $s3, 10380($t5)
		sw $s3, 10384($t5)
		sw $s3, 10388($t5)
		sw $s3, 10392($t5)
		sw $s3, 10396($t5)
		sw $s3, 10400($t5)
		
		sw $s3, 10768($t5)##
		sw $s3, 10840($t5)
		sw $s3, 10876($t5)
		sw $s3, 10912($t5)
		
		sw $s3, 11280($t5)##
		sw $s3, 11352($t5)
		sw $s3, 11388($t5)
		sw $s3, 11424($t5)
		
		sw $s3, 11792($t5)##
		sw $s3, 11864($t5)
		sw $s3, 11900($t5)
		sw $s3, 11936($t5)
		
		sw $s3, 12304($t5)##
		sw $s3, 12376($t5)
		sw $s3, 12412($t5)
		sw $s3, 12448($t5)
		
		sw $s3, 12816($t5)##
		sw $s3, 12888($t5)
		sw $s3, 12924($t5)
		sw $s3, 12960($t5)
		
		sw $s3, 13328($t5)##
		sw $s3, 13400($t5)
		sw $s3, 13404($t5)
		sw $s3, 13408($t5)
		sw $s3, 13412($t5)
		sw $s3, 13416($t5)
		sw $s3, 13420($t5)
		sw $s3, 13424($t5)
		sw $s3, 13428($t5)
		sw $s3, 13432($t5)
		sw $s3, 13436($t5)
		sw $s3, 13440($t5)
		sw $s3, 13444($t5)
		sw $s3, 13448($t5)
		sw $s3, 13452($t5)
		sw $s3, 13456($t5)
		sw $s3, 13460($t5)
		sw $s3, 13464($t5)
		sw $s3, 13468($t5)
		sw $s3, 13472($t5)
		
		sw $s3, 13840($t5)##
		sw $s3, 13912($t5)
		sw $s3, 13948($t5)
		sw $s3, 13984($t5)
		
		sw $s3, 14352($t5)##
		sw $s3, 14424($t5)
		sw $s3, 14460($t5)
		sw $s3, 14496($t5)
		
		sw $s3, 14864($t5)##
		sw $s3, 14936($t5)
		sw $s3, 14972($t5)
		sw $s3, 15008($t5)
		
		sw $s3, 15376($t5)##
		sw $s3, 15448($t5)
		sw $s3, 15484($t5)
		sw $s3, 15520($t5)
		
		sw $s3, 15888($t5)##
		sw $s3, 15960($t5)
		sw $s3, 15996($t5)
		sw $s3, 16032($t5)
		
		sw $s3, 16400($t5)##
		sw $s3, 16404($t5)
		sw $s3, 16408($t5)
		sw $s3, 16412($t5)
		sw $s3, 16416($t5)
		sw $s3, 16420($t5)
		sw $s3, 16424($t5)
		sw $s3, 16428($t5)
		sw $s3, 16432($t5)
		sw $s3, 16436($t5)
		sw $s3, 16440($t5)
		sw $s3, 16444($t5)
		sw $s3, 16448($t5)
		sw $s3, 16452($t5)
		sw $s3, 16456($t5)
		sw $s3, 16460($t5)
		sw $s3, 16464($t5)
		sw $s3, 16468($t5)
		sw $s3, 16472($t5)
		sw $s3, 16476($t5)
		sw $s3, 16480($t5)
		sw $s3, 16484($t5)
		sw $s3, 16488($t5)
		sw $s3, 16492($t5)
		sw $s3, 16496($t5)
		sw $s3, 16500($t5)
		sw $s3, 16504($t5)
		sw $s3, 16508($t5)
		sw $s3, 16544($t5)
		
		sw $s3, 16912($t5)##
		sw $s3, 16984($t5)
		sw $s3, 17020($t5)
		sw $s3, 17056($t5)
		
		sw $s3, 17424($t5)##
		sw $s3, 17496($t5)
		sw $s3, 17532($t5)
		sw $s3, 17568($t5)
		
		sw $s3, 17936($t5)##
		sw $s3, 18008($t5)
		sw $s3, 18044($t5)
		sw $s3, 18080($t5)
		
		sw $s3, 18448($t5)##
		sw $s3, 18520($t5)
		sw $s3, 18556($t5)
		sw $s3, 18592($t5)
		
		sw $s3, 18960($t5)##
		sw $s3, 19032($t5)
		sw $s3, 19068($t5)
		sw $s3, 19104($t5)
		
		sw $s3, 19472($t5)##
		sw $s3, 19544($t5)
		sw $s3, 19580($t5)
		sw $s3, 19616($t5)
		
		sw $s3, 19984($t5)##
		sw $s3, 20056($t5)
		sw $s3, 20092($t5)
		sw $s3, 20128($t5)
		
		sw $s3, 20496($t5)##
		sw $s3, 20568($t5)
		sw $s3, 20604($t5)
		sw $s3, 20640($t5)
		
		sw $s3, 21008($t5)##
		sw $s3, 21080($t5)
		sw $s3, 21116($t5)
		sw $s3, 21152($t5)
		
		sw $s3, 21520($t5)##
		sw $s3, 21592($t5)
		sw $s3, 21628($t5)
		sw $s3, 21664($t5)
		
		sw $s3, 22032($t5)##
		sw $s3, 22104($t5)
		sw $s3, 22140($t5)
		sw $s3, 22176($t5)
		
		sw $s3, 22544($t5)##
		sw $s3, 22616($t5)
		sw $s3, 22652($t5)
		sw $s3, 22688($t5)
		
		sw $s3, 23056($t5)##
		sw $s3, 23128($t5)
		sw $s3, 23164($t5)
		sw $s3, 23200($t5)
		
		sw $s3, 23568($t5)##
		sw $s3, 23640($t5)
		sw $s3, 23676($t5)
		sw $s3, 23712($t5)
		
		sw $s3, 24080($t5)##
		sw $s3, 24152($t5)
		sw $s3, 24188($t5)
		sw $s3, 24224($t5)
		
		sw $s3, 24592($t5)##
		sw $s3, 24664($t5)
		sw $s3, 24700($t5)
		sw $s3, 24736($t5)
		
		sw $s3, 25104($t5)##
		sw $s3, 25176($t5)
		sw $s3, 25212($t5)
		sw $s3, 25248($t5)
		
		sw $s3, 25616($t5)##
		sw $s3, 25688($t5)
		sw $s3, 25724($t5)
		sw $s3, 25760($t5)
		
		sw $s3, 26128($t5)##
		sw $s3, 26200($t5)
		sw $s3, 26236($t5)
		sw $s3, 26272($t5)
		
		sw $s3, 26640($t5)##
		sw $s3, 26712($t5)
		sw $s3, 26748($t5)
		sw $s3, 26784($t5)
		
		sw $s3, 27152($t5)##
		sw $s3, 27224($t5)
		sw $s3, 27260($t5)
		sw $s3, 27296($t5)
		
		sw $s3, 27664($t5)##
		sw $s3, 27736($t5)
		sw $s3, 27772($t5)
		sw $s3, 27808($t5)
		
		sw $s3, 28176($t5)##
		sw $s3, 28248($t5)
		sw $s3, 28284($t5)
		sw $s3, 28320($t5)
		
		sw $s3, 28688($t5)##
		sw $s3, 28692($t5)
		sw $s3, 28696($t5)
		sw $s3, 28700($t5)
		sw $s3, 28704($t5)
		sw $s3, 28708($t5)
		sw $s3, 28712($t5)
		sw $s3, 28716($t5)
		sw $s3, 28720($t5)
		sw $s3, 28724($t5)
		sw $s3, 28728($t5)
		sw $s3, 28732($t5)
		sw $s3, 28736($t5)
		sw $s3, 28740($t5)
		sw $s3, 28744($t5)
		sw $s3, 28748($t5)
		sw $s3, 28752($t5)
		sw $s3, 28756($t5)
		sw $s3, 28760($t5)
		sw $s3, 28764($t5)
		sw $s3, 28768($t5)
		sw $s3, 28772($t5)
		sw $s3, 28776($t5)
		sw $s3, 28780($t5)
		sw $s3, 28784($t5)
		sw $s3, 28788($t5)
		sw $s3, 28792($t5)
		sw $s3, 28796($t5)
		sw $s3, 28800($t5)
		sw $s3, 28804($t5)
		sw $s3, 28808($t5)
		sw $s3, 28812($t5)
		sw $s3, 28816($t5)
		sw $s3, 28820($t5)
		sw $s3, 28824($t5)
		sw $s3, 28828($t5)
		sw $s3, 28832($t5)
		
		####
		
		sw $s3, 3932($t5)
		sw $s3, 3936($t5)
		sw $s3, 3940($t5)
		sw $s3, 3944($t5)
		sw $s3, 3948($t5)
		sw $s3, 3952($t5)
		sw $s3, 3956($t5)
		sw $s3, 3960($t5)
		sw $s3, 3964($t5)
		sw $s3, 3968($t5)
		sw $s3, 3972($t5)
		sw $s3, 3976($t5)
		sw $s3, 3980($t5)
		sw $s3, 3984($t5)
		sw $s3, 3988($t5)
		sw $s3, 3992($t5)
		sw $s3, 3996($t5)
		sw $s3, 4000($t5)
		sw $s3, 4004($t5)
		sw $s3, 4008($t5)
		sw $s3, 4012($t5)
		sw $s3, 4016($t5)
		sw $s3, 4020($t5)
		sw $s3, 4024($t5)
		sw $s3, 4028($t5)
		sw $s3, 4032($t5)
		sw $s3, 4036($t5)
		sw $s3, 4040($t5)
		sw $s3, 4044($t5)
		sw $s3, 4048($t5)
		sw $s3, 4052($t5)
		sw $s3, 4056($t5)
		sw $s3, 4060($t5)
		sw $s3, 4064($t5)
		sw $s3, 4068($t5)
		sw $s3, 4072($t5)
		sw $s3, 4076($t5)
		
		sw $s3, 4444($t5)##
		sw $s3, 4480($t5)
		sw $s3, 4516($t5)
		sw $s3, 4588($t5)
		
		sw $s3, 4956($t5)##
		sw $s3, 4992($t5)
		sw $s3, 5028($t5)
		sw $s3, 5100($t5)
		
		sw $s3, 5468($t5)##
		sw $s3, 5504($t5)
		sw $s3, 5540($t5)
		sw $s3, 5612($t5)
		
		sw $s3, 5980($t5)##
		sw $s3, 6016($t5)
		sw $s3, 6052($t5)
		sw $s3, 6124($t5)
		
		sw $s3, 6492($t5)##
		sw $s3, 6528($t5)
		sw $s3, 6564($t5)
		sw $s3, 6636($t5)
		
		sw $s3, 7004($t5)##
		sw $s3, 7040($t5)
		sw $s3, 7076($t5)
		sw $s3, 7148($t5)
		
		sw $s3, 7516($t5)##
		sw $s3, 7552($t5)
		sw $s3, 7588($t5)
		sw $s3, 7660($t5)
		
		sw $s3, 8028($t5)##
		sw $s3, 8064($t5)
		sw $s3, 8100($t5)
		sw $s3, 8172($t5)
		
		sw $s3, 8540($t5)##
		sw $s3, 8576($t5)
		sw $s3, 8612($t5)
		sw $s3, 8684($t5)
		
		sw $s3, 9052($t5)##
		sw $s3, 9088($t5)
		sw $s3, 9124($t5)
		sw $s3, 9196($t5)
		
		sw $s3, 9564($t5)##
		sw $s3, 9600($t5)
		sw $s3, 9636($t5)
		sw $s3, 9708($t5)
		
		sw $s3, 10076($t5)##
		sw $s3, 10112($t5)
		sw $s3, 10148($t5)
		sw $s3, 10220($t5)
		
		sw $s3, 10588($t5)##
		sw $s3, 10592($t5)
		sw $s3, 10596($t5)
		sw $s3, 10600($t5)
		sw $s3, 10604($t5)
		sw $s3, 10608($t5)
		sw $s3, 10612($t5)
		sw $s3, 10616($t5)
		sw $s3, 10620($t5)
		sw $s3, 10624($t5)
		sw $s3, 10628($t5)
		sw $s3, 10632($t5)
		sw $s3, 10636($t5)
		sw $s3, 10640($t5)
		sw $s3, 10644($t5)
		sw $s3, 10648($t5)
		sw $s3, 10652($t5)
		sw $s3, 10656($t5)
		sw $s3, 10660($t5)
		sw $s3, 10732($t5)
		
		sw $s3, 11100($t5)##
		sw $s3, 11136($t5)
		sw $s3, 11172($t5)
		sw $s3, 11244($t5)
		
		sw $s3, 11612($t5)##
		sw $s3, 11648($t5)
		sw $s3, 11684($t5)
		sw $s3, 11756($t5)
		
		sw $s3, 12124($t5)##
		sw $s3, 12160($t5)
		sw $s3, 12196($t5)
		sw $s3, 12268($t5)
		
		sw $s3, 12636($t5)##
		sw $s3, 12672($t5)
		sw $s3, 12708($t5)
		sw $s3, 12780($t5)
		
		sw $s3, 13148($t5)##
		sw $s3, 13184($t5)
		sw $s3, 13220($t5)
		sw $s3, 13292($t5)
		
		sw $s3, 13660($t5)##
		sw $s3, 13664($t5)
		sw $s3, 13668($t5)
		sw $s3, 13672($t5)
		sw $s3, 13676($t5)
		sw $s3, 13680($t5)
		sw $s3, 13684($t5)
		sw $s3, 13688($t5)
		sw $s3, 13692($t5)
		sw $s3, 13696($t5)
		sw $s3, 13700($t5)
		sw $s3, 13704($t5)
		sw $s3, 13708($t5)
		sw $s3, 13712($t5)
		sw $s3, 13716($t5)
		sw $s3, 13720($t5)
		sw $s3, 13724($t5)
		sw $s3, 13728($t5)
		sw $s3, 13732($t5)
		sw $s3, 13804($t5)
		
		sw $s3, 14172($t5)##
		sw $s3, 14208($t5)
		sw $s3, 14244($t5)
		sw $s3, 14316($t5)
		
		sw $s3, 14684($t5)##
		sw $s3, 14720($t5)
		sw $s3, 14756($t5)
		sw $s3, 14828($t5)
		
		sw $s3, 15196($t5)##
		sw $s3, 15232($t5)
		sw $s3, 15268($t5)
		sw $s3, 15340($t5)
		
		sw $s3, 15708($t5)##
		sw $s3, 15744($t5)
		sw $s3, 15780($t5)
		sw $s3, 15852($t5)
		
		sw $s3, 16220($t5)##
		sw $s3, 16256($t5)
		sw $s3, 16292($t5)
		sw $s3, 16364($t5)
		
		sw $s3, 16732($t5)##
		sw $s3, 16768($t5)
		sw $s3, 16772($t5)
		sw $s3, 16776($t5)
		sw $s3, 16780($t5)
		sw $s3, 16784($t5)
		sw $s3, 16788($t5)
		sw $s3, 16792($t5)
		sw $s3, 16796($t5)
		sw $s3, 16800($t5)
		sw $s3, 16804($t5)
		sw $s3, 16808($t5)
		sw $s3, 16812($t5)
		sw $s3, 16816($t5)
		sw $s3, 16820($t5)
		sw $s3, 16824($t5)
		sw $s3, 16828($t5)
		sw $s3, 16832($t5)
		sw $s3, 16836($t5)
		sw $s3, 16840($t5)
		sw $s3, 16844($t5)
		sw $s3, 16848($t5)
		sw $s3, 16852($t5)
		sw $s3, 16856($t5)
		sw $s3, 16860($t5)
		sw $s3, 16864($t5)
		sw $s3, 16868($t5)
		sw $s3, 16872($t5)
		sw $s3, 16876($t5)
		
		sw $s3, 17244($t5)##
		sw $s3, 17280($t5)
		sw $s3, 17316($t5)
		sw $s3, 17388($t5)
		
		sw $s3, 17756($t5)##
		sw $s3, 17792($t5)
		sw $s3, 17828($t5)
		sw $s3, 17900($t5)
		
		sw $s3, 18268($t5)##
		sw $s3, 18304($t5)
		sw $s3, 18340($t5)
		sw $s3, 18412($t5)
		
		sw $s3, 18780($t5)##
		sw $s3, 18816($t5)
		sw $s3, 18852($t5)
		sw $s3, 18924($t5)
		
		sw $s3, 19292($t5)##
		sw $s3, 19328($t5)
		sw $s3, 19364($t5)
		sw $s3, 19436($t5)
		
		sw $s3, 19804($t5)##
		sw $s3, 19840($t5)
		sw $s3, 19876($t5)
		sw $s3, 19948($t5)
		
		sw $s3, 20316($t5)##
		sw $s3, 20352($t5)
		sw $s3, 20388($t5)
		sw $s3, 20460($t5)
		
		sw $s3, 20828($t5)##
		sw $s3, 20864($t5)
		sw $s3, 20900($t5)
		sw $s3, 20972($t5)
		
		sw $s3, 21340($t5)##
		sw $s3, 21376($t5)
		sw $s3, 21412($t5)
		sw $s3, 21484($t5)
		
		sw $s3, 21852($t5)##
		sw $s3, 21888($t5)
		sw $s3, 21924($t5)
		sw $s3, 21996($t5)
		
		sw $s3, 22364($t5)##
		sw $s3, 22400($t5)
		sw $s3, 22436($t5)
		sw $s3, 22508($t5)
		
		sw $s3, 22876($t5)##
		sw $s3, 22912($t5)
		sw $s3, 22948($t5)
		sw $s3, 23020($t5)
		
		sw $s3, 23388($t5)##
		sw $s3, 23424($t5)
		sw $s3, 23460($t5)
		sw $s3, 23532($t5)
		
		sw $s3, 23900($t5)##
		sw $s3, 23936($t5)
		sw $s3, 23972($t5)
		sw $s3, 24044($t5)
		
		sw $s3, 24412($t5)##
		sw $s3, 24448($t5)
		sw $s3, 24484($t5)
		sw $s3, 24556($t5)
		
		sw $s3, 24924($t5)##
		sw $s3, 24960($t5)
		sw $s3, 24996($t5)
		sw $s3, 25068($t5)
		
		sw $s3, 25436($t5)##
		sw $s3, 25472($t5)
		sw $s3, 25508($t5)
		sw $s3, 25580($t5)
		
		sw $s3, 25948($t5)##
		sw $s3, 25984($t5)
		sw $s3, 26020($t5)
		sw $s3, 26092($t5)
		
		sw $s3, 26460($t5)##
		sw $s3, 26496($t5)
		sw $s3, 26532($t5)
		sw $s3, 26604($t5)
		
		sw $s3, 26972($t5)##
		sw $s3, 27008($t5)
		sw $s3, 27044($t5)
		sw $s3, 27116($t5)
		
		sw $s3, 27484($t5)##
		sw $s3, 27520($t5)
		sw $s3, 27556($t5)
		sw $s3, 27628($t5)
		
		sw $s3, 27996($t5)##
		sw $s3, 28032($t5)
		sw $s3, 28068($t5)
		sw $s3, 28140($t5)
		
		sw $s3, 28508($t5)##
		sw $s3, 28544($t5)
		sw $s3, 28580($t5)
		sw $s3, 28652($t5)
		
		sw $s3, 29020($t5)##
		sw $s3, 29024($t5)
		sw $s3, 29028($t5)
		sw $s3, 29032($t5)		
		sw $s3, 29036($t5)
		sw $s3, 29040($t5)
		sw $s3, 29044($t5)
		sw $s3, 29048($t5)
		sw $s3, 29052($t5)
		sw $s3, 29056($t5)
		sw $s3, 29060($t5)
		sw $s3, 29064($t5)
		sw $s3, 29068($t5)
		sw $s3, 29072($t5)
		sw $s3, 29076($t5)
		sw $s3, 29080($t5)
		sw $s3, 29084($t5)
		sw $s3, 29088($t5)
		sw $s3, 29092($t5)
		sw $s3, 29096($t5)
		sw $s3, 29100($t5)
		sw $s3, 29104($t5)
		sw $s3, 29108($t5)
		sw $s3, 29112($t5)
		sw $s3, 29116($t5)
		sw $s3, 29120($t5)
		sw $s3, 29124($t5)
		sw $s3, 29128($t5)
		sw $s3, 29132($t5)
		sw $s3, 29136($t5)
		sw $s3, 29140($t5)
		sw $s3, 29144($t5)
		sw $s3, 29148($t5)
		sw $s3, 29152($t5)
		sw $s3, 29156($t5)
		sw $s3, 29160($t5)
		sw $s3, 29164($t5)
		
		jr $ra
		nop

#================= Numeros ==============

	num_1:
		sw $s3, 55028($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 55544($t6)
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
	
		jr $ra
		nop
		
	num_2:
		sw $s3, 55028($t6)
		sw $s3, 56564($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 57088($t6)
	
		jr $ra
		nop
		
	num_3:
		sw $s3, 55028($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 56056($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
	
		jr $ra
		nop
	
	num_4:
		sw $s3, 55028($t6)
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 56564($t6)
		
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
	
		jr $ra
		nop
		
	num_5:
		sw $s3, 55028($t6)
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 56056($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
	
		jr $ra
		nop
		
	num_6:
		sw $s3, 55028($t6)
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 56564($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 56060($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)	
	
		jr $ra
		nop
		
	num_7:
		sw $s3, 55028($t6)
		sw $s3, 56564($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		
		jr $ra
		nop
		
	num_8:
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 56564($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 55544($t6)
		sw $s3, 56056($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
		
		jr $ra
		nop
		
	num_9:
		sw $s3, 55028($t6)
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 56564($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 55544($t6)
		sw $s3, 56056($t6)
		sw $s3, 56568($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)
		
		jr $ra
		nop
		
	num_0:
		sw $s3, 55028($t6)
		sw $s3, 55540($t6)
		sw $s3, 56052($t6)
		sw $s3, 56564($t6)
		sw $s3, 57076($t6)
		
		sw $s3, 55032($t6)
		sw $s3, 55544($t6)
		sw $s3, 57080($t6)
		
		sw $s3, 55036($t6)
		sw $s3, 55548($t6)
		sw $s3, 56060($t6)
		sw $s3, 56572($t6)
		sw $s3, 57084($t6)
		
		sw $s3, 55040($t6)
		sw $s3, 55552($t6)
		sw $s3, 56064($t6)
		sw $s3, 56576($t6)
		sw $s3, 57088($t6)	
	
		jr $ra
		nop

#================= Numeros ==============
	dog:
		sw $s3, 12992($t0)
		sw $s3, 12996($t0)
		sw $s3, 13008($t0)
		sw $s3, 13012($t0)
		sw $s3, 13016($t0)
		sw $s3, 13020($t0)
		sw $s3, 13024($t0)
		sw $s3, 13028($t0)
		sw $s3, 13032($t0)
		sw $s3, 13036($t0)
		sw $s3, 13048($t0)
		sw $s3, 13052($t0)
		#
		sw $s3, 13504($t0)
		sw $s3, 13508($t0)
		sw $s3, 13520($t0)
		sw $s3, 13524($t0)
		sw $s3, 13528($t0)
		sw $s3, 13532($t0)
		sw $s3, 13536($t0)
		sw $s3, 13540($t0)
		sw $s3, 13544($t0)
		sw $s3, 13548($t0)
		sw $s3, 13560($t0)
		sw $s3, 13564($t0)
		#
		sw $s3, 14016($t0)
		sw $s3, 14020($t0)
		sw $s3, 14024($t0)
		sw $s3, 14028($t0)
		sw $s3, 14032($t0)
		sw $s3, 14036($t0)
		sw $s3, 14040($t0)
		sw $s3, 14044($t0)
		sw $s3, 14048($t0)
		sw $s3, 14052($t0)
		sw $s3, 14056($t0)
		sw $s3, 14060($t0)
		sw $s3, 14064($t0)
		sw $s3, 14068($t0)
		sw $s3, 14072($t0)
		sw $s3, 14076($t0)
		#
		sw $s3, 14528($t0)
		sw $s3, 14532($t0)
		sw $s3, 14536($t0)
		sw $s3, 14540($t0)
		sw $s3, 14544($t0)
		sw $s3, 14548($t0)
		sw $s3, 14552($t0)
		sw $s3, 14556($t0)
		sw $s3, 14560($t0)
		sw $s3, 14564($t0)
		sw $s3, 14568($t0)
		sw $s3, 14572($t0)
		sw $s3, 14576($t0)
		sw $s3, 14580($t0)
		sw $s3, 14584($t0)
		sw $s3, 14588($t0)
		#
		sw $s3, 15040($t0)
		sw $s3, 15044($t0)
		sw $s3, 15048($t0)
		sw $s3, 15052($t0)
		sw $s3, 15056($t0)
		sw $s3, 15060($t0)
		sw $s3, 15064($t0)
		sw $s3, 15068($t0)
		sw $s3, 15072($t0)
		sw $s3, 15076($t0)
		sw $s3, 15080($t0)
		sw $s3, 15084($t0)
		sw $s3, 15088($t0)
		sw $s3, 15092($t0)
		sw $s3, 15096($t0)
		sw $s3, 15100($t0)
		sw $s3, 15104($t0)
		sw $s3, 15108($t0)
		#
		sw $s3, 15552($t0)
		sw $s3, 15556($t0)
		sw $s3, 15560($t0)
		sw $s3, 15564($t0)
		sw $s3, 15568($t0)
		sw $s3, 15572($t0)
		sw $s3, 15576($t0)
		sw $s3, 15580($t0)
		sw $s3, 15584($t0)
		sw $s3, 15588($t0)
		sw $s3, 15592($t0)
		sw $s3, 15596($t0)
		sw $s3, 15600($t0)
		sw $s3, 15604($t0)
		sw $s3, 15608($t0)
		sw $s3, 15612($t0)
		sw $s3, 15616($t0)
		sw $s3, 15620($t0)
		#
		sw $s3, 16056($t0)
		sw $s3, 16060($t0)
		sw $s3, 16064($t0)
		sw $s3, 16068($t0)
		sw $s3, 16080($t0)
		sw $s3, 16084($t0)
		sw $s3, 16088($t0)
		sw $s3, 16092($t0)
		sw $s3, 16104($t0)
		sw $s3, 16108($t0)
		sw $s3, 16112($t0)
		sw $s3, 16116($t0)
		sw $s3, 16120($t0)
		sw $s3, 16124($t0)
		sw $s3, 16128($t0)
		sw $s3, 16132($t0)
		#
		sw $s3, 16568($t0)
		sw $s3, 16572($t0)
		sw $s3, 16576($t0)
		sw $s3, 16580($t0)
		sw $s3, 16592($t0)
		sw $s3, 16596($t0)
		sw $s3, 16600($t0)
		sw $s3, 16604($t0)
		sw $s3, 16616($t0)
		sw $s3, 16620($t0)
		sw $s3, 16624($t0)
		sw $s3, 16628($t0)
		sw $s3, 16632($t0)
		sw $s3, 16636($t0)
		sw $s3, 16640($t0)
		sw $s3, 16644($t0)
		#
		sw $s3, 17080($t0)
		sw $s3, 17084($t0)
		sw $s3, 17088($t0)
		sw $s3, 17092($t0)
		sw $s3, 17096($t0)
		sw $s3, 17100($t0)
		sw $s3, 17104($t0)
		sw $s3, 17108($t0)
		sw $s3, 17112($t0)
		sw $s3, 17116($t0)
		sw $s3, 17120($t0)
		sw $s3, 17124($t0)
		sw $s3, 17128($t0)
		sw $s3, 17132($t0)
		sw $s3, 17136($t0)
		sw $s3, 17140($t0)
		sw $s3, 17144($t0)
		sw $s3, 17148($t0)
		sw $s3, 17152($t0)
		sw $s3, 17156($t0)
		sw $s3, 17160($t0)
		sw $s3, 17164($t0)
		sw $s3, 17168($t0)
		sw $s3, 17172($t0)
		#
		sw $s3, 17592($t0)
		sw $s3, 17596($t0)
		sw $s3, 17600($t0)
		sw $s3, 17604($t0)
		sw $s3, 17608($t0)
		sw $s3, 17612($t0)
		sw $s3, 17616($t0)
		sw $s3, 17620($t0)
		sw $s3, 17624($t0)
		sw $s3, 17628($t0)
		sw $s3, 17632($t0)
		sw $s3, 17636($t0)
		sw $s3, 17640($t0)
		sw $s3, 17644($t0)
		sw $s3, 17648($t0)
		sw $s3, 17652($t0)
		sw $s3, 17656($t0)
		sw $s3, 17660($t0)
		sw $s3, 17664($t0)
		sw $s3, 17668($t0)
		sw $s3, 17672($t0)
		sw $s3, 17676($t0)
		sw $s3, 17680($t0)
		sw $s3, 17684($t0)
		#
		sw $s3, 18104($t0)
		sw $s3, 18108($t0)
		sw $s3, 18112($t0)
		sw $s3, 18116($t0)
		sw $s3, 18120($t0)
		sw $s3, 18124($t0)
		sw $s3, 18144($t0)
		sw $s3, 18148($t0)
		sw $s3, 18152($t0)
		sw $s3, 18156($t0)
		sw $s3, 18160($t0)
		sw $s3, 18164($t0)
		sw $s3, 18168($t0)
		sw $s3, 18172($t0)
		sw $s3, 18176($t0)
		sw $s3, 18180($t0)
		sw $s3, 18184($t0)
		sw $s3, 18188($t0)
		sw $s3, 18192($t0)
		sw $s3, 18196($t0)
		sw $s3, 18200($t0)
		sw $s3, 18204($t0)
		sw $s3, 18208($t0)
		sw $s3, 18212($t0)
		#
		sw $s3, 18616($t0)
		sw $s3, 18620($t0)
		sw $s3, 18624($t0)
		sw $s3, 18628($t0)
		sw $s3, 18632($t0)
		sw $s3, 18636($t0)
		sw $s3, 18656($t0)
		sw $s3, 18660($t0)
		sw $s3, 18664($t0)
		sw $s3, 18668($t0)
		sw $s3, 18672($t0)
		sw $s3, 18676($t0)
		sw $s3, 18680($t0)
		sw $s3, 18684($t0)
		sw $s3, 18688($t0)
		sw $s3, 18692($t0)
		sw $s3, 18696($t0)
		sw $s3, 18700($t0)
		sw $s3, 18704($t0)
		sw $s3, 18708($t0)
		sw $s3, 18712($t0)
		sw $s3, 18716($t0)
		sw $s3, 18720($t0)
		sw $s3, 18724($t0)
		#
		sw $s3, 19128($t0)
		sw $s3, 19132($t0)
		sw $s3, 19144($t0)
		sw $s3, 19148($t0)
		sw $s3, 19160($t0)
		sw $s3, 19164($t0)
		sw $s3, 19168($t0)
		sw $s3, 19172($t0)
		sw $s3, 19184($t0)
		sw $s3, 19188($t0)
		sw $s3, 19192($t0)
		sw $s3, 19196($t0)
		sw $s3, 19200($t0)
		sw $s3, 19204($t0)
		sw $s3, 19208($t0)
		sw $s3, 19212($t0)
		sw $s3, 19216($t0)
		sw $s3, 19220($t0)
		sw $s3, 19224($t0)
		sw $s3, 19228($t0)
		sw $s3, 19232($t0)
		sw $s3, 19236($t0)
		sw $s3, 19240($t0)
		sw $s3, 19244($t0)
		sw $s3, 19248($t0)
		sw $s3, 19252($t0)
		sw $s3, 19256($t0)
		sw $s3, 19260($t0)
		sw $s3, 19264($t0)
		sw $s3, 19268($t0)
		#
		sw $s3, 19640($t0)
		sw $s3, 19644($t0)
		sw $s3, 19656($t0)
		sw $s3, 19660($t0)
		sw $s3, 19672($t0)
		sw $s3, 19676($t0)
		sw $s3, 19680($t0)
		sw $s3, 19684($t0)
		sw $s3, 19696($t0)
		sw $s3, 19700($t0)
		sw $s3, 19704($t0)
		sw $s3, 19708($t0)
		sw $s3, 19712($t0)
		sw $s3, 19716($t0)
		sw $s3, 19720($t0)
		sw $s3, 19724($t0)
		sw $s3, 19728($t0)
		sw $s3, 19732($t0)
		sw $s3, 19736($t0)
		sw $s3, 19740($t0)
		sw $s3, 19744($t0)
		sw $s3, 19748($t0)
		sw $s3, 19752($t0)
		sw $s3, 19756($t0)
		sw $s3, 19760($t0)
		sw $s3, 19764($t0)
		sw $s3, 19768($t0)
		sw $s3, 19772($t0)
		sw $s3, 19776($t0)
		sw $s3, 19780($t0)
		#
		sw $s3, 20152($t0)
		sw $s3, 20156($t0)
		sw $s3, 20160($t0)
		sw $s3, 20164($t0)
		sw $s3, 20200($t0)
		sw $s3, 20204($t0)
		sw $s3, 20208($t0)
		sw $s3, 20212($t0)
		sw $s3, 20216($t0)
		sw $s3, 20220($t0)
		sw $s3, 20224($t0)
		sw $s3, 20228($t0)
		sw $s3, 20232($t0)
		sw $s3, 20236($t0)
		sw $s3, 20240($t0)
		sw $s3, 20244($t0)
		sw $s3, 20248($t0)
		sw $s3, 20252($t0)
		sw $s3, 20256($t0)
		sw $s3, 20260($t0)
		sw $s3, 20264($t0)
		sw $s3, 20268($t0)
		sw $s3, 20272($t0)
		sw $s3, 20276($t0)
		sw $s3, 20280($t0)
		sw $s3, 20284($t0)
		sw $s3, 20288($t0)
		sw $s3, 20292($t0)
		#
		sw $s3, 20664($t0)
		sw $s3, 20668($t0)
		sw $s3, 20672($t0)
		sw $s3, 20676($t0)
		sw $s3, 20712($t0)
		sw $s3, 20716($t0)
		sw $s3, 20720($t0)
		sw $s3, 20724($t0)
		sw $s3, 20728($t0)
		sw $s3, 20732($t0)
		sw $s3, 20736($t0)
		sw $s3, 20740($t0)
		sw $s3, 20744($t0)
		sw $s3, 20748($t0)
		sw $s3, 20752($t0)
		sw $s3, 20756($t0)
		sw $s3, 20760($t0)
		sw $s3, 20764($t0)
		sw $s3, 20768($t0)
		sw $s3, 20772($t0)
		sw $s3, 20776($t0)
		sw $s3, 20780($t0)
		sw $s3, 20784($t0)
		sw $s3, 20788($t0)
		sw $s3, 20792($t0)
		sw $s3, 20796($t0)
		sw $s3, 20800($t0)
		sw $s3, 20804($t0)
		#
		sw $s3, 21176($t0)
		sw $s3, 21180($t0)
		sw $s3, 21184($t0)
		sw $s3, 21188($t0)
		sw $s3, 21192($t0)
		sw $s3, 21196($t0)
		sw $s3, 21200($t0)
		sw $s3, 21204($t0)
		sw $s3, 21208($t0)
		sw $s3, 21212($t0)
		sw $s3, 21216($t0)
		sw $s3, 21220($t0)
		sw $s3, 21224($t0)
		sw $s3, 21228($t0)
		sw $s3, 21232($t0)
		sw $s3, 21236($t0)
		sw $s3, 21240($t0)
		sw $s3, 21244($t0)
		sw $s3, 21248($t0)
		sw $s3, 21252($t0)
		sw $s3, 21256($t0)
		sw $s3, 21260($t0)
		sw $s3, 21264($t0)
		sw $s3, 21268($t0)
		sw $s3, 21272($t0)
		sw $s3, 21276($t0)
		sw $s3, 21280($t0)
		sw $s3, 21284($t0)
		sw $s3, 21288($t0)
		sw $s3, 21292($t0)
		sw $s3, 21296($t0)
		sw $s3, 21300($t0)
		sw $s3, 21304($t0)
		sw $s3, 21308($t0)
		sw $s3, 21312($t0)
		sw $s3, 21316($t0)
		#
		sw $s3, 21688($t0)
		sw $s3, 21692($t0)
		sw $s3, 21696($t0)
		sw $s3, 21700($t0)
		sw $s3, 21704($t0)
		sw $s3, 21708($t0)
		sw $s3, 21712($t0)
		sw $s3, 21716($t0)
		sw $s3, 21720($t0)
		sw $s3, 21724($t0)
		sw $s3, 21728($t0)
		sw $s3, 21732($t0)
		sw $s3, 21736($t0)
		sw $s3, 21740($t0)
		sw $s3, 21744($t0)
		sw $s3, 21748($t0)
		sw $s3, 21752($t0)
		sw $s3, 21756($t0)
		sw $s3, 21760($t0)
		sw $s3, 21764($t0)
		sw $s3, 21768($t0)
		sw $s3, 21772($t0)
		sw $s3, 21776($t0)
		sw $s3, 21780($t0)
		sw $s3, 21784($t0)
		sw $s3, 21788($t0)
		sw $s3, 21792($t0)
		sw $s3, 21796($t0)
		sw $s3, 21800($t0)
		sw $s3, 21804($t0)
		sw $s3, 21808($t0)
		sw $s3, 21812($t0)
		sw $s3, 21816($t0)
		sw $s3, 21820($t0)
		sw $s3, 21824($t0)
		sw $s3, 21828($t0)
		#
		sw $s3, 22200($t0)
		sw $s3, 22204($t0)
		sw $s3, 22208($t0)
		sw $s3, 22212($t0)
		sw $s3, 22216($t0)
		sw $s3, 22220($t0)
		sw $s3, 22224($t0)
		sw $s3, 22228($t0)
		sw $s3, 22232($t0)
		sw $s3, 22236($t0)
		sw $s3, 22240($t0)
		sw $s3, 22244($t0)
		sw $s3, 22248($t0)
		sw $s3, 22252($t0)
		sw $s3, 22256($t0)
		sw $s3, 22260($t0)
		sw $s3, 22264($t0)
		sw $s3, 22268($t0)
		sw $s3, 22272($t0)
		sw $s3, 22276($t0)
		sw $s3, 22280($t0)
		sw $s3, 22284($t0)
		sw $s3, 22288($t0)
		sw $s3, 22292($t0)
		sw $s3, 22296($t0)
		sw $s3, 22300($t0)
		sw $s3, 22304($t0)
		sw $s3, 22308($t0)
		sw $s3, 22312($t0)
		sw $s3, 22316($t0)
		sw $s3, 22320($t0)
		sw $s3, 22324($t0)
		sw $s3, 22328($t0)
		sw $s3, 22332($t0)
		sw $s3, 22336($t0)
		sw $s3, 22340($t0)
		#
		sw $s3, 22712($t0)
		sw $s3, 22716($t0)
		sw $s3, 22720($t0)
		sw $s3, 22724($t0)
		sw $s3, 22728($t0)
		sw $s3, 22732($t0)
		sw $s3, 22736($t0)
		sw $s3, 22740($t0)
		sw $s3, 22744($t0)
		sw $s3, 22748($t0)
		sw $s3, 22752($t0)
		sw $s3, 22756($t0)
		sw $s3, 22760($t0)
		sw $s3, 22764($t0)
		sw $s3, 22768($t0)
		sw $s3, 22772($t0)
		sw $s3, 22776($t0)
		sw $s3, 22780($t0)
		sw $s3, 22784($t0)
		sw $s3, 22788($t0)
		sw $s3, 22792($t0)
		sw $s3, 22796($t0)
		sw $s3, 22800($t0)
		sw $s3, 22804($t0)
		sw $s3, 22808($t0)
		sw $s3, 22812($t0)
		sw $s3, 22816($t0)
		sw $s3, 22820($t0)
		sw $s3, 22824($t0)
		sw $s3, 22828($t0)
		sw $s3, 22832($t0)
		sw $s3, 22836($t0)
		sw $s3, 22840($t0)
		sw $s3, 22844($t0)
		sw $s3, 22848($t0)
		sw $s3, 22852($t0)
		#
		sw $s3, 23224($t0)
		sw $s3, 23228($t0)
		sw $s3, 23232($t0)
		sw $s3, 23236($t0)
		sw $s3, 23240($t0)
		sw $s3, 23244($t0)
		sw $s3, 23248($t0)
		sw $s3, 23252($t0)
		sw $s3, 23256($t0)
		sw $s3, 23260($t0)
		sw $s3, 23264($t0)
		sw $s3, 23268($t0)
		sw $s3, 23272($t0)
		sw $s3, 23276($t0)
		sw $s3, 23280($t0)
		sw $s3, 23284($t0)
		sw $s3, 23288($t0)
		sw $s3, 23292($t0)
		sw $s3, 23296($t0)
		sw $s3, 23300($t0)
		sw $s3, 23304($t0)
		sw $s3, 23308($t0)
		sw $s3, 23312($t0)
		sw $s3, 23316($t0)
		sw $s3, 23320($t0)
		sw $s3, 23324($t0)
		sw $s3, 23328($t0)
		sw $s3, 23332($t0)
		sw $s3, 23336($t0)
		sw $s3, 23340($t0)
		sw $s3, 23344($t0)
		sw $s3, 23348($t0)
		sw $s3, 23352($t0)
		sw $s3, 23356($t0)
		sw $s3, 23360($t0)
		sw $s3, 23364($t0)
		#
		sw $s3, 23736($t0)
		sw $s3, 23740($t0)
		sw $s3, 23744($t0)
		sw $s3, 23748($t0)
		sw $s3, 23752($t0)
		sw $s3, 23756($t0)
		sw $s3, 23760($t0)
		sw $s3, 23764($t0)
		sw $s3, 23768($t0)
		sw $s3, 23772($t0)
		sw $s3, 23776($t0)
		sw $s3, 23780($t0)
		sw $s3, 23784($t0)
		sw $s3, 23788($t0)
		sw $s3, 23792($t0)
		sw $s3, 23796($t0)
		sw $s3, 23800($t0)
		sw $s3, 23804($t0)
		sw $s3, 23808($t0)
		sw $s3, 23812($t0)
		sw $s3, 23816($t0)
		sw $s3, 23820($t0)
		sw $s3, 23824($t0)
		sw $s3, 23828($t0)
		sw $s3, 23832($t0)
		sw $s3, 23836($t0)
		sw $s3, 23840($t0)
		sw $s3, 23844($t0)
		sw $s3, 23848($t0)
		sw $s3, 23852($t0)
		sw $s3, 23856($t0)
		sw $s3, 23860($t0)
		sw $s3, 23864($t0)
		sw $s3, 23868($t0)
		sw $s3, 23872($t0)
		sw $s3, 23876($t0)
		#
		sw $s3, 24248($t0)
		sw $s3, 24252($t0)
		sw $s3, 24256($t0)
		sw $s3, 24260($t0)
		sw $s3, 24264($t0)
		sw $s3, 24268($t0)
		sw $s3, 24272($t0)
		sw $s3, 24276($t0)
		sw $s3, 24280($t0)
		sw $s3, 24284($t0)
		sw $s3, 24288($t0)
		sw $s3, 24292($t0)
		sw $s3, 24296($t0)
		sw $s3, 24300($t0)
		sw $s3, 24304($t0)
		sw $s3, 24308($t0)
		sw $s3, 24312($t0)
		sw $s3, 24316($t0)
		sw $s3, 24320($t0)
		sw $s3, 24324($t0)
		sw $s3, 24328($t0)
		sw $s3, 24332($t0)
		sw $s3, 24336($t0)
		sw $s3, 24340($t0)
		sw $s3, 24344($t0)
		sw $s3, 24348($t0)
		sw $s3, 24352($t0)
		sw $s3, 24356($t0)
		sw $s3, 24360($t0)
		sw $s3, 24364($t0)
		sw $s3, 24368($t0)
		sw $s3, 24372($t0)
		sw $s3, 24376($t0)
		sw $s3, 24380($t0)
		sw $s3, 24384($t0)
		sw $s3, 24388($t0)
		#
		sw $s3, 24760($t0)
		sw $s3, 24764($t0)
		sw $s3, 24768($t0)
		sw $s3, 24772($t0)
		sw $s3, 24776($t0)
		sw $s3, 24780($t0)
		sw $s3, 24784($t0)
		sw $s3, 24788($t0)
		sw $s3, 24792($t0)
		sw $s3, 24796($t0)
		sw $s3, 24800($t0)
		sw $s3, 24804($t0)
		sw $s3, 24808($t0)
		sw $s3, 24812($t0)
		sw $s3, 24816($t0)
		sw $s3, 24820($t0)
		sw $s3, 24824($t0)
		sw $s3, 24828($t0)
		sw $s3, 24832($t0)
		sw $s3, 24836($t0)
		sw $s3, 24840($t0)
		sw $s3, 24844($t0)
		sw $s3, 24848($t0)
		sw $s3, 24852($t0)
		sw $s3, 24856($t0)
		sw $s3, 24860($t0)
		sw $s3, 24864($t0)
		sw $s3, 24868($t0)
		sw $s3, 24872($t0)
		sw $s3, 24876($t0)
		sw $s3, 24880($t0)
		sw $s3, 24884($t0)
		sw $s3, 24888($t0)
		sw $s3, 24892($t0)
		sw $s3, 24896($t0)
		sw $s3, 24900($t0)
		#
		sw $s3, 25272($t0)
		sw $s3, 25276($t0)
		sw $s3, 25280($t0)
		sw $s3, 25284($t0)
		sw $s3, 25288($t0)
		sw $s3, 25292($t0)
		sw $s3, 25296($t0)
		sw $s3, 25300($t0)
		sw $s3, 25304($t0)
		sw $s3, 25308($t0)
		sw $s3, 25312($t0)
		sw $s3, 25316($t0)
		sw $s3, 25320($t0)
		sw $s3, 25324($t0)
		sw $s3, 25328($t0)
		sw $s3, 25332($t0)
		sw $s3, 25336($t0)
		sw $s3, 25340($t0)
		sw $s3, 25344($t0)
		sw $s3, 25348($t0)
		sw $s3, 25352($t0)
		sw $s3, 25356($t0)
		sw $s3, 25360($t0)
		sw $s3, 25364($t0)
		sw $s3, 25368($t0)
		sw $s3, 25372($t0)
		sw $s3, 25376($t0)
		sw $s3, 25380($t0)
		sw $s3, 25384($t0)
		sw $s3, 25388($t0)
		sw $s3, 25392($t0)
		sw $s3, 25396($t0)
		sw $s3, 25400($t0)
		sw $s3, 25404($t0)
		sw $s3, 25408($t0)
		sw $s3, 25412($t0)
		#
		sw $s3, 25784($t0)
		sw $s3, 25788($t0)
		sw $s3, 25792($t0)
		sw $s3, 25796($t0)
		sw $s3, 25800($t0)
		sw $s3, 25804($t0)
		sw $s3, 25808($t0)
		sw $s3, 25812($t0)
		sw $s3, 25816($t0)
		sw $s3, 25820($t0)
		sw $s3, 25824($t0)
		sw $s3, 25828($t0)
		sw $s3, 25832($t0)
		sw $s3, 25836($t0)
		sw $s3, 25840($t0)
		sw $s3, 25844($t0)
		sw $s3, 25848($t0)
		sw $s3, 25852($t0)
		sw $s3, 25856($t0)
		sw $s3, 25860($t0)
		sw $s3, 25864($t0)
		sw $s3, 25868($t0)
		sw $s3, 25872($t0)
		sw $s3, 25876($t0)
		sw $s3, 25880($t0)
		sw $s3, 25884($t0)
		sw $s3, 25888($t0)
		sw $s3, 25892($t0)
		sw $s3, 25896($t0)
		sw $s3, 25900($t0)
		sw $s3, 25904($t0)
		sw $s3, 25908($t0)
		sw $s3, 25912($t0)
		sw $s3, 25916($t0)
		sw $s3, 25920($t0)
		sw $s3, 25924($t0)
		#
		sw $s3, 26296($t0)
		sw $s3, 26300($t0)
		sw $s3, 26304($t0)
		sw $s3, 26308($t0)
		sw $s3, 26312($t0)
		sw $s3, 26316($t0)
		sw $s3, 26320($t0)
		sw $s3, 26324($t0)
		sw $s3, 26328($t0)
		sw $s3, 26332($t0)
		sw $s3, 26336($t0)
		sw $s3, 26340($t0)
		sw $s3, 26344($t0)
		sw $s3, 26348($t0)
		sw $s3, 26352($t0)
		sw $s3, 26356($t0)
		sw $s3, 26360($t0)
		sw $s3, 26364($t0)
		sw $s3, 26368($t0)
		sw $s3, 26372($t0)
		sw $s3, 26376($t0)
		sw $s3, 26380($t0)
		sw $s3, 26384($t0)
		sw $s3, 26388($t0)
		sw $s3, 26392($t0)
		sw $s3, 26396($t0)
		sw $s3, 26400($t0)
		sw $s3, 26404($t0)
		sw $s3, 26408($t0)
		sw $s3, 26412($t0)
		sw $s3, 26416($t0)
		sw $s3, 26420($t0)
		sw $s3, 26424($t0)
		sw $s3, 26428($t0)
		#
		sw $s3, 26808($t0)
		sw $s3, 26812($t0)
		sw $s3, 26816($t0)
		sw $s3, 26820($t0)
		sw $s3, 26824($t0)
		sw $s3, 26828($t0)
		sw $s3, 26832($t0)
		sw $s3, 26836($t0)
		sw $s3, 26840($t0)
		sw $s3, 26844($t0)
		sw $s3, 26848($t0)
		sw $s3, 26852($t0)
		sw $s3, 26856($t0)
		sw $s3, 26860($t0)
		sw $s3, 26864($t0)
		sw $s3, 26868($t0)
		sw $s3, 26872($t0)
		sw $s3, 26876($t0)
		sw $s3, 26880($t0)
		sw $s3, 26884($t0)
		sw $s3, 26888($t0)
		sw $s3, 26892($t0)
		sw $s3, 26896($t0)
		sw $s3, 26900($t0)
		sw $s3, 26904($t0)
		sw $s3, 26908($t0)
		sw $s3, 26912($t0)
		sw $s3, 26916($t0)
		sw $s3, 26920($t0)
		sw $s3, 26924($t0)
		sw $s3, 26928($t0)
		sw $s3, 26932($t0)
		sw $s3, 26936($t0)
		sw $s3, 26940($t0)
		#
		sw $s3, 27328($t0)
		sw $s3, 27332($t0)
		sw $s3, 27336($t0)
		sw $s3, 27340($t0)
		sw $s3, 27344($t0)
		sw $s3, 27348($t0)
		sw $s3, 27352($t0)
		sw $s3, 27356($t0)
		sw $s3, 27360($t0)
		sw $s3, 27364($t0)
		sw $s3, 27368($t0)
		sw $s3, 27372($t0)
		sw $s3, 27376($t0)
		sw $s3, 27380($t0)
		sw $s3, 27384($t0)
		sw $s3, 27388($t0)
		sw $s3, 27392($t0)
		sw $s3, 27396($t0)
		sw $s3, 27400($t0)
		sw $s3, 27404($t0)
		sw $s3, 27408($t0)
		sw $s3, 27412($t0)
		sw $s3, 27416($t0)
		sw $s3, 27420($t0)
		sw $s3, 27424($t0)
		sw $s3, 27428($t0)
		sw $s3, 27432($t0)
		sw $s3, 27436($t0)
		sw $s3, 27440($t0)
		sw $s3, 27444($t0)
		sw $s3, 27448($t0)
		sw $s3, 27452($t0)
		#
		sw $s3, 27840($t0)
		sw $s3, 27844($t0)
		sw $s3, 27848($t0)
		sw $s3, 27852($t0)
		sw $s3, 27856($t0)
		sw $s3, 27860($t0)
		sw $s3, 27864($t0)
		sw $s3, 27868($t0)
		sw $s3, 27872($t0)
		sw $s3, 27876($t0)
		sw $s3, 27880($t0)
		sw $s3, 27884($t0)
		sw $s3, 27888($t0)
		sw $s3, 27892($t0)
		sw $s3, 27896($t0)
		sw $s3, 27900($t0)
		sw $s3, 27904($t0)
		sw $s3, 27908($t0)
		sw $s3, 27912($t0)
		sw $s3, 27916($t0)
		sw $s3, 27920($t0)
		sw $s3, 27924($t0)
		sw $s3, 27928($t0)
		sw $s3, 27932($t0)
		sw $s3, 27936($t0)
		sw $s3, 27940($t0)
		sw $s3, 27944($t0)
		sw $s3, 27948($t0)
		sw $s3, 27952($t0)
		sw $s3, 27956($t0)
		sw $s3, 27960($t0)
		sw $s3, 27964($t0)
		
		jr $ra
		nop
		
	dog_mov1:
		sw $s3, 17216($t0)
		sw $s3, 17220($t0)
		sw $s3, 17728($t0)
		sw $s3, 17732($t0)
		sw $s3, 18240($t0)
		sw $s3, 18244($t0)
		sw $s3, 18752($t0)
		sw $s3, 18756($t0)
		##
		sw $s3, 28352($t0)
		sw $s3, 28356($t0)
		sw $s3, 28360($t0)
		sw $s3, 28364($t0)
		sw $s3, 28864($t0)
		sw $s3, 28868($t0)
		sw $s3, 28872($t0)
		sw $s3, 28876($t0)
		sw $s3, 29376($t0)
		sw $s3, 29380($t0)
		sw $s3, 29384($t0)
		sw $s3, 29388($t0)
		sw $s3, 29888($t0)
		sw $s3, 29892($t0)
		sw $s3, 29896($t0)
		sw $s3, 29900($t0)
		sw $s3, 30400($t0)
		sw $s3, 30404($t0)
		sw $s3, 30912($t0)
		sw $s3, 30916($t0)
		#
		sw $s3, 28384($t0)
		sw $s3, 28388($t0)
		sw $s3, 28392($t0)
		sw $s3, 28396($t0)
		sw $s3, 28896($t0)
		sw $s3, 28900($t0)
		sw $s3, 28904($t0)
		sw $s3, 28908($t0)
		sw $s3, 29408($t0)
		sw $s3, 29412($t0)
		sw $s3, 29920($t0)
		sw $s3, 29924($t0)
		#
		sw $s3, 28432($t0)
		sw $s3, 28436($t0)
		sw $s3, 28440($t0)
		sw $s3, 28444($t0)
		sw $s3, 28944($t0)
		sw $s3, 28948($t0)
		sw $s3, 28952($t0)
		sw $s3, 28956($t0)
		sw $s3, 29456($t0)
		sw $s3, 29460($t0)
		sw $s3, 29464($t0)
		sw $s3, 29468($t0)
		sw $s3, 29968($t0)
		sw $s3, 29972($t0)
		sw $s3, 29976($t0)
		sw $s3, 29980($t0)
		sw $s3, 30480($t0)
		sw $s3, 30484($t0)
		sw $s3, 30992($t0)
		sw $s3, 30996($t0)
		#
		sw $s3, 28464($t0)
		sw $s3, 28468($t0)
		sw $s3, 28472($t0)
		sw $s3, 28476($t0)
		sw $s3, 28976($t0)
		sw $s3, 28980($t0)
		sw $s3, 28984($t0)
		sw $s3, 28988($t0)
		sw $s3, 29488($t0)
		sw $s3, 29492($t0)
		sw $s3, 30000($t0)
		sw $s3, 30004($t0)
	
		jr $ra
		nop
		
	dog_mov2:
		sw $s3, 19272($t0)
		sw $s3, 19276($t0)
		sw $s3, 19280($t0)
		sw $s3, 19284($t0)
		sw $s3, 19784($t0)
		sw $s3, 19788($t0)
		sw $s3, 19792($t0)
		sw $s3, 19796($t0)
		##
		sw $s3, 28352($t0)
		sw $s3, 28356($t0)
		sw $s3, 28360($t0)
		sw $s3, 28364($t0)
		sw $s3, 28864($t0)
		sw $s3, 28868($t0)
		sw $s3, 28872($t0)
		sw $s3, 28876($t0)
		sw $s3, 29376($t0)
		sw $s3, 29380($t0)
		sw $s3, 29888($t0)
		sw $s3, 29892($t0)
		#
		sw $s3, 28384($t0)
		sw $s3, 28388($t0)
		sw $s3, 28392($t0)
		sw $s3, 28396($t0)
		sw $s3, 28896($t0)
		sw $s3, 28900($t0)
		sw $s3, 28904($t0)
		sw $s3, 28908($t0)
		sw $s3, 29408($t0)
		sw $s3, 29412($t0)
		sw $s3, 29416($t0)
		sw $s3, 29420($t0)
		sw $s3, 29920($t0)
		sw $s3, 29924($t0)
		sw $s3, 29928($t0)
		sw $s3, 29932($t0)
		sw $s3, 30432($t0)
		sw $s3, 30436($t0)
		sw $s3, 30944($t0)
		sw $s3, 30948($t0)
		#
		sw $s3, 28432($t0)
		sw $s3, 28436($t0)
		sw $s3, 28440($t0)
		sw $s3, 28444($t0)
		sw $s3, 28944($t0)
		sw $s3, 28948($t0)
		sw $s3, 28952($t0)
		sw $s3, 28956($t0)
		sw $s3, 29456($t0)
		sw $s3, 29460($t0)
		sw $s3, 29968($t0)
		sw $s3, 29972($t0)
		#
		sw $s3, 28464($t0)
		sw $s3, 28468($t0)
		sw $s3, 28472($t0)
		sw $s3, 28476($t0)
		sw $s3, 28976($t0)
		sw $s3, 28980($t0)
		sw $s3, 28984($t0)
		sw $s3, 28988($t0)
		sw $s3, 29488($t0)
		sw $s3, 29492($t0)
		sw $s3, 29496($t0)
		sw $s3, 29500($t0)
		sw $s3, 30000($t0)
		sw $s3, 30004($t0)
		sw $s3, 30008($t0)
		sw $s3, 30012($t0)
		sw $s3, 30512($t0)
		sw $s3, 30516($t0)
		sw $s3, 31024($t0)
		sw $s3, 31028($t0)
		
		jr $ra
		nop
		
#================== Heart ===================
	heart:
		sw $s3, 42232($t1)
		sw $s3, 42244($t1)
		sw $s3, 42740($t1)
		sw $s3, 42744($t1)
		sw $s3, 42748($t1)
		sw $s3, 42752($t1)
		sw $s3, 42756($t1)
		sw $s3, 42760($t1)
		sw $s3, 43252($t1)
		sw $s3, 43256($t1)
		sw $s3, 43260($t1)
		sw $s3, 43264($t1)
		sw $s3, 43268($t1)
		sw $s3, 43272($t1)
		sw $s3, 43768($t1)
		sw $s3, 43772($t1)
		sw $s3, 43776($t1)
		sw $s3, 43780($t1)
		sw $s3, 44284($t1)
		sw $s3, 44288($t1)
	
		jr $ra
		nop
#================= Start Message ===============
	startMsg:
		sw $s3, 4648($t5)
		sw $s3, 4652($t5)
		sw $s3, 5156($t5)
		sw $s3, 5164($t5)
		sw $s3, 5676($t5)
		sw $s3, 6188($t5)
		sw $s3, 6692($t5)
		sw $s3, 6696($t5)
		sw $s3, 6700($t5)
		sw $s3, 6704($t5)
		#
		sw $s3, 5692($t5)
		sw $s3, 5696($t5)
		#
		sw $s3, 4688($t5)
		sw $s3, 4692($t5)
		sw $s3, 4696($t5)
		sw $s3, 4700($t5)
		sw $s3, 5200($t5)
		sw $s3, 5712($t5)
		sw $s3, 5716($t5) 
		sw $s3, 5720($t5)
		sw $s3, 6224($t5)
		sw $s3, 6736($t5)
		#
		sw $s3, 4708($t5)
		sw $s3, 4712($t5)
		sw $s3, 4716($t5)
		sw $s3, 5224($t5)
		sw $s3, 5736($t5)
		sw $s3, 6248($t5)
		sw $s3, 6756($t5)
		sw $s3, 6760($t5)
		sw $s3, 6764($t5)
		#
		sw $s3, 4724($t5)
		sw $s3, 4728($t5)
		sw $s3, 4732($t5)
		sw $s3, 4736($t5)
		sw $s3, 5236($t5)
		sw $s3, 5748($t5)
		sw $s3, 5756($t5)
		sw $s3, 5760($t5)
		sw $s3, 6260($t5)
		sw $s3, 6272($t5)
		sw $s3, 6772($t5)
		sw $s3, 6776($t5)
		sw $s3, 6780($t5)
		sw $s3, 6784($t5)
		#
		sw $s3, 4744($t5)
		sw $s3, 4756($t5)
		sw $s3, 5256($t5)
		sw $s3, 5268($t5)
		sw $s3, 5768($t5)
		sw $s3, 5780($t5)
		sw $s3, 5772($t5)
		sw $s3, 5776($t5)
		sw $s3, 6280($t5)
		sw $s3, 6292($t5)
		sw $s3, 6792($t5)
		sw $s3, 6804($t5)
		#
		sw $s3, 4764($t5)
		sw $s3, 4768($t5)
		sw $s3, 4772($t5)
		sw $s3, 5280($t5)
		sw $s3, 5792($t5)
		sw $s3, 6304($t5)
		sw $s3, 6816($t5)
		#
		sw $s3, 4788($t5)
		sw $s3, 4804($t5)
		sw $s3, 5300($t5)
		sw $s3, 5304($t5)
		sw $s3, 5312($t5)
		sw $s3, 5316($t5)
		sw $s3, 5812($t5)
		sw $s3, 5820($t5)
		sw $s3, 5828($t5)
		sw $s3, 6324($t5)
		sw $s3, 6340($t5)
		sw $s3, 6836($t5)
		sw $s3, 6852($t5)
		#
		sw $s3, 4812($t5)
		sw $s3, 4816($t5)
		sw $s3, 4820($t5)
		sw $s3, 4824($t5)
		sw $s3, 5324($t5)
		sw $s3, 5336($t5)
		sw $s3, 5836($t5)
		sw $s3, 5848($t5)
		sw $s3, 6348($t5) 
		sw $s3, 6360($t5)
		sw $s3, 6860($t5)
		sw $s3, 6864($t5)
		sw $s3, 6868($t5)
		sw $s3, 6872($t5)
		#
		sw $s3, 4832($t5)
		sw $s3, 4836($t5)
		sw $s3, 4840($t5)
		sw $s3, 5344($t5)
		sw $s3, 5356($t5)
		sw $s3, 5856($t5)
		sw $s3, 5868($t5)
		sw $s3, 6368($t5)
		sw $s3, 6380($t5) 
		sw $s3, 6880($t5)
		sw $s3, 6884($t5)
		sw $s3, 6888($t5)
		#
		sw $s3, 4852($t5)
		sw $s3, 4856($t5)
		sw $s3, 4860($t5)
		sw $s3, 4864($t5)
		sw $s3, 5364($t5)
		sw $s3, 5876($t5)
		sw $s3, 5880($t5)
		sw $s3, 5884($t5)
		sw $s3, 6388($t5) 
		sw $s3, 6900($t5)
		sw $s3, 6904($t5)
		sw $s3, 6908($t5)
		sw $s3, 6912($t5)
		### 2 - mercy mode
		sw $s3, 8740($t5)
		sw $s3, 8744($t5)
		sw $s3, 8748($t5)
		sw $s3, 9260($t5)
		sw $s3, 9264($t5)
		sw $s3, 9768($t5)
		sw $s3, 9772($t5)
		sw $s3, 9776($t5)
		sw $s3, 10276($t5) 
		sw $s3, 10280($t5)
		sw $s3, 10788($t5)
		sw $s3, 10792($t5)
		sw $s3, 10796($t5)
		sw $s3, 10800($t5)
		#
		sw $s3, 9788($t5)
		sw $s3, 9792($t5)
		#
		sw $s3, 8780($t5)
		sw $s3, 8796($t5)
		sw $s3, 9292($t5)
		sw $s3, 9296($t5)
		sw $s3, 9304($t5)
		sw $s3, 9308($t5)
		sw $s3, 9804($t5)
		sw $s3, 9812($t5)
		sw $s3, 9820($t5) 
		sw $s3, 10316($t5)
		sw $s3, 10332($t5)
		sw $s3, 10828($t5)
		sw $s3, 10844($t5)
		#
		sw $s3, 8804($t5)
		sw $s3, 8808($t5)
		sw $s3, 8812($t5)
		sw $s3, 8816($t5)
		sw $s3, 9316($t5)
		sw $s3, 9828($t5)
		sw $s3, 9832($t5)
		sw $s3, 9836($t5)
		sw $s3, 10340($t5) 
		sw $s3, 10852($t5)
		sw $s3, 10856($t5)
		sw $s3, 10860($t5)
		sw $s3, 10864($t5)
		#
		sw $s3, 8824($t5)
		sw $s3, 8828($t5)
		sw $s3, 8832($t5)
		sw $s3, 8836($t5)
		sw $s3, 9336($t5)
		sw $s3, 9348($t5)
		sw $s3, 9848($t5)
		sw $s3, 9852($t5)
		sw $s3, 9856($t5) 
		sw $s3, 9860($t5)
		sw $s3, 10360($t5)
		sw $s3, 10368($t5)
		sw $s3, 10872($t5)
		sw $s3, 10884($t5)
		#
		sw $s3, 8844($t5)
		sw $s3, 8848($t5)
		sw $s3, 8852($t5)
		sw $s3, 8856($t5)
		sw $s3, 9356($t5)
		sw $s3, 9868($t5)
		sw $s3, 10380($t5)
		sw $s3, 10892($t5)
		sw $s3, 10896($t5) 
		sw $s3, 10900($t5)
		sw $s3, 10904($t5)
		#
		sw $s3, 8864($t5)
		sw $s3, 8872($t5)
		sw $s3, 9376($t5)
		sw $s3, 9380($t5)
		sw $s3, 9384($t5)
		sw $s3, 9892($t5)
		sw $s3, 10404($t5)
		sw $s3, 10916($t5)
		#
		sw $s3, 8888($t5)
		sw $s3, 8904($t5)
		sw $s3, 9400($t5)
		sw $s3, 9404($t5)
		sw $s3, 9412($t5)
		sw $s3, 9416($t5)
		sw $s3, 9912($t5)
		sw $s3, 9920($t5)
		sw $s3, 9928($t5) 
		sw $s3, 10424($t5)
		sw $s3, 10440($t5)
		sw $s3, 10936($t5)
		sw $s3, 10952($t5)
		#
		sw $s3, 8912($t5)
		sw $s3, 8916($t5)
		sw $s3, 8920($t5)
		sw $s3, 8924($t5)
		sw $s3, 9424($t5)
		sw $s3, 9436($t5)
		sw $s3, 9936($t5)
		sw $s3, 9948($t5)
		sw $s3, 10448($t5) 
		sw $s3, 10460($t5)
		sw $s3, 10960($t5)
		sw $s3, 10964($t5)
		sw $s3, 10968($t5)
		sw $s3, 10972($t5)
		#
		sw $s3, 8932($t5)
		sw $s3, 8936($t5)
		sw $s3, 8940($t5)
		sw $s3, 9444($t5)
		sw $s3, 9456($t5)
		sw $s3, 9956($t5)
		sw $s3, 9968($t5)
		sw $s3, 10468($t5)
		sw $s3, 10480($t5) 
		sw $s3, 10980($t5)
		sw $s3, 10984($t5)
		sw $s3, 10988($t5)
		#
		sw $s3, 8952($t5)
		sw $s3, 8956($t5)
		sw $s3, 8960($t5)
		sw $s3, 8964($t5)
		sw $s3, 9464($t5)
		sw $s3, 9976($t5)
		sw $s3, 9980($t5)
		sw $s3, 9984($t5)
		sw $s3, 10488($t5) 
		sw $s3, 11000($t5)
		sw $s3, 11004($t5)
		sw $s3, 11008($t5)
		sw $s3, 11012($t5)
		##### Item menu
		sw $s3, 12836($t5)
		sw $s3, 12840($t5)
		sw $s3, 12844($t5)
		sw $s3, 12848($t5)
		sw $s3, 13360($t5)
		sw $s3, 13864($t5)
		sw $s3, 13868($t5)
		sw $s3, 13872($t5)
		sw $s3, 14384($t5) 
		sw $s3, 14884($t5)
		sw $s3, 14888($t5)
		sw $s3, 14892($t5)
		sw $s3, 14896($t5)
		#
		sw $s3, 13884($t5)
		sw $s3, 13888($t5)
		#
		sw $s3, 12880($t5)
		sw $s3, 12884($t5)
		sw $s3, 12888($t5)
		sw $s3, 13396($t5)
		sw $s3, 13908($t5)
		sw $s3, 14420($t5)
		sw $s3, 14928($t5)
		sw $s3, 14932($t5)
		sw $s3, 14936($t5)
		#
		sw $s3, 12896($t5)
		sw $s3, 12900($t5)
		sw $s3, 12904($t5)
		sw $s3, 13412($t5)
		sw $s3, 13924($t5)
		sw $s3, 14436($t5)
		sw $s3, 14948($t5)
		#
		sw $s3, 12912($t5)
		sw $s3, 12916($t5)
		sw $s3, 12920($t5)
		sw $s3, 12924($t5)
		sw $s3, 13424($t5)
		sw $s3, 13936($t5)
		sw $s3, 13940($t5)
		sw $s3, 13944($t5)
		sw $s3, 14448($t5) 
		sw $s3, 14960($t5)
		sw $s3, 14964($t5)
		sw $s3, 14968($t5)
		sw $s3, 14972($t5)
		#
		sw $s3, 12932($t5)
		sw $s3, 12948($t5)
		sw $s3, 13444($t5)
		sw $s3, 13448($t5)
		sw $s3, 13456($t5)
		sw $s3, 13460($t5)
		sw $s3, 13956($t5)
		sw $s3, 13964($t5)
		sw $s3, 13972($t5) 
		sw $s3, 14468($t5)
		sw $s3, 14484($t5)
		sw $s3, 14980($t5)
		sw $s3, 14996($t5)
		#
		sw $s3, 12964($t5)
		sw $s3, 12980($t5)
		sw $s3, 13476($t5)
		sw $s3, 13480($t5)
		sw $s3, 13488($t5)
		sw $s3, 13492($t5)
		sw $s3, 13988($t5)
		sw $s3, 13996($t5)
		sw $s3, 14004($t5) 
		sw $s3, 14500($t5)
		sw $s3, 14516($t5)
		sw $s3, 15012($t5)
		sw $s3, 15028($t5)
		#
		sw $s3, 12988($t5)
		sw $s3, 12992($t5)
		sw $s3, 12996($t5)
		sw $s3, 13000($t5)
		sw $s3, 13500($t5)
		sw $s3, 14012($t5)
		sw $s3, 14016($t5)
		sw $s3, 14020($t5)
		sw $s3, 14524($t5) 
		sw $s3, 15036($t5)
		sw $s3, 15040($t5)
		sw $s3, 15044($t5)
		sw $s3, 15048($t5)
		#
		sw $s3, 13008($t5)
		sw $s3, 13024($t5)
		sw $s3, 13520($t5)
		sw $s3, 13524($t5)
		sw $s3, 13536($t5)
		sw $s3, 14032($t5)
		sw $s3, 14040($t5)
		sw $s3, 14048($t5)
		sw $s3, 14544($t5) 
		sw $s3, 14556($t5)
		sw $s3, 14560($t5)
		sw $s3, 15056($t5)
		sw $s3, 15072($t5)
		#
		sw $s3, 13032($t5)
		sw $s3, 13044($t5)
		sw $s3, 13544($t5)
		sw $s3, 13556($t5)
		sw $s3, 14056($t5)
		sw $s3, 14068($t5)
		sw $s3, 14568($t5)
		sw $s3, 14580($t5)
		sw $s3, 15080($t5) 
		sw $s3, 15084($t5)
		sw $s3, 15088($t5)
		sw $s3, 15092($t5)
		##### x - select
		sw $s3, 18980($t5)
		sw $s3, 18996($t5)
		sw $s3, 19496($t5)
		sw $s3, 19504($t5)
		sw $s3, 20012($t5)
		sw $s3, 20520($t5)
		sw $s3, 20528($t5)
		sw $s3, 21028($t5)
		sw $s3, 21044($t5)
		#
		sw $s3, 20028($t5)
		sw $s3, 20032($t5)
		#
		sw $s3, 19024($t5)
		sw $s3, 19028($t5)
		sw $s3, 19032($t5)
		sw $s3, 19036($t5)
		sw $s3, 19536($t5)
		sw $s3, 20048($t5)
		sw $s3, 20052($t5)
		sw $s3, 20056($t5)
		sw $s3, 20060($t5) 
		sw $s3, 20572($t5)
		sw $s3, 21072($t5)
		sw $s3, 21076($t5)
		sw $s3, 21080($t5)
		sw $s3, 21084($t5)
		#
		sw $s3, 19044($t5)
		sw $s3, 19048($t5)
		sw $s3, 19052($t5)
		sw $s3, 19056($t5)
		sw $s3, 19556($t5)
		sw $s3, 20068($t5)
		sw $s3, 20072($t5)
		sw $s3, 20076($t5)
		sw $s3, 20580($t5) 
		sw $s3, 21092($t5)
		sw $s3, 21096($t5)
		sw $s3, 21100($t5)
		sw $s3, 21104($t5)
		#
		sw $s3, 19064($t5)
		sw $s3, 19576($t5)
		sw $s3, 20088($t5)
		sw $s3, 20600($t5)
		sw $s3, 21112($t5)
		sw $s3, 21116($t5)
		sw $s3, 21120($t5)
		sw $s3, 21124($t5)
		#
		sw $s3, 19084($t5)
		sw $s3, 19088($t5)
		sw $s3, 19092($t5)
		sw $s3, 19096($t5)
		sw $s3, 19596($t5)
		sw $s3, 20108($t5)
		sw $s3, 20112($t5)
		sw $s3, 20116($t5)
		sw $s3, 20620($t5) 
		sw $s3, 21132($t5)
		sw $s3, 21136($t5)
		sw $s3, 21140($t5)
		sw $s3, 21144($t5)
		#
		sw $s3, 19104($t5)
		sw $s3, 19108($t5)
		sw $s3, 19112($t5)
		sw $s3, 19116($t5)
		sw $s3, 19616($t5)
		sw $s3, 20128($t5)
		sw $s3, 20640($t5)
		sw $s3, 21152($t5)
		sw $s3, 21156($t5) 
		sw $s3, 21160($t5)
		sw $s3, 21164($t5)
		#
		sw $s3, 19124($t5)
		sw $s3, 19128($t5)
		sw $s3, 19132($t5)
		sw $s3, 19640($t5)
		sw $s3, 20152($t5)
		sw $s3, 20664($t5)
		sw $s3, 21176($t5)
		##### z - back
		sw $s3, 23076($t5)
		sw $s3, 23080($t5)
		sw $s3, 23084($t5)
		sw $s3, 23088($t5)
		sw $s3, 23596($t5)
		sw $s3, 24104($t5)
		sw $s3, 24612($t5)
		sw $s3, 25124($t5)
		sw $s3, 25128($t5) 
		sw $s3, 25132($t5)
		sw $s3, 25136($t5) 
		#
		sw $s3, 23612($t5)
		sw $s3, 23616($t5)
		#
		sw $s3, 23120($t5)
		sw $s3, 23632($t5)
		sw $s3, 23644($t5)
		sw $s3, 24144($t5)
		sw $s3, 24148($t5)
		sw $s3, 24152($t5)
		sw $s3, 24656($t5)
		sw $s3, 24668($t5)
		sw $s3, 23124($t5) 
		sw $s3, 23128($t5)
		sw $s3, 23132($t5)
		sw $s3, 25168($t5)
		sw $s3, 25172($t5)
		sw $s3, 25176($t5)
		sw $s3, 25180($t5)
		#
		sw $s3, 23144($t5)
		sw $s3, 23148($t5)
		sw $s3, 23152($t5)
		sw $s3, 23652($t5)
		sw $s3, 23664($t5)
		sw $s3, 24164($t5)
		sw $s3, 24168($t5)
		sw $s3, 24172($t5)
		sw $s3, 24176($t5) 
		sw $s3, 24676($t5)
		sw $s3, 24688($t5)
		sw $s3, 25188($t5)
		sw $s3, 25200($t5)
		#
		sw $s3, 23160($t5)
		sw $s3, 23164($t5)
		sw $s3, 23168($t5)
		sw $s3, 23172($t5)
		sw $s3, 23672($t5)
		sw $s3, 24184($t5)
		sw $s3, 24696($t5)
		sw $s3, 25208($t5)
		sw $s3, 25212($t5) 
		sw $s3, 25216($t5)
		sw $s3, 25220($t5)
		#
		sw $s3, 23180($t5)
		sw $s3, 23192($t5)
		sw $s3, 23692($t5)
		sw $s3, 23700($t5)
		sw $s3, 24204($t5)
		sw $s3, 24208($t5)
		sw $s3, 24716($t5)
		sw $s3, 24724($t5)
		sw $s3, 25228($t5) 
		sw $s3, 25240($t5)
		##### Caps off
		sw $s3, 33316($t5)
		sw $s3, 33320($t5)
		sw $s3, 33324($t5)
		sw $s3, 33328($t5)
		sw $s3, 33828($t5)
		sw $s3, 34340($t5)
		sw $s3, 34852($t5)
		sw $s3, 35364($t5)
		sw $s3, 35368($t5) 
		sw $s3, 35372($t5)
		sw $s3, 35376($t5)
		#
		sw $s3, 33340($t5)
		sw $s3, 33344($t5)
		sw $s3, 33348($t5)
		sw $s3, 33848($t5)
		sw $s3, 33860($t5)
		sw $s3, 34360($t5)
		sw $s3, 34364($t5)
		sw $s3, 34368($t5)
		sw $s3, 34372($t5) 
		sw $s3, 34872($t5)
		sw $s3, 34884($t5)
		sw $s3, 35384($t5)
		sw $s3, 35396($t5)
		#
		sw $s3, 33356($t5)
		sw $s3, 33360($t5)
		sw $s3, 33364($t5)
		sw $s3, 33368($t5)
		sw $s3, 33868($t5)
		sw $s3, 33880($t5)
		sw $s3, 34380($t5)
		sw $s3, 34384($t5)
		sw $s3, 34388($t5) 
		sw $s3, 34392($t5)
		sw $s3, 34892($t5)
		sw $s3, 35404($t5)
		#
		sw $s3, 33376($t5)
		sw $s3, 33380($t5)
		sw $s3, 33384($t5)
		sw $s3, 33388($t5)
		sw $s3, 33888($t5)
		sw $s3, 34400($t5)
		sw $s3, 34404($t5)
		sw $s3, 34408($t5)
		sw $s3, 34412($t5) 
		sw $s3, 34924($t5)
		sw $s3, 35424($t5)
		sw $s3, 35428($t5)
		sw $s3, 35432($t5)
		sw $s3, 35436($t5)
		#
		sw $s3, 33404($t5)
		sw $s3, 33408($t5)
		sw $s3, 33412($t5)
		sw $s3, 33416($t5)
		sw $s3, 33916($t5)
		sw $s3, 33928($t5)
		sw $s3, 34428($t5)
		sw $s3, 34440($t5)
		sw $s3, 34940($t5) 
		sw $s3, 34952($t5)
		sw $s3, 35452($t5)
		sw $s3, 35456($t5)
		sw $s3, 35460($t5)
		sw $s3, 35464($t5)
		#
		sw $s3, 33424($t5)
		sw $s3, 33428($t5)
		sw $s3, 33432($t5)
		sw $s3, 33436($t5)
		sw $s3, 33936($t5)
		sw $s3, 34448($t5)
		sw $s3, 34452($t5)
		sw $s3, 34456($t5)
		sw $s3, 34960($t5) 
		sw $s3, 35472($t5)
		#
		sw $s3, 33444($t5)
		sw $s3, 33448($t5)
		sw $s3, 33452($t5)
		sw $s3, 33456($t5)
		sw $s3, 33956($t5)
		sw $s3, 34468($t5)
		sw $s3, 34472($t5)
		sw $s3, 34476($t5)
		sw $s3, 34980($t5) 
		sw $s3, 35492($t5)
		#### x to start
		sw $s3, 58404($t5)
		sw $s3, 58420($t5)
		sw $s3, 58920($t5)
		sw $s3, 58928($t5)
		sw $s3, 59436($t5)
		sw $s3, 59944($t5)
		sw $s3, 59952($t5)
		sw $s3, 60452($t5)
		sw $s3, 60468($t5)
		#
		sw $s3, 58436($t5)
		sw $s3, 58440($t5)
		sw $s3, 58444($t5)
		sw $s3, 58952($t5)
		sw $s3, 59464($t5)
		sw $s3, 59976($t5)
		sw $s3, 60488($t5)
		#
		sw $s3, 58452($t5)
		sw $s3, 58456($t5)
		sw $s3, 58460($t5)
		sw $s3, 58464($t5)
		sw $s3, 58964($t5)
		sw $s3, 58976($t5)
		sw $s3, 59476($t5)
		sw $s3, 59488($t5)
		sw $s3, 59988($t5) 
		sw $s3, 60000($t5)
		sw $s3, 60500($t5)
		sw $s3, 60504($t5)
		sw $s3, 60508($t5)
		sw $s3, 60512($t5)
		#
		sw $s3, 58480($t5)
		sw $s3, 58484($t5)
		sw $s3, 58488($t5)
		sw $s3, 58492($t5)
		sw $s3, 58992($t5)
		sw $s3, 59504($t5)
		sw $s3, 59508($t5)
		sw $s3, 59512($t5)
		sw $s3, 59516($t5) 
		sw $s3, 60028($t5)
		sw $s3, 60528($t5)
		sw $s3, 60532($t5)
		sw $s3, 60536($t5)
		sw $s3, 60540($t5)
		#
		sw $s3, 58500($t5)
		sw $s3, 58504($t5)
		sw $s3, 58508($t5)
		sw $s3, 59016($t5)
		sw $s3, 59528($t5)
		sw $s3, 59988($t5) 
		sw $s3, 60040($t5)
		sw $s3, 60552($t5)
		#
		sw $s3, 58520($t5)
		sw $s3, 58524($t5)
		sw $s3, 58528($t5)
		sw $s3, 59028($t5)
		sw $s3, 59040($t5)
		sw $s3, 59540($t5)
		sw $s3, 59544($t5)
		sw $s3, 59548($t5)
		sw $s3, 59552($t5) 
		sw $s3, 60052($t5)
		sw $s3, 60064($t5)
		sw $s3, 60564($t5)
		sw $s3, 60576($t5)
		#
		sw $s3, 58536($t5)
		sw $s3, 58540($t5)
		sw $s3, 58544($t5)
		sw $s3, 58548($t5)
		sw $s3, 59048($t5)
		sw $s3, 59060($t5)
		sw $s3, 59560($t5)
		sw $s3, 59564($t5)
		sw $s3, 59568($t5) 
		sw $s3, 59572($t5)
		sw $s3, 60072($t5)
		sw $s3, 60080($t5)
		sw $s3, 60584($t5)
		sw $s3, 60596($t5)
		#
		sw $s3, 58556($t5)
		sw $s3, 58560($t5)
		sw $s3, 58564($t5)
		sw $s3, 59072($t5)
		sw $s3, 59584($t5)
		sw $s3, 60096($t5)
		sw $s3, 60608($t5)
	
		jr $ra
		nop
		
	gameOver:
		sw $s3, 37004($t5)
		sw $s3, 37008($t5)
		sw $s3, 37012($t5)
		sw $s3, 37016($t5)
		sw $s3, 37020($t5)
		sw $s3, 37024($t5)
		sw $s3, 37516($t5)
		sw $s3, 37520($t5)
		sw $s3, 37524($t5)
		sw $s3, 37528($t5)
		sw $s3, 37532($t5)
		sw $s3, 37536($t5)
		#
		sw $s3, 37064($t5)
		sw $s3, 37068($t5)
		sw $s3, 37072($t5)
		sw $s3, 37076($t5)
		sw $s3, 37080($t5)
		sw $s3, 37084($t5)
		sw $s3, 37576($t5)
		sw $s3, 37580($t5)
		sw $s3, 37584($t5)
		sw $s3, 37588($t5)
		sw $s3, 37592($t5)
		sw $s3, 37596($t5)
		#
		sw $s3, 37108($t5)
		sw $s3, 37112($t5)
		sw $s3, 37116($t5)
		sw $s3, 37120($t5)
		sw $s3, 37124($t5)
		sw $s3, 37128($t5)
		sw $s3, 37132($t5)
		sw $s3, 37136($t5)
		sw $s3, 37140($t5)
		sw $s3, 37144($t5)
		sw $s3, 37148($t5)
		sw $s3, 37152($t5)
		sw $s3, 37156($t5)
		sw $s3, 37160($t5)
		sw $s3, 37164($t5)
		sw $s3, 37168($t5)
		sw $s3, 37620($t5)
		sw $s3, 37624($t5)
		sw $s3, 37628($t5)
		sw $s3, 37632($t5)
		sw $s3, 37636($t5)
		sw $s3, 37640($t5)
		sw $s3, 37644($t5)
		sw $s3, 37648($t5)
		sw $s3, 37652($t5)
		sw $s3, 37656($t5)
		sw $s3, 37660($t5)
		sw $s3, 37664($t5)
		sw $s3, 37668($t5)
		sw $s3, 37672($t5)
		sw $s3, 37676($t5)
		sw $s3, 37680($t5)
		#
		sw $s3, 37208($t5)
		sw $s3, 37212($t5)
		sw $s3, 37216($t5)
		sw $s3, 37220($t5)
		sw $s3, 37224($t5)
		sw $s3, 37228($t5)
		sw $s3, 37232($t5)
		sw $s3, 37236($t5)
		sw $s3, 37720($t5)
		sw $s3, 37724($t5)
		sw $s3, 37728($t5)
		sw $s3, 37732($t5)
		sw $s3, 37736($t5)
		sw $s3, 37740($t5)
		sw $s3, 37744($t5)
		sw $s3, 37748($t5)
		##
		sw $s3, 38020($t5)
		sw $s3, 38024($t5)
		sw $s3, 38532($t5)
		sw $s3, 38536($t5)
		#
		sw $s3, 38080($t5)
		sw $s3, 38084($t5)
		sw $s3, 38088($t5)
		sw $s3, 38092($t5)
		sw $s3, 38096($t5)
		sw $s3, 38100($t5)
		sw $s3, 38104($t5)
		sw $s3, 38108($t5)
		sw $s3, 38592($t5)
		sw $s3, 38596($t5)
		sw $s3, 38600($t5)
		sw $s3, 38604($t5)
		sw $s3, 38608($t5)
		sw $s3, 38612($t5)
		sw $s3, 38616($t5)
		sw $s3, 38620($t5)
		#
		sw $s3, 38132($t5)
		sw $s3, 38136($t5)
		sw $s3, 38140($t5)
		sw $s3, 38144($t5)
		sw $s3, 38148($t5)
		sw $s3, 38152($t5)
		sw $s3, 38156($t5)
		sw $s3, 38160($t5)
		sw $s3, 38164($t5)
		sw $s3, 38168($t5)
		sw $s3, 38172($t5)
		sw $s3, 38176($t5)
		sw $s3, 38180($t5)
		sw $s3, 38184($t5)
		sw $s3, 38188($t5)
		sw $s3, 38192($t5)
		sw $s3, 38196($t5)
		sw $s3, 38200($t5)
		sw $s3, 38644($t5)
		sw $s3, 38648($t5)
		sw $s3, 38652($t5)
		sw $s3, 38656($t5)
		sw $s3, 38660($t5)
		sw $s3, 38664($t5)
		sw $s3, 38668($t5)
		sw $s3, 38672($t5)
		sw $s3, 38676($t5)
		sw $s3, 38680($t5)
		sw $s3, 38684($t5)
		sw $s3, 38688($t5)
		sw $s3, 38692($t5)
		sw $s3, 38696($t5)
		sw $s3, 38700($t5)
		sw $s3, 38704($t5)
		sw $s3, 38708($t5)
		sw $s3, 38712($t5)
		#
		sw $s3, 38224($t5)
		sw $s3, 38228($t5)
		sw $s3, 38232($t5)
		sw $s3, 38236($t5)
		sw $s3, 38736($t5)
		sw $s3, 38740($t5)
		sw $s3, 38744($t5)
		sw $s3, 38748($t5)
		#
		sw $s3, 39044($t5)
		sw $s3, 39048($t5)
		sw $s3, 39060($t5)
		sw $s3, 39064($t5)
		sw $s3, 39068($t5)
		sw $s3, 39072($t5)
		sw $s3, 39076($t5)
		sw $s3, 39080($t5)
		sw $s3, 39556($t5)
		sw $s3, 39560($t5)
		sw $s3, 39572($t5)
		sw $s3, 39576($t5)
		sw $s3, 39580($t5)
		sw $s3, 39584($t5)
		sw $s3, 39588($t5)
		sw $s3, 39592($t5)
		#
		sw $s3, 39104($t5)
		sw $s3, 39108($t5)
		sw $s3, 39112($t5)
		sw $s3, 39116($t5)
		sw $s3, 39616($t5)
		sw $s3, 39620($t5)
		sw $s3, 39624($t5)
		sw $s3, 39628($t5)
		#
		sw $s3, 39156($t5)
		sw $s3, 39160($t5)
		sw $s3, 39164($t5)
		sw $s3, 39168($t5)
		sw $s3, 39188($t5)
		sw $s3, 39192($t5)
		sw $s3, 39212($t5)
		sw $s3, 39216($t5)
		sw $s3, 39220($t5)
		sw $s3, 39224($t5)
		sw $s3, 39668($t5)
		sw $s3, 39672($t5)
		sw $s3, 39676($t5)
		sw $s3, 39680($t5)
		sw $s3, 39700($t5)
		sw $s3, 39704($t5)
		sw $s3, 39724($t5)
		sw $s3, 39728($t5)
		sw $s3, 39732($t5)
		sw $s3, 39736($t5)
		#
		sw $s3, 39248($t5)
		sw $s3, 39252($t5)
		sw $s3, 39256($t5)
		sw $s3, 39260($t5)
		sw $s3, 39760($t5)
		sw $s3, 39764($t5)
		sw $s3, 39768($t5)
		sw $s3, 39772($t5)
		sw $s3, 39776($t5)
		sw $s3, 39780($t5)
		sw $s3, 39784($t5)
		sw $s3, 39788($t5)
		sw $s3, 39792($t5)
		sw $s3, 39796($t5)
		#
		sw $s3, 40068($t5)
		sw $s3, 40072($t5)
		sw $s3, 40092($t5)
		sw $s3, 40096($t5)
		sw $s3, 40100($t5)
		sw $s3, 40104($t5)
		sw $s3, 40580($t5)
		sw $s3, 40584($t5)
		sw $s3, 40604($t5)
		sw $s3, 40608($t5)
		sw $s3, 40612($t5)
		sw $s3, 40616($t5)
		#
		sw $s3, 40128($t5)
		sw $s3, 40132($t5)
		sw $s3, 40136($t5)
		sw $s3, 40140($t5)
		sw $s3, 40152($t5)
		sw $s3, 40156($t5)
		sw $s3, 40640($t5)
		sw $s3, 40644($t5)
		sw $s3, 40648($t5)
		sw $s3, 40652($t5)
		sw $s3, 40656($t5)
		sw $s3, 40660($t5)
		#
		sw $s3, 40180($t5)
		sw $s3, 40184($t5)
		sw $s3, 40188($t5)
		sw $s3, 40192($t5)
		sw $s3, 40212($t5)
		sw $s3, 40216($t5)
		sw $s3, 40236($t5)
		sw $s3, 40240($t5)
		sw $s3, 40244($t5)
		sw $s3, 40248($t5)
		sw $s3, 40692($t5)
		sw $s3, 40696($t5)
		sw $s3, 40700($t5)
		sw $s3, 40704($t5)
		sw $s3, 40724($t5)
		sw $s3, 40728($t5)
		sw $s3, 40748($t5)
		sw $s3, 40752($t5)
		sw $s3, 40756($t5)
		sw $s3, 40760($t5)
		#
		sw $s3, 40272($t5)
		sw $s3, 40276($t5)
		sw $s3, 40280($t5)
		sw $s3, 40284($t5)
		sw $s3, 40288($t5)
		sw $s3, 40292($t5)
		sw $s3, 40296($t5)
		sw $s3, 40300($t5)
		sw $s3, 40304($t5)
		sw $s3, 40308($t5)
		sw $s3, 40784($t5)
		sw $s3, 40788($t5)
		sw $s3, 40792($t5)
		sw $s3, 40796($t5)
		##
		sw $s3, 41092($t5)
		sw $s3, 41096($t5)
		sw $s3, 41100($t5)
		sw $s3, 41104($t5)
		sw $s3, 41108($t5)
		sw $s3, 41112($t5)
		sw $s3, 41116($t5)
		sw $s3, 41120($t5)
		sw $s3, 41124($t5)
		sw $s3, 41128($t5)
		sw $s3, 41604($t5)
		sw $s3, 41608($t5)
		sw $s3, 41612($t5)
		sw $s3, 41616($t5)
		sw $s3, 41620($t5)
		sw $s3, 41624($t5)
		sw $s3, 41632($t5)
		sw $s3, 41636($t5)
		sw $s3, 41640($t5)
		sw $s3, 41644($t5)
		#
		sw $s3, 41152($t5)
		sw $s3, 41156($t5)
		sw $s3, 41160($t5)
		sw $s3, 41164($t5)
		sw $s3, 41168($t5)
		sw $s3, 41172($t5)
		sw $s3, 41176($t5)
		sw $s3, 41180($t5)
		sw $s3, 41664($t5)
		sw $s3, 41668($t5)
		sw $s3, 41672($t5)
		sw $s3, 41676($t5)
		sw $s3, 41680($t5)
		sw $s3, 41684($t5)
		sw $s3, 41688($t5)
		sw $s3, 41692($t5)
		#
		sw $s3, 41204($t5)
		sw $s3, 41208($t5)
		sw $s3, 41212($t5)
		sw $s3, 41216($t5)
		sw $s3, 41236($t5)
		sw $s3, 41240($t5)
		sw $s3, 41260($t5)
		sw $s3, 41264($t5)
		sw $s3, 41268($t5)
		sw $s3, 41272($t5)
		sw $s3, 41716($t5)
		sw $s3, 41720($t5)
		sw $s3, 41724($t5)
		sw $s3, 41728($t5)
		sw $s3, 41748($t5)
		sw $s3, 41752($t5)
		sw $s3, 41772($t5)
		sw $s3, 41776($t5)
		sw $s3, 41780($t5)
		sw $s3, 41784($t5)
		#
		sw $s3, 41296($t5)
		sw $s3, 41300($t5)
		sw $s3, 41304($t5)
		sw $s3, 41308($t5)
		sw $s3, 41808($t5)
		sw $s3, 41812($t5)
		sw $s3, 41816($t5)
		sw $s3, 41820($t5)
		##
		sw $s3, 42124($t5)
		sw $s3, 42128($t5)
		sw $s3, 42132($t5)
		sw $s3, 42136($t5)
		sw $s3, 42140($t5)
		sw $s3, 42144($t5)
		sw $s3, 42148($t5)
		sw $s3, 42152($t5)
		sw $s3, 42636($t5)
		sw $s3, 42640($t5)
		sw $s3, 42644($t5)
		sw $s3, 42648($t5)
		sw $s3, 42652($t5)
		sw $s3, 42656($t5)
		sw $s3, 42660($t5)
		sw $s3, 42664($t5)
		#
		sw $s3, 42176($t5)
		sw $s3, 42180($t5)
		sw $s3, 42184($t5)
		sw $s3, 42188($t5)
		sw $s3, 42200($t5)
		sw $s3, 42204($t5)
		sw $s3, 42712($t5)
		sw $s3, 42688($t5)
		sw $s3, 42692($t5)
		sw $s3, 42696($t5)
		sw $s3, 42700($t5)
		sw $s3, 42716($t5)
		#
		sw $s3, 42228($t5)
		sw $s3, 42232($t5)
		sw $s3, 42236($t5)
		sw $s3, 42240($t5)
		sw $s3, 42260($t5)
		sw $s3, 42264($t5)
		sw $s3, 42284($t5)
		sw $s3, 42288($t5)
		sw $s3, 42292($t5)
		sw $s3, 42296($t5)
		sw $s3, 42740($t5)
		sw $s3, 42744($t5)
		sw $s3, 42748($t5)
		sw $s3, 42752($t5)
		sw $s3, 42772($t5)
		sw $s3, 42776($t5)
		sw $s3, 42796($t5)
		sw $s3, 42800($t5)
		sw $s3, 42804($t5)
		sw $s3, 42808($t5)
		#
		sw $s3, 42328($t5)
		sw $s3, 42332($t5)
		sw $s3, 42336($t5)
		sw $s3, 42340($t5)
		sw $s3, 42344($t5)
		sw $s3, 42348($t5)
		sw $s3, 42352($t5)
		sw $s3, 42356($t5)
		sw $s3, 42840($t5)
		sw $s3, 42844($t5)
		sw $s3, 42848($t5)
		sw $s3, 42852($t5)
		sw $s3, 42856($t5)
		sw $s3, 42860($t5)
		sw $s3, 42864($t5)
		sw $s3, 42868($t5)
		
		#########
		
		sw $s3, 45716($t5)
		sw $s3, 45720($t5)
		sw $s3, 45724($t5)
		sw $s3, 45728($t5)
		sw $s3, 45732($t5)
		sw $s3, 45736($t5)
		sw $s3, 46228($t5)
		sw $s3, 46232($t5)
		sw $s3, 46236($t5)
		sw $s3, 46240($t5)
		sw $s3, 46244($t5)
		sw $s3, 46248($t5)
		#
		sw $s3, 45768($t5)
		sw $s3, 45772($t5)
		sw $s3, 45776($t5)
		sw $s3, 45780($t5)
		sw $s3, 45792($t5)
		sw $s3, 45796($t5)
		sw $s3, 45800($t5)
		sw $s3, 45804($t5)
		sw $s3, 46280($t5)
		sw $s3, 46284($t5)
		sw $s3, 46288($t5)
		sw $s3, 46292($t5)
		sw $s3, 46304($t5)
		sw $s3, 46308($t5)
		sw $s3, 46312($t5)
		sw $s3, 46316($t5)
		#
		sw $s3, 45836($t5)
		sw $s3, 45840($t5)
		sw $s3, 45844($t5)
		sw $s3, 45848($t5)
		sw $s3, 45852($t5)
		sw $s3, 45856($t5)
		sw $s3, 45860($t5)
		sw $s3, 45864($t5)
		sw $s3, 46348($t5)
		sw $s3, 46352($t5)
		sw $s3, 46356($t5)
		sw $s3, 46360($t5)
		sw $s3, 46364($t5)
		sw $s3, 46368($t5)
		sw $s3, 46372($t5)
		sw $s3, 46376($t5)
		#
		sw $s3, 45888($t5)
		sw $s3, 45892($t5)
		sw $s3, 45896($t5)
		sw $s3, 45900($t5)
		sw $s3, 45904($t5)
		sw $s3, 45908($t5)
		sw $s3, 45912($t5)
		sw $s3, 45916($t5)
		sw $s3, 45920($t5)
		sw $s3, 45924($t5)
		sw $s3, 46400($t5)
		sw $s3, 46404($t5)
		sw $s3, 46408($t5)
		sw $s3, 46412($t5)
		sw $s3, 46416($t5)
		sw $s3, 46420($t5)
		sw $s3, 46424($t5)
		sw $s3, 46428($t5)
		sw $s3, 46432($t5)
		sw $s3, 46436($t5)
		##
		sw $s3, 46732($t5)
		sw $s3, 46736($t5)
		sw $s3, 46740($t5)
		sw $s3, 46744($t5)
		sw $s3, 46764($t5)
		sw $s3, 46768($t5)
		sw $s3, 47244($t5)
		sw $s3, 47248($t5)
		sw $s3, 47252($t5)
		sw $s3, 47256($t5)
		sw $s3, 47276($t5)
		sw $s3, 47280($t5)
		#
		sw $s3, 46792($t5)
		sw $s3, 46796($t5)
		sw $s3, 46800($t5)
		sw $s3, 46804($t5)
		sw $s3, 46816($t5)
		sw $s3, 46820($t5)
		sw $s3, 46824($t5)
		sw $s3, 46828($t5)
		sw $s3, 47304($t5)
		sw $s3, 47308($t5)
		sw $s3, 47312($t5)
		sw $s3, 47316($t5)
		sw $s3, 47328($t5)
		sw $s3, 47332($t5)
		sw $s3, 47336($t5)
		sw $s3, 47340($t5)
		#
		sw $s3, 46852($t5)
		sw $s3, 46856($t5)
		sw $s3, 46860($t5)
		sw $s3, 46864($t5)
		sw $s3, 47364($t5)
		sw $s3, 47368($t5)
		sw $s3, 47372($t5)
		sw $s3, 47376($t5)
		#
		sw $s3, 46912($t5)
		sw $s3, 46916($t5)
		sw $s3, 46920($t5)
		sw $s3, 46924($t5)
		sw $s3, 46928($t5)
		sw $s3, 46932($t5)
		sw $s3, 46936($t5)
		sw $s3, 46940($t5)
		sw $s3, 46944($t5)
		sw $s3, 46948($t5)
		sw $s3, 46952($t5)
		sw $s3, 46956($t5)
		sw $s3, 47424($t5)
		sw $s3, 47428($t5)
		sw $s3, 47432($t5)
		sw $s3, 47436($t5)
		sw $s3, 47440($t5)
		sw $s3, 47444($t5)
		sw $s3, 47448($t5)
		sw $s3, 47452($t5)
		sw $s3, 47456($t5)
		sw $s3, 47460($t5)
		sw $s3, 47464($t5)
		sw $s3, 47468($t5)
		#
		sw $s3, 47756($t5)
		sw $s3, 47760($t5)
		sw $s3, 47764($t5)
		sw $s3, 47768($t5)
		sw $s3, 47788($t5)
		sw $s3, 47792($t5)
		sw $s3, 48268($t5)
		sw $s3, 48272($t5)
		sw $s3, 48276($t5)
		sw $s3, 48280($t5)
		sw $s3, 48300($t5)
		sw $s3, 48304($t5)
		#
		sw $s3, 47816($t5)
		sw $s3, 47820($t5)
		sw $s3, 47824($t5)
		sw $s3, 47828($t5)
		sw $s3, 47840($t5)
		sw $s3, 47844($t5)
		sw $s3, 47848($t5)
		sw $s3, 47852($t5)
		sw $s3, 48328($t5)
		sw $s3, 48332($t5)
		sw $s3, 48336($t5)
		sw $s3, 48340($t5)
		sw $s3, 48352($t5)
		sw $s3, 48356($t5)
		sw $s3, 48360($t5)
		sw $s3, 48364($t5)
		#
		sw $s3, 47876($t5)
		sw $s3, 47880($t5)
		sw $s3, 47884($t5)
		sw $s3, 47888($t5)
		sw $s3, 48388($t5)
		sw $s3, 48392($t5)
		sw $s3, 48396($t5)
		sw $s3, 48400($t5)
		#
		sw $s3, 47936($t5)
		sw $s3, 47940($t5)
		sw $s3, 47944($t5)
		sw $s3, 47948($t5)
		sw $s3, 47968($t5)
		sw $s3, 47972($t5)
		sw $s3, 47976($t5)
		sw $s3, 47980($t5)
		sw $s3, 48448($t5)
		sw $s3, 48452($t5)
		sw $s3, 48456($t5)
		sw $s3, 48460($t5)
		sw $s3, 48480($t5)
		sw $s3, 48484($t5)
		sw $s3, 48488($t5)
		sw $s3, 48492($t5)
		##
		sw $s3, 48780($t5)
		sw $s3, 48784($t5)
		sw $s3, 48792($t5)
		sw $s3, 48796($t5)
		sw $s3, 48812($t5)
		sw $s3, 48816($t5)
		sw $s3, 49804($t5)
		sw $s3, 49808($t5)
		sw $s3, 49812($t5)
		sw $s3, 49816($t5)
		sw $s3, 49324($t5)
		sw $s3, 49328($t5)
		#
		sw $s3, 48840($t5)
		sw $s3, 48844($t5)
		sw $s3, 48848($t5)
		sw $s3, 48852($t5)
		sw $s3, 48864($t5)
		sw $s3, 48868($t5)
		sw $s3, 48872($t5)
		sw $s3, 48876($t5)
		sw $s3, 49352($t5)
		sw $s3, 49356($t5)
		sw $s3, 49360($t5)
		sw $s3, 49364($t5)
		sw $s3, 49376($t5)
		sw $s3, 49380($t5)
		sw $s3, 49384($t5)
		sw $s3, 49388($t5)
		#
		sw $s3, 48900($t5)
		sw $s3, 48904($t5)
		sw $s3, 48908($t5)
		sw $s3, 48912($t5)
		sw $s3, 48916($t5)
		sw $s3, 48920($t5)
		sw $s3, 48924($t5)
		sw $s3, 48928($t5)
		sw $s3, 48932($t5)
		sw $s3, 48936($t5)
		sw $s3, 49412($t5)
		sw $s3, 49416($t5)
		sw $s3, 49420($t5)
		sw $s3, 49424($t5)
		sw $s3, 49428($t5)
		sw $s3, 49432($t5)
		sw $s3, 49436($t5)
		sw $s3, 49440($t5)
		sw $s3, 49444($t5)
		sw $s3, 49448($t5)
		#
		sw $s3, 48960($t5)
		sw $s3, 48964($t5)
		sw $s3, 48968($t5)
		sw $s3, 48972($t5)
		sw $s3, 48976($t5)
		sw $s3, 48980($t5)
		sw $s3, 48984($t5)
		sw $s3, 48988($t5)
		sw $s3, 48992($t5)
		sw $s3, 48996($t5)
		sw $s3, 49472($t5)
		sw $s3, 49476($t5)
		sw $s3, 49480($t5)
		sw $s3, 49484($t5)
		sw $s3, 49488($t5)
		sw $s3, 49492($t5)
		sw $s3, 49496($t5)
		sw $s3, 49500($t5)
		sw $s3, 49504($t5)
		sw $s3, 49508($t5)
		##
		sw $s3, 49804($t5)
		sw $s3, 49808($t5)
		sw $s3, 49812($t5)
		sw $s3, 49816($t5)
		sw $s3, 49836($t5)
		sw $s3, 49840($t5)
		sw $s3, 50316($t5)
		sw $s3, 50320($t5)
		sw $s3, 50324($t5)
		sw $s3, 50328($t5)
		sw $s3, 50332($t5)
		sw $s3, 50336($t5)
		#
		sw $s3, 49864($t5)
		sw $s3, 49868($t5)
		sw $s3, 49872($t5)
		sw $s3, 49876($t5)
		sw $s3, 49888($t5)
		sw $s3, 49892($t5)
		sw $s3, 49896($t5)
		sw $s3, 49900($t5)
		sw $s3, 50376($t5)
		sw $s3, 50380($t5)
		sw $s3, 50384($t5)
		sw $s3, 50388($t5)
		sw $s3, 50400($t5)
		sw $s3, 50404($t5)
		sw $s3, 50408($t5)
		sw $s3, 50412($t5)
		#
		sw $s3, 49924($t5)
		sw $s3, 49928($t5)
		sw $s3, 49932($t5)
		sw $s3, 49936($t5)
		sw $s3, 50436($t5)
		sw $s3, 50440($t5)
		sw $s3, 50444($t5)
		sw $s3, 50448($t5)
		#
		sw $s3, 49984($t5)
		sw $s3, 49988($t5)
		sw $s3, 49992($t5)
		sw $s3, 49996($t5)
		sw $s3, 50016($t5)
		sw $s3, 50020($t5)
		sw $s3, 50024($t5)
		sw $s3, 50028($t5)
		sw $s3, 50496($t5)
		sw $s3, 50500($t5)
		sw $s3, 50504($t5)
		sw $s3, 50508($t5)
		sw $s3, 50528($t5)
		sw $s3, 50532($t5)
		sw $s3, 50536($t5)
		sw $s3, 50540($t5)
		##
		sw $s3, 50828($t5)
		sw $s3, 50832($t5)
		sw $s3, 50836($t5)
		sw $s3, 50840($t5)
		sw $s3, 50844($t5)
		sw $s3, 50848($t5)
		sw $s3, 50852($t5)
		sw $s3, 50856($t5)
		sw $s3, 50860($t5)
		sw $s3, 50864($t5)
		#
		sw $s3, 50888($t5)
		sw $s3, 50892($t5)
		sw $s3, 50896($t5)
		sw $s3, 50900($t5)
		sw $s3, 50912($t5)
		sw $s3, 50916($t5)
		sw $s3, 50920($t5)
		sw $s3, 50924($t5)
		#
		sw $s3, 50948($t5)
		sw $s3, 50952($t5)
		sw $s3, 50956($t5)
		sw $s3, 50960($t5)
		#
		sw $s3, 51008($t5)
		sw $s3, 51012($t5)
		sw $s3, 51016($t5)
		sw $s3, 51020($t5)
		sw $s3, 51040($t5)
		sw $s3, 51044($t5)
		sw $s3, 51048($t5)
		sw $s3, 51052($t5)
		##
		sw $s3, 51348($t5)
		sw $s3, 51352($t5)
		sw $s3, 51356($t5)
		sw $s3, 51360($t5)
		sw $s3, 51364($t5)
		sw $s3, 51368($t5)
		sw $s3, 51860($t5)
		sw $s3, 51864($t5)
		sw $s3, 51868($t5)
		sw $s3, 51872($t5)
		sw $s3, 51876($t5)
		sw $s3, 51880($t5)
		#
		sw $s3, 51400($t5)
		sw $s3, 51404($t5)
		sw $s3, 51408($t5)
		sw $s3, 51412($t5)
		sw $s3, 51416($t5)
		sw $s3, 51420($t5)
		sw $s3, 51424($t5)
		sw $s3, 51428($t5)
		sw $s3, 51912($t5)
		sw $s3, 51916($t5)
		sw $s3, 51920($t5)
		sw $s3, 51924($t5)
		sw $s3, 51928($t5)
		sw $s3, 51932($t5)
		sw $s3, 51936($t5)
		sw $s3, 51940($t5)
		#
		sw $s3, 51468($t5)
		sw $s3, 51472($t5)
		sw $s3, 51476($t5)
		sw $s3, 51480($t5)
		sw $s3, 51484($t5)
		sw $s3, 51488($t5)
		sw $s3, 51492($t5)
		sw $s3, 51496($t5)
		sw $s3, 51980($t5)
		sw $s3, 51984($t5)
		sw $s3, 51988($t5)
		sw $s3, 51992($t5)
		sw $s3, 51996($t5)
		sw $s3, 52000($t5)
		sw $s3, 52004($t5)
		sw $s3, 52008($t5)
		#
		sw $s3, 51520($t5)
		sw $s3, 51524($t5)
		sw $s3, 51528($t5)
		sw $s3, 51532($t5)
		sw $s3, 51552($t5)
		sw $s3, 51556($t5)
		sw $s3, 51560($t5)
		sw $s3, 51564($t5)
		sw $s3, 52032($t5)
		sw $s3, 52036($t5)
		sw $s3, 52040($t5)
		sw $s3, 52044($t5)
		sw $s3, 52064($t5)
		sw $s3, 52068($t5)
		sw $s3, 52072($t5)
		sw $s3, 52076($t5)
		
		jr $ra
		nop
		
	msg1: # Are you crazy?
		sw $s3, 36396($t3)
		sw $s3, 36400($t3)
		sw $s3, 36404($t3)
		sw $s3, 36904($t3)
		sw $s3, 36916($t3)
		sw $s3, 37416($t3)
		sw $s3, 37420($t3)
		sw $s3, 37424($t3)
		sw $s3, 37428($t3)
		sw $s3, 37928($t3)
		sw $s3, 37940($t3)
		sw $s3, 38440($t3)
		sw $s3, 38452($t3)
		#
		sw $s3, 36412($t3)
		sw $s3, 36416($t3)
		sw $s3, 36420($t3)
		sw $s3, 36424($t3)
		sw $s3, 36924($t3)
		sw $s3, 36936($t3)
		sw $s3, 37436($t3)
		sw $s3, 37440($t3)
		sw $s3, 37444($t3)
		sw $s3, 37448($t3)
		sw $s3, 37948($t3)
		sw $s3, 37956($t3)
		sw $s3, 38460($t3)
		sw $s3, 38472($t3)
		#
		sw $s3, 36432($t3)
		sw $s3, 36436($t3)
		sw $s3, 36440($t3)
		sw $s3, 36944($t3)
		sw $s3, 37456($t3)
		sw $s3, 37460($t3)
		sw $s3, 37968($t3)
		sw $s3, 38480($t3)
		sw $s3, 38484($t3)
		sw $s3, 38488($t3)
		#
		sw $s3, 36456($t3)
		sw $s3, 36464($t3)
		sw $s3, 36968($t3)
		sw $s3, 36972($t3)
		sw $s3, 36976($t3)
		sw $s3, 37484($t3)
		sw $s3, 37996($t3)
		sw $s3, 37508($t3)
		#
		sw $s3, 36472($t3)
		sw $s3, 36476($t3)
		sw $s3, 36480($t3)
		sw $s3, 36484($t3)
		sw $s3, 36984($t3)
		sw $s3, 36996($t3)
		sw $s3, 37496($t3)
		sw $s3, 37508($t3)
		sw $s3, 38008($t3)
		sw $s3, 38020($t3)
		sw $s3, 38520($t3)
		sw $s3, 38524($t3)
		sw $s3, 38528($t3)
		sw $s3, 38532($t3)
		#
		sw $s3, 36520($t3)
		sw $s3, 36524($t3)
		sw $s3, 36532($t3)
		sw $s3, 36536($t3)
		sw $s3, 37032($t3)
		sw $s3, 37544($t3)
		sw $s3, 38056($t3)
		sw $s3, 38568($t3)
		sw $s3, 38572($t3)
		sw $s3, 38576($t3)
		sw $s3, 38580($t3)
		#
		sw $s3, 36540($t3)
		sw $s3, 36544($t3)
		sw $s3, 36548($t3)
		sw $s3, 36552($t3)
		sw $s3, 37052($t3)
		sw $s3, 37064($t3)
		sw $s3, 37564($t3)
		sw $s3, 37568($t3)
		sw $s3, 37572($t3)
		sw $s3, 37576($t3)
		sw $s3, 38076($t3)
		sw $s3, 38084($t3)
		sw $s3, 38588($t3)
		sw $s3, 38600($t3)
		#
		sw $s3, 36564($t3)
		sw $s3, 36568($t3)
		sw $s3, 36572($t3)
		sw $s3, 37072($t3)
		sw $s3, 37084($t3)
		sw $s3, 37584($t3)
		sw $s3, 37588($t3)
		sw $s3, 37592($t3)
		sw $s3, 37596($t3)
		sw $s3, 38096($t3)
		sw $s3, 38108($t3)
		sw $s3, 38608($t3)
		sw $s3, 38620($t3)
		#
		sw $s3, 36580($t3)
		sw $s3, 36584($t3)
		sw $s3, 36588($t3)
		sw $s3, 36592($t3)
		sw $s3, 37104($t3)
		sw $s3, 37608($t3)
		sw $s3, 37612($t3)
		sw $s3, 38116($t3)
		sw $s3, 38628($t3)
		sw $s3, 38632($t3)
		sw $s3, 38632($t3)
		sw $s3, 38636($t3)
		#
		sw $s3, 36600($t3)
		sw $s3, 36608($t3)
		sw $s3, 37112($t3)
		sw $s3, 37116($t3)
		sw $s3, 37120($t3)
		sw $s3, 37628($t3)
		sw $s3, 38140($t3)
		sw $s3, 38652($t3)
		#
		sw $s3, 36620($t3)
		sw $s3, 36112($t3)
		sw $s3, 36116($t3)
		sw $s3, 36120($t3)
		sw $s3, 36636($t3)
		sw $s3, 37148($t3)
		sw $s3, 37656($t3)
		sw $s3, 37652($t3)
		sw $s3, 38164($t3)
		sw $s3, 39188($t3)
		
		jr $ra
		nop
		
	msg2: #The Dog is happy!
		sw $s3, 36392($t3)
		sw $s3, 36396($t3)
		sw $s3, 36400($t3)
		sw $s3, 36908($t3)
		sw $s3, 37420($t3)
		sw $s3, 37932($t3)
		sw $s3, 38444($t3)
		#
		sw $s3, 36408($t3)
		sw $s3, 36416($t3)
		sw $s3, 36920($t3)
		sw $s3, 36928($t3)
		sw $s3, 37432($t3)
		sw $s3, 37436($t3)
		sw $s3, 37440($t3)
		sw $s3, 37944($t3)
		sw $s3, 37952($t3)
		sw $s3, 38456($t3)
		sw $s3, 38464($t3)
		#
		sw $s3, 36424($t3)
		sw $s3, 36428($t3)
		sw $s3, 36432($t3)
		sw $s3, 36936($t3)
		sw $s3, 37448($t3)
		sw $s3, 37452($t3)
		sw $s3, 37960($t3)
		sw $s3, 38472($t3)
		sw $s3, 38476($t3)
		sw $s3, 38480($t3)
		#
		sw $s3, 36448($t3)
		sw $s3, 36452($t3)
		sw $s3, 36456($t3)
		sw $s3, 36960($t3)
		sw $s3, 36972($t3)
		sw $s3, 37472($t3)
		sw $s3, 37484($t3)
		sw $s3, 37984($t3)
		sw $s3, 37996($t3)
		sw $s3, 38496($t3)
		sw $s3, 38500($t3)
		sw $s3, 38504($t3)
		#
		sw $s3, 36468($t3)
		sw $s3, 36472($t3)
		sw $s3, 36476($t3)
		sw $s3, 36480($t3)
		sw $s3, 36980($t3)
		sw $s3, 36992($t3)
		sw $s3, 37492($t3)
		sw $s3, 37504($t3)
		sw $s3, 38004($t3)
		sw $s3, 38016($t3)
		sw $s3, 38516($t3)
		sw $s3, 38520($t3)
		sw $s3, 38524($t3)
		sw $s3, 38528($t3)
		#
		sw $s3, 36488($t3)
		sw $s3, 36492($t3)
		sw $s3, 36496($t3)
		sw $s3, 36500($t3)
		sw $s3, 37000($t3)
		sw $s3, 37512($t3)
		sw $s3, 37520($t3)
		sw $s3, 37524($t3)
		sw $s3, 38024($t3)
		sw $s3, 38036($t3)
		sw $s3, 38536($t3)
		sw $s3, 38540($t3)
		sw $s3, 38544($t3)
		sw $s3, 38548($t3)
		#
		sw $s3, 36516($t3)
		sw $s3, 36520($t3)
		sw $s3, 36524($t3)
		sw $s3, 37032($t3)
		sw $s3, 37544($t3)
		sw $s3, 38056($t3)
		sw $s3, 38564($t3)
		sw $s3, 38568($t3)
		sw $s3, 38572($t3)
		#
		sw $s3, 36532($t3)
		sw $s3, 36536($t3)
		sw $s3, 36540($t3)
		sw $s3, 36544($t3)
		sw $s3, 37044($t3)
		sw $s3, 37556($t3)
		sw $s3, 37560($t3)
		sw $s3, 37564($t3)
		sw $s3, 37568($t3)
		sw $s3, 38080($t3)
		sw $s3, 38580($t3)
		sw $s3, 38584($t3)
		sw $s3, 38588($t3)
		sw $s3, 38592($t3)
		#
		sw $s3, 36560($t3)
		sw $s3, 36568($t3)
		sw $s3, 37072($t3)
		sw $s3, 37080($t3)
		sw $s3, 37584($t3)
		sw $s3, 37588($t3)
		sw $s3, 37592($t3)
		sw $s3, 38096($t3)
		sw $s3, 38104($t3)
		sw $s3, 38608($t3)
		sw $s3, 38616($t3)
		#
		sw $s3, 36580($t3)
		sw $s3, 36584($t3)
		sw $s3, 36588($t3)
		sw $s3, 37088($t3)
		sw $s3, 37100($t3)
		sw $s3, 37600($t3)
		sw $s3, 37604($t3)
		sw $s3, 37608($t3)
		sw $s3, 37612($t3)
		sw $s3, 38112($t3)
		sw $s3, 38124($t3)
		sw $s3, 38624($t3)
		sw $s3, 38636($t3)
		#
		sw $s3, 36596($t3)
		sw $s3, 36600($t3)
		sw $s3, 36604($t3)
		sw $s3, 36608($t3)
		sw $s3, 37108($t3)
		sw $s3, 37120($t3)
		sw $s3, 37620($t3)
		sw $s3, 37624($t3)
		sw $s3, 37628($t3)
		sw $s3, 37632($t3)
		sw $s3, 38132($t3)
		sw $s3, 38644($t3)
		#
		sw $s3, 36616($t3)
		sw $s3, 36620($t3)
		sw $s3, 36624($t3)
		sw $s3, 36628($t3)
		sw $s3, 37128($t3)
		sw $s3, 37140($t3)
		sw $s3, 37640($t3)
		sw $s3, 37644($t3)
		sw $s3, 37648($t3)
		sw $s3, 37652($t3)
		sw $s3, 38152($t3)
		sw $s3, 38664($t3)
		#
		sw $s3, 36636($t3)
		sw $s3, 36644($t3)
		sw $s3, 37148($t3)
		sw $s3, 37152($t3)
		sw $s3, 37156($t3)
		sw $s3, 37664($t3)
		sw $s3, 38176($t3)
		sw $s3, 38688($t3)
		#
		sw $s3, 36660($t3)
		sw $s3, 37172($t3)
		sw $s3, 37684($t3)
		sw $s3, 38708($t3)
		
	
		jr $ra
		nop
		
	msg3:
		sw $s3, 36400($t3)
		sw $s3, 36908($t3)
		sw $s3, 36912($t3)
		sw $s3, 37416($t3)
		sw $s3, 37424($t3)
		sw $s3, 37936($t3)
		sw $s3, 38440($t3)
		sw $s3, 38444($t3)
		sw $s3, 38448($t3)
		sw $s3, 38452($t3)
		#
		sw $s3, 38460($t3)
		sw $s3, 38972($t3)
		sw $s3, 38488($t3)
		sw $s3, 38900($t3)
		sw $s3, 37496($t3)
		sw $s3, 37500($t3)
		sw $s3, 37504($t3)
		sw $s3, 38008($t3)
		sw $s3, 38016($t3)
		sw $s3, 38520($t3)
		sw $s3, 38524($t3)
		sw $s3, 38528($t3)
		sw $s3, 37512($t3)
		sw $s3, 37520($t3)
		sw $s3, 38024($t3)
		sw $s3, 38032($t3)
		sw $s3, 38536($t3)
		sw $s3, 38540($t3)
		sw $s3, 38544($t3)
		#
		sw $s3, 36420($t3)
		sw $s3, 36424($t3)
		sw $s3, 36428($t3)
		sw $s3, 36940($t3)
		sw $s3, 36944($t3)
		sw $s3, 37448($t3)
		sw $s3, 37452($t3)
		sw $s3, 37956($t3)
		sw $s3, 37960($t3)
		sw $s3, 38468($t3)
		sw $s3, 38472($t3)
		sw $s3, 38476($t3)
		sw $s3, 38480($t3)
		#
		sw $s3, 36448($t3)
		sw $s3, 36452($t3)
		sw $s3, 36456($t3)
		sw $s3, 36460($t3)
		sw $s3, 36972($t3)
		sw $s3, 37472($t3)
		sw $s3, 37476($t3)
		sw $s3, 37480($t3)
		sw $s3, 37424($t3)
		sw $s3, 37996($t3)
		sw $s3, 38496($t3)
		sw $s3, 38500($t3)
		sw $s3, 38504($t3)
		sw $s3, 38508($t3)
		#
		sw $s3, 36508($t3)
		sw $s3, 36520($t3)
		sw $s3, 37020($t3)
		sw $s3, 37032($t3)
		sw $s3, 37532($t3)
		sw $s3, 37536($t3)
		sw $s3, 37540($t3)
		sw $s3, 37544($t3)
		sw $s3, 38056($t3)
		sw $s3, 38568($t3)
		
		jr $ra
		nop
		
	winMsg:
		sw $s3, 36392($t3)
		sw $s3, 36400($t3)
		sw $s3, 36904($t3)
		sw $s3, 36908($t3)
		sw $s3, 36912($t3)
		sw $s3, 37420($t3)
		sw $s3, 37932($t3)
		sw $s3, 38444($t3)
		#
		sw $s3, 36408($t3)
		sw $s3, 36412($t3)
		sw $s3, 36416($t3)
		sw $s3, 36420($t3)
		sw $s3, 36920($t3)
		sw $s3, 36932($t3)
		sw $s3, 37432($t3)
		sw $s3, 37444($t3)
		sw $s3, 37944($t3)
		sw $s3, 37956($t3)
		sw $s3, 38456($t3)
		sw $s3, 38460($t3)
		sw $s3, 38464($t3)
		sw $s3, 38468($t3)
		#
		sw $s3, 36428($t3)
		sw $s3, 36440($t3)
		sw $s3, 36940($t3)
		sw $s3, 36952($t3)
		sw $s3, 37452($t3)
		sw $s3, 37464($t3)
		sw $s3, 37964($t3)
		sw $s3, 37976($t3)
		sw $s3, 38476($t3)
		sw $s3, 38480($t3)
		sw $s3, 38484($t3)
		sw $s3, 38488($t3)
		#
		sw $s3, 36456($t3)
		sw $s3, 36472($t3)
		sw $s3, 36968($t3)
		sw $s3, 36976($t3)
		sw $s3, 36984($t3)
		sw $s3, 37480($t3)
		sw $s3, 37488($t3)
		sw $s3, 37496($t3)
		sw $s3, 37992($t3)
		sw $s3, 38000($t3)
		sw $s3, 38008($t3)
		sw $s3, 38504($t3)
		sw $s3, 38508($t3)
		sw $s3, 38512($t3)
		sw $s3, 38516($t3)
		sw $s3, 38520($t3)
		#
		sw $s3, 36480($t3)
		sw $s3, 36484($t3)
		sw $s3, 36488($t3)
		sw $s3, 36996($t3)
		sw $s3, 37508($t3)
		sw $s3, 38020($t3)
		sw $s3, 38528($t3)
		sw $s3, 38532($t3)
		sw $s3, 38536($t3)
		#
		sw $s3, 36496($t3)
		sw $s3, 36508($t3)
		sw $s3, 37008($t3)
		sw $s3, 37012($t3)
		sw $s3, 37020($t3)
		sw $s3, 37520($t3)
		sw $s3, 37532($t3)
		sw $s3, 38032($t3)
		sw $s3, 38040($t3)
		sw $s3, 38044($t3)
		sw $s3, 38544($t3)
		sw $s3, 38556($t3)
		#
		sw $s3, 36516($t3)
		sw $s3, 36520($t3)
		sw $s3, 36524($t3)
		sw $s3, 36528($t3)
		sw $s3, 37028($t3)
		sw $s3, 37540($t3)
		sw $s3, 37544($t3)
		sw $s3, 37548($t3)
		sw $s3, 37552($t3)
		sw $s3, 38064($t3)
		sw $s3, 38564($t3)
		sw $s3, 38568($t3)
		sw $s3, 38572($t3)
		sw $s3, 38576($t3)
		#
		sw $s3, 36540($t3)
		sw $s3, 37052($t3)
		sw $s3, 37564($t3)
		sw $s3, 38588($t3)
		
		jr $ra
		nop
		
	died:
		sw $s3, 36392($t0)
		sw $s3, 36396($t0)
		sw $s3, 36400($t0)
		sw $s3, 36904($t0)
		sw $s3, 36916($t0)
		sw $s3, 37416($t0)
		sw $s3, 37428($t0)
		sw $s3, 37928($t0)
		sw $s3, 37940($t0)
		sw $s3, 38440($t0)
		sw $s3, 38448($t0)
		sw $s3, 38444($t0)
		#
		sw $s3, 36412($t0)
		sw $s3, 36416($t0)
		sw $s3, 36420($t0)
		sw $s3, 36928($t0)
		sw $s3, 37440($t0)
		sw $s3, 37952($t0)
		sw $s3, 38460($t0)
		sw $s3, 38464($t0)
		sw $s3, 38468($t0)
		#
		sw $s3, 36428($t0)
		sw $s3, 36432($t0)
		sw $s3, 36436($t0)
		sw $s3, 36940($t0)
		sw $s3, 37452($t0)
		sw $s3, 37456($t0)
		sw $s3, 37964($t0)
		sw $s3, 38476($t0)
		sw $s3, 38480($t0)
		sw $s3, 38484($t0)
		#
		sw $s3, 36444($t0)
		sw $s3, 36448($t0)
		sw $s3, 36452($t0)
		sw $s3, 36956($t0)
		sw $s3, 36968($t0)
		sw $s3, 37468($t0)
		sw $s3, 37480($t0)
		sw $s3, 37980($t0)
		sw $s3, 37992($t0)
		sw $s3, 38492($t0)
		sw $s3, 38496($t0)
		sw $s3, 38500($t0)
		#
		sw $s3, 36468($t0)
		sw $s3, 36980($t0)
		sw $s3, 37492($t0)
		sw $s3, 38516($t0)
		#
		sw $s3, 36476($t0)
		sw $s3, 36988($t0)
		sw $s3, 37500($t0)
		sw $s3, 38524($t0)
		#
		sw $s3, 36484($t0)
		sw $s3, 36996($t0)
		sw $s3, 37508($t0)
		sw $s3, 38532($t0)
		
		jr $ra
		nop
	

.data
	achievement1: .asciiz "Achievement Unlock [Flawless Victory]  -> Make a friedship with Annoying Dog without get injure"
	achievement2: .asciiz "Achievement Unlock [Genocide Path]  -> Kill Annoying Dog, your monster!"
	instrMgs: .asciiz "Menu\n   1 - Fight Mode\n   2 - Mercy Mode\n   3 - Item Menu\n\nGlobal Buttons\n   x - Select\n   z - Back\n\nCaps Lock always OFF\n\n"

