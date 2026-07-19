#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

trap_test:
    la t0,m_trap
    csrw mtvec,t0

    li t1,(1 << 11)
    csrs mstatus,t1
    la t2,supervisor
    csrw mepc,t2
    mret

supervisor:
    la t3,user_mode
    csrw sepc,t3
    li t1,0               # SPP = User
    csrw sstatus,t1
    sret

.align 2
user_mode:
    ecall                  # Trigger U-mode syscall

.align 2
m_trap:
    csrr t3,mcause
    la s1,mcause_val
    sd t3,0(s1)

    li t4,8  # mcause for sys call from user mode
    bne t3,t4,fail

    csrr t2,mstatus
    la s0,result
    sd t2,0(s0)

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.section .data
RVTEST_DATA_BEGIN
    .align 3
result:      .space 8
mcause_val:  .space 8
RVTEST_DATA_END
