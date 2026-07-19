#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

bitwise:
    li x1, 0x0101
    li x2, 0x1001

    or a0, x1, x2

    not a1, x1

    and a2, x1, x2

    xor a3, x1, x2

    la t0, exp_or
    ld t0, 0(t0)

    la t1, exp_not
    ld t1, 0(t1)

    la t2, exp_and
    ld t2, 0(t2)

    la t3, exp_xor
    ld t3, 0(t3)

    bne a0, t0, fail
    bne a1, t1, fail
    bne a2, t2, fail
    bne a3, t3, fail


    RVTEST_PASS

fail:
    li a0, 1
    RVTEST_FAIL

RVTEST_CODE_END


RVTEST_DATA_BEGIN
    .align 3
exp_or:
    .dword 0x1101
exp_not:
    .dword 0xFFFFFFFFFFFFFEFE
exp_and:
    .dword 0x0001
exp_xor:
    .dword 0x1100        
RVTEST_DATA_END
