#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN


    la      t0, val1
    fld     f1, 0(t0)
    la      t1, val2
    fld     f2, 0(t1)

    fadd.d  f3, f1, f2
    la      t2, result_add
    fsd     f3, 0(t2)

    fsub.d  f4, f1, f2
    la      t2, result_sub
    fsd     f4, 0(t2)


    fmul.d  f5, f1, f2
    la      t2, result_mul
    fsd     f5, 0(t2)

    fdiv.d  f6, f1, f2
    la      t2, result_div
    fsd     f6, 0(t2)

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
val1:         .double  6.5
val2:         .double  2.0
result_add:   .space  8
result_sub:   .space  8
result_mul:   .space  8
result_div:   .space  8
result_csr:   .space  4
RVTEST_DATA_END
