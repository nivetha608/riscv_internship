# to find the length of the string

#include"riscv_test.h"
#include"test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

str_len:
	la t0,str
	li t1,0 #counter
loop:
	lbu t2,0(t0)
	beq t2,x0,verify

	addi t1,t1,1
	addi t0,t0,1

	j loop
verify:
	la t3,expected
	ld t4,0(t3)
	bne t4,t1,fail
	RVTEST_PASS
fail:
	RVTEST_FAIL


RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
str:
	.string "RISC V"
expected:
	.dword 6
RVTEST_DATA_END
