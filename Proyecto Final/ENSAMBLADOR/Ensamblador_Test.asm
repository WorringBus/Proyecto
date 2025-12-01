addi $t0 $zero 0
addi $t1 $zero 5
addi $t2 $zero 0
lw $t3 0($t2)
addi $t4 $zero 1
slt $t5 $t4 $t1
beq $t5 $zero 48
addi $t0 $t0 4
add $t6 $t2 $t0
lw $t7 0($t6)
slt $t8 $t3 $t7
beq $t8 $zero 8
add $t3 $t7 $zero
addi $t4 $t4 1
j 20
sw $t3 100($zero)
andi $s0 $t3 255
ori $s1 $t3 256
xori $s2 $t3 128
nop
nop
nop