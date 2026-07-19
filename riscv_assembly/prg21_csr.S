# basic csr read write set clear instructions using mscratch

#include"riscv_test.h"
#include"test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

csr_inst:
	li t0,0x0FF3
	li t1,0x0AA5

	csrw mscratch,t0

	csrr t2,mscratch

	csrrw t3,mscratch,t1

	csrrs t4,mscratch,t1

	csrrc t5,mscratch,t1

	csrrwi t6,mscratch,0x0F

	csrrsi t0,mscratch,0x03

	csrrci t1,mscratch,0x05

	RVTEST_PASS
fail:
	RVTEST_FAIL
RVTEST_CODE_END

.data
RVTEST_DATA_BEGIN
	.align 3

RVTEST_DATA_END



