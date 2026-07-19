#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

trap_test:
    la t0, trap_handler
    csrw mtvec, t0

    ebreak

.align 2
trap_handler:
    csrr t1, mcause
    la   t2, mcause_val
    sd   t1, 0(t2)
    li t3, 3                # 3 = EBREAK
    bne t1, t3, fail

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.section .data
RVTEST_DATA_BEGIN
    .align 3
mcause_val: .space 8        
RVTEST_DATA_END
