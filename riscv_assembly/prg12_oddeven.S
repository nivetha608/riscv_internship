#when num is odd t1=1 even t1=0

#include"riscv_test.h"
#include"test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

oddeven_test:
	li t0,21 #num
	li t1,0 #result
	li t2,0 #rem
	li t3,2
	call check

	li t4,1 # Expected value
	bne t1,t4,fail
	RVTEST_PASS

check:
	rem t2,t0,t3
	bne t2,x0,set_val
	j end
set_val:
		li t1,1
		j end
end:
	jalr x0,0(ra)
fail:
	li a0,1
	RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
RVTEST_DATA_END



