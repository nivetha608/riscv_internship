#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

    li a0, 0x40400000       # 3.0f
    li a1, 0x40000000       # 2.0f
    fmv.w.x f1, a0
    fmv.w.x f2, a1

    fdiv.s f3, f1, f2       # 3.0 / 2.0 = 1.5 (0x3fc00000)

    fmv.x.w a2, f3

    la s0, result
    sw a2, 0(s0)

RVTEST_PASS

fail:
RVTEST_FAIL

RVTEST_CODE_END
RVTEST_DATA_BEGIN

.data
  .align 3
  result: .dword -1

RVTEST_DATA_END
