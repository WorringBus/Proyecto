ADD $t0, $t1, $t2
SUB $s0, $s1, $s2
AND $t3, $t4, $t5
OR  $a0, $a1, $a2
SLT $v0, $v1, $a0
ADDI $t0, $t1, 10
ANDI $s0, $s1, 0xFF
ORI  $t2, $t3, 5
XORI $s2, $s3, 12
SLTI $a1, $a2, -3
BEQ  $t0, $t1, 100
BNE  $a0, $a1, 100
BGTZ $t2, 100
LW  $t0, 4($sp)
SW  $t1, 8($sp)
J 100