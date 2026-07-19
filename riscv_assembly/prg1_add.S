#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

add_test:
    li x2, 5           # Load 5 into x2
    li x3, 10          # Load 10 into x3
    add x4, x2, x3     # x4 = x2 + x3
    li x5, 15          # Expected result
    bne x4, x5, fail   # If result is wrong, jump to fail

    mv a0, x4          # Move result to a0 (optional, used by RVTEST_PASS)
    RVTEST_PASS        # Test passed

fail:
    li a0, 1
    RVTEST_FAIL        # Test failed

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
result:
    .dword -1
RVTEST_DATA_END
