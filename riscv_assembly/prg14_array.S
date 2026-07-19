# sum of elements in a array

#include"test_macros.h"
#include"riscv_test.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

array_sum:
	la t0,my_array #address of array

	la t1,size
	ld t1,0(t1)

	li t2,0 #counter
	li t3,0 #result
loop:

	ld t5,0(t0) #array(i)
	add t3,t5,t3

	addi t2,t2,1 #increment

	addi t0,t0,8 # becoz of double word 8 bytes

	blt t2,t1,loop

	la t6,exp_val
	ld t6,0(t6)

	bne t6,t3,fail
	RVTEST_PASS
fail:
	li a0,-1
	RVTEST_FAIL


RVTEST_CODE_END

RVTEST_DATA_BEGIN
 .align 3
my_array:
	.dword 10,20,30,40
size:
	.dword 4
exp_val:
	.dword 100
RVTEST_DATA_END
