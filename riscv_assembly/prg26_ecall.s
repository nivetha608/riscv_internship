# to handle a ecall trap
.section .text
.align 2
.global _start

_start:

    la t0, trap_handler
    csrw mtvec, t0

    li a0, 0x1234

    ecall

.align 2
trap_handler:
    csrr t1, mcause
    li t2, 11 # for machine mode ecall

    bne t1, t2, unknown_trap

handle_ecall:

    la t3, result
    sd a0, 0(t3)

    mret

unknown_trap:
    j end
end:
    j end

.section .data
.align 3
result:
    .quad 0
