#arithmetic operation using immediate value ADDI,ori,andi,xori
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

imm:
	li x1,-15
	li x2,0x1001
	addi a0,x1,20
	ori a1,x2,0x0100
	andi a2,x2,0x0011
	xori a3,x2,0x0010

	la t0,exp_addi
	ld t0,0(t0)

	la t1,exp_ori
	ld t1,0(t1)

	la t2,exp_andi
	ld t2,0(t2)

	la t3,exp_xori
	ld t3,0(t3)
	bne t0,a0,fail
	bne t1,a1,fail
	bne t2,a2,fail
	bne t3,a3,fail

	RVTEST_PASS
fail:
	li a4,-1
	RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
exp_addi:
	.dword 5
exp_ori:
	.dword 0x1101
exp_andi:
	.dword 0x0001
exp_xori:
	.dword 0x1011
RVTEST_DATA_END

