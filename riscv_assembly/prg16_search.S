#include "test_macros.h"
#include "riscv_test.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

search:
	la t0,array
	la t1, val_add
	ld t6, 0(t1)   # val to search

	li t2, 7   # size
	li t3, 0  #counter

loop:
	slli t4, t3, 3
	add t4, t4, t0

	ld a1, 0(t4)
	beq t6, a1, found

	addi t3, t3, 1
	blt t3, t2, loop

nfound:
	li a0,-1              # value not found
	j verify

found:
	mv a0,t4

verify:
	la t5,expected_addr
	ld t5,0(t5)

	bne a0,t5,fail
	RVTEST_PASS

fail:
	li a0,1
	RVTEST_FAIL

RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
array:
	.dword 1, 4, 6, -3, 0, 5, 2

val_add:
	.dword 6

expected_addr:
	.dword array+16
RVTEST_DATA_END
