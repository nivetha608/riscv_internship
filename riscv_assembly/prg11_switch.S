#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

single_case_switch_test:
    li t0, 2   # case
    li t1, 0   #result
    call switch_logic

    li t3, 20       # Expected result
    bne t1, t3, fail

    RVTEST_PASS

fail:
    li a0, 1
    RVTEST_FAIL


switch_logic:
    li t2, 1
    beq t0, t2, case1_block

    li t2, 2
    beq t0, t2, case2_block

    li t2, 3
    beq t0, t2, case3_block

    j end_switch_logic

case1_block:
    li t1, 10
    j end_switch_logic

case2_block:
    li t1, 20
    j end_switch_logic

case3_block:
    li t1, 30
    j end_switch_logic

end_switch_logic:
    jalr x0,0(ra)

RVTEST_CODE_END


RVTEST_DATA_BEGIN
    .align 3
    result_placeholder:
        .dword -1
RVTEST_DATA_END
