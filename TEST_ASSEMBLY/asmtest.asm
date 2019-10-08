.text

addi $t0,$zero,8192
addi $t1,$zero,8486
sw $t1,0($t0)
lw $t2,0($t0)
add $t2,$t1,$t0
sub $t2,$t1,$t0
addi $t0,$zero,3
addi $t0,$zero,5
and $t2,$t1,$t0
andi $t2,$t1,5
or $t2,$t1,$t0
ori $t2,$t1,5
nor $t2,$t1,$t0
xor $t2,$t1,$t0
xori $t2,$t1,5
slt $t2,$t1,$t0
slti $t2,$t1,-1
sll $t2,$t1,2
srl $t2,$t2,2
addi $t2,$zero,-32
sra $t2,$t1,2
j JumpNothing
addi $t2,$zero,13
addi $t2,$t2,13
addi $t2,$t2,8001
JumpNothing:
addi $t2,$zero,120
jr $t2
addi $t2,$zero,23
addi $t2,$t2,23
addi $t2,$t2,8201
jal SkipStuff
addi $t2,$zero,33
addi $t2,$t2,33
addi $t2,$t2,8301
SkipStuff:
beq $t1,$t0,Branch
bne $t1,$t0,bnestuff
Branch:
addi $s0,$zero,10
bnestuff:
addi $s1,$zero,23