# to find the number of vowels in a string

#include"test_macros.h"
#include"riscv_test.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

count_vowel:
	la t0,str
	li t1,0 # result
loop:
	lbu t2,0(t0)
	beq t2,x0,verify

	la t3,vowels
	li t4,10
	li t5,0
check:
	lbu t6,0(t3)
	beq t6,t2,increment
	addi t3,t3,1
	addi t5,t5,1
	blt t5,t4,check
	j skip
increment:
	addi t1,t1,1
skip:
	addi t0,t0,1
	j loop
verify:
	la t6,expected
	ld a1,0(t6)

	bne a1,t1,fail
	RVTEST_PASS
fail:
	RVTEST_FAIL


RVTEST_CODE_END

RVTEST_DATA_BEGIN
	.align 3
str:
	.string "HELLO world"
.align 3
expected:
	.dword 3
vowels:
	.byte 'a','e','i','o','u','A','E','I','O','U'
RVTEST_DATA_END
