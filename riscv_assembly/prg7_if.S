# if t0 is less than zero then t0=0 else the value in t0 is retained
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

conditional_zero_test:
    li t0, 5
    call set_to_zero_if_negative
    li t3, 5
    bne t0, t3, fail

    li t0, -5
    call set_to_zero_if_negative
    li t3, 0
    bne t0, t3, fail

    RVTEST_PASS

fail:
    li a0, 1
    RVTEST_FAIL


set_to_zero_if_negative:
    slt t1, t0, x0      # Set Less Than: t1 = 1 if t0 < 0; else t1 = 0

    beq t1, x0, Endif
    li t0, 0
Endif:
	jalr x0, 0(ra)



RVTEST_CODE_END


RVTEST_DATA_BEGIN
    .align 3
result_placeholder:
    .dword -1
RVTEST_DATA_END
