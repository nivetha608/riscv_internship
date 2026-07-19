#to subtract two numbers
#include "riscv_test.h"
# include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

sub_test:
    li x2,5
    li x3,10
    sub x1,x2,x3 #negative
	sub x4,x3,x2 #positive
    li x5,-5
    li x6,5
    bne x1,x5,fail
    bne x4,x6,fail
    mv s2,x1
	mv s3,x4

    RVTEST_PASS
fail:
    li a0,-1
    RVTEST_FAIL
RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
result:
    .dword -1
RVTEST_DATA_END


