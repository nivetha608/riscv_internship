# find the min element

#include "test_macros.h"
#include "riscv_test.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

find_max:
    la t0,array
    li t2,7   #size
    li t3,0   #counter

    ld t6,0(t0)  #array[0]
    addi t3,t3,1  # Start from index 1

loop:
    beq t3, t2, verify

    slli t4,t3,3
    add t4,t0,t4
    ld a1,0(t4)

    slt t5, a1, t6
    beq t5, x0, skip
    mv t6, a1

skip:
    addi t3, t3, 1
    j loop

verify:
    la t1, val_add
    ld t1, 0(t1)         # expected min
    bne t6, t1, fail     # compare result
    RVTEST_PASS

fail:
    li a0, 1
    RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
    .align 3
array:
    .dword 1, 4, 6, -3, 0, 5, 2

val_add:
    .dword -3

RVTEST_DATA_END
