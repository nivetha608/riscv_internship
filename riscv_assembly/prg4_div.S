#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

divide_and_rem_test:

    li x1, 10
    li x2, 5

    div x3, x1, x2

    li t0, 2
    bne x3, t0, fail

    rem x5, x1, x2

    li t2, 0
    bne x5, t2, fail


    RVTEST_PASS

fail:
    li a0, -1
    RVTEST_FAIL         

RVTEST_CODE_END


RVTEST_DATA_BEGIN
    .align 3
result_div_placeholder:
    .dword -1
result_rem_placeholder:
    .dword -1
RVTEST_DATA_END
