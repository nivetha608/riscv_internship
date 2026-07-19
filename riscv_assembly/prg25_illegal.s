.section .text
.globl _start

_start:
    la t0, trap_handler
    csrw mtvec, t0

    .word 0xFFFFFFFF
    
    j end


trap_handler:
    csrr t1, mcause
    csrr t2, mepc

    la t3, result
    sw t1, 0(t3)
    sw t2, 4(t3)

    li a0, 4
    add t2, t2, a0
    csrw mepc, t2

    mret

end:
    j end

.section .data
result: .space 8
