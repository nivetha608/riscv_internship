#factorial without recursion

#include"riscv_test.h"
#include"test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

factorial:
	la t0,input #input
	ld t0,0(t0)
	li t1,1 #result
	call fact

	la t2,exp_result
	ld t2,0(t2)
	bne t1,t2,fail

	RVTEST_PASS

fact:
	blt t0,x0,error
	loop:
		beq t0,x0,end
		mul t1,t1,t0
		addi t0,t0,-1
		j loop
error:
		li t1,-1
end:
		jalr x0,0(ra)
fail:
	li a0,-1
	RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
input:
	.dword 0x5
exp_result:
	.dword 120
RVTEST_DATA_END



