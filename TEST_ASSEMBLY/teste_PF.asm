.data
ari: 	.word	1 2 3 4 5

.text
	addi 	$t0, $zero, 15	# testa addi 	=> t0 = 15  0xF
	addi	$t1, $zero, 37	#		=> t1 = 37  0x25
	add	$t2, $t0, $t1	# testa add	=> t2 = 52  0x34
	add	$t2, $t0, $t1	# testa add	=> t2 = 52  0x34
	add	$t2, $t0, $t1	# testa add	=> t2 = 52  0x34 
	add	$t2, $t0, $t1	# testa add	=> t2 = 52  0x34 
	sub	$t3, $t1, $t0	# testa sub	=> t3 = 12  0x16
	and	$t4, $t1, $t0 	# testa and	=> t4 = 5   0x5
	or 	$t5, $t1, $t0	# testa or	=> t5 = 47  0x2F
	nor	$t6, $t1, $t0	# testa nor	=> t6 = -48 0xFFFFFFD0
	xor	$t7, $t1, $t0	# testa xor	=> t7 = 42  0x2A
	sll	$s2, $t0, 4	# testa sll	=> s2 = 240 0xF0
	srl	$s3, $t6, 1	# testa srl	=> s3 = 2147483624 0x7fffffe8
	sra	$s4, $t6, 1	# testa sra	=> s4 = -24 0xffffffe8
	ori	$s5, $t1, 0xff #testa ori 	=> s5 = 0xff
	xori	$s6, $t1, 0xff #testa xori	=> s6 = 0xda
	andi	$s6, $t1, 0xff #testa andi	=> s6 = 0x25
	slti	$s6, $t0, 20 #testa slti	=> s6 = 1
	slti	$s5, $t0, 1 #testa slti		=> s5 = 0
	la	$s5, ari #s5 <= 0x2000
	lw	$s6, 0($s5) #s6 <= 0x1
	lw 	$s7, 4($s5) #s6 <= 0x2
	sw	$t4, 8($s5) #mem[2008] <= 0x5
	slt	$s0, $t1, $t0	# testa slt	=> s0 = 0
	bne	$s0, $zero, 	PrimPulo	# falha -> PC vai para 0x64
	slt	$s1, $t0, $t1	# testa slt	=> s1 = 1
	bne	$s1, $zero, PrimPulo	# salta -> PC vai para 0x78
PrimVolta:
	jal	SubRot #ra = 0x70, pc = 0x84 
	j	FIM #pc 0x8c
	add $zero, $zero, $zero
PrimPulo:
	beq 	$s1, $zero, FIM # falha --> PC vai para 0x7c
	add $zero, $zero, $zero
	j	PrimVolta # PC vai oara 0x6c	
SubRot:
	jr	$ra #pc = 70
	add $zero, $zero, $zero
FIM:
	j FIM
