# matrix addition 2x2 the final results are stored in a0-a3 the results are also verified
#include"test_macros.h"
#include"riscv_test.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

matadd:
	la t0,mat_a
	la t1,mat_b
	la t2,mat_res #result

	li t3,4 #size
	li t4,0 #counter
add_loop:
	ld t5,0(t0)
	ld t6,0(t1)

	add t5,t5,t6 #a(i)+b(i)
	sd t5,0(t2) #store double val in result
	addi t4,t4,1

	addi t0,t0,8
	addi t1,t1,8
	addi t2,t2,8

	blt t4,t3,add_loop

	j verify
verify:
	# re initialize value
	la t2,mat_res
	la t6,mat_exp
	li t4,0
verify_loop:
	ld t5,0(t2)
	ld t1,0(t6)

	bne t5,t1,fail
	addi t4,t4,1

	add t2,t2,8
	add t6,t6,8
	blt t4,t3,verify_loop
	j pass
fail:
	li a0,-1
	RVTEST_FAIL
pass:
    la t2,mat_res

    ld a0, 0(t2)
    ld a1, 8(t2)
    ld a2, 16(t2)
    ld a3, 24(t2)

    RVTEST_PASS

RVTEST_CODE_END

RVTEST_DATA_BEGIN
 .align 3
mat_a:
	.dword 10 #r1,c1
	.dword 20 #r1,c2
	.dword 30 #r2,c1
	.dword 40 #r2,c2
mat_b:
	.dword 1 #r1,c1
	.dword 2 #r1,c2
	.dword 3 #r2,c1
	.dword 4 #r2,c2
mat_exp:
	.dword 11 #r1,c1
	.dword 22 #r1,c2
	.dword 33 #r2,c1
	.dword 44 #r2,c2
mat_res:
	.space 32
RVTEST_DATA_END
