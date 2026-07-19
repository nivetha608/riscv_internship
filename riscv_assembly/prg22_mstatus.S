#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

    li t0, 0x8
    csrw mstatus, t0
    csrr t1, mstatus
    la s0, result
    sw t1, 0(s0)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
.align 3
result: .space 4
RVTEST_DATA_END
