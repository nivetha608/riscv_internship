# SUM OF FIRST N NATURAL NUMBERS
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

while_loop:
    li t0, 0 #COUNTER i
    li t1, 5 #INPUT
    li t2, 0 #RESULT

loop:
    add t2, t2, t0
    addi t0, t0, 1
    bgt t0, t1, Endwhile
    j loop

Endwhile:
    li t3, 15
    bne t2, t3, fail
    RVTEST_PASS
fail:
    li a0, 1
    RVTEST_FAIL

RVTEST_CODE_END


RVTEST_DATA_BEGIN
    .align 3
	sum_result_placeholder:
        .dword -1
RVTEST_DATA_END

