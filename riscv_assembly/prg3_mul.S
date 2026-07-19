#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

multiply_test:
    li x3, -2
    li x4, 4
    mul x5, x3, x4   # x5=x3*x4(lower 64 bits of signed product)
    mulh x6, x3, x4   # x6=(x3 * x4)>>64 (higher 64 bits of signed product)
    mulhu x7, x3, x4   # x7=(unsigned(x3)*unsigned(x4))>>64(higher 64 bits of unsigned product)
    mulhsu x8, x3, x4 # x8=(signed(x3) * unsigned(x4)) >> 64 (higher 64 bits of mixed product)
    mulhsu x9, x4, x3   # x =(signed(x4) * unsigned(x3)) >> 64 (higher 64 bits of mixed product)

    li t0, -8
    bne x5, t0, fail

    li t1, -1
    bne x6, t1, fail

    li t3, -1
    bne x8, t3, fail

    RVTEST_PASS

fail:
    li a0, 1
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
result_placeholder:
    .dword -1
RVTEST_DATA_END
