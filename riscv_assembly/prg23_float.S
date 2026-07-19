# single precision floating point

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

    la      t0, val1
    flw     f1, 0(t0)
    la      t1, val2
    flw     f2, 0(t1)

    fadd.s  f3, f1, f2
    la      t2, result_add
    fsw     f3, 0(t2)

    fsub.s  f4, f1, f2
    la      t2, result_sub
    fsw     f4, 0(t2)


    fmul.s  f5, f1, f2
    la      t2, result_mul
    fsw     f5, 0(t2)

    fdiv.s  f6, f1, f2
    la      t2, result_div
    fsw     f6, 0(t2)

    frcsr   t3
    la      t2, result_csr
    sw      t3, 0(t2)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
.align 3
val1:         .float  6.5
val2:         .float  2.0
result_add:   .space  4
result_sub:   .space  4
result_mul:   .space  4
result_div:   .space  4
result_csr:   .space  4
RVTEST_DATA_END
