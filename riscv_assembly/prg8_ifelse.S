
# when input is greater than or equal to zero output one else output zero

#include"riscv_test.h"
#include"test_macros.h"


RVTEST_RV64U
RVTEST_CODE_BEGIN

ifelse:
	la t0,input
	ld t0,0(t0)
	call if_logic

	la t4,exp_t2
	ld t4,0(t4)
	bne t2,t4,fail

	RVTEST_PASS
if_logic:
	li t1,0
	slt t1,t0,x0
	beq t1,x0,Else_logic
	li t2,0
	j end
Else_logic:
	li t2,1
end:
	jalr x0,0(ra)
fail:
	li a0,1
	RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
input:
	.dword -5
exp_t2:
	.dword 0
RVTEST_DATA_END



