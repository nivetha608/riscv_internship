# when input > 0 result(t2) is 1 elseif input=0 result 0 else result -1
#include"riscv_test.h"
#include"test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

if_elseif_else:
	la t0,input #input
	ld t0,0(t0)
	la t3,exp_result #expected result
	ld t3,0(t3)
	call set_result

	bne t2,t3,fail
	RVTEST_PASS

set_result:
	li t1,0
	li t4,1
	slt t1,x0,t0
	beq t1,t4,if_logic

	beq t0,x0,else_if
	li t2,-1 #else
	j end
if_logic:
	li t2,1
	j end
else_if:
	li t2,0
	j end
end:
	jalr x0,0(ra)
fail:
	li a0,-1
	RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
input:
	.dword 5
exp_result:
	.dword 1
RVTEST_DATA_END
