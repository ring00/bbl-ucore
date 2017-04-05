#include <bits.h>

    .macro SAVE_ALL

    csrw sscratch, sp

    addi sp, sp, -36 * REGBYTES
    # save gprs
    STORE  x1,1*REGBYTES(sp)
    STORE  x3,3*REGBYTES(sp)
    STORE  x4,4*REGBYTES(sp)
    STORE  x5,5*REGBYTES(sp)
    STORE  x6,6*REGBYTES(sp)
    STORE  x7,7*REGBYTES(sp)
    STORE  x8,8*REGBYTES(sp)
    STORE  x9,9*REGBYTES(sp)
    STORE  x10,10*REGBYTES(sp)
    STORE  x11,11*REGBYTES(sp)
    STORE  x12,12*REGBYTES(sp)
    STORE  x13,13*REGBYTES(sp)
    STORE  x14,14*REGBYTES(sp)
    STORE  x15,15*REGBYTES(sp)
    STORE  x16,16*REGBYTES(sp)
    STORE  x17,17*REGBYTES(sp)
    STORE  x18,18*REGBYTES(sp)
    STORE  x19,19*REGBYTES(sp)
    STORE  x20,20*REGBYTES(sp)
    STORE  x21,21*REGBYTES(sp)
    STORE  x22,22*REGBYTES(sp)
    STORE  x23,23*REGBYTES(sp)
    STORE  x24,24*REGBYTES(sp)
    STORE  x25,25*REGBYTES(sp)
    STORE  x26,26*REGBYTES(sp)
    STORE  x27,27*REGBYTES(sp)
    STORE  x28,28*REGBYTES(sp)
    STORE  x29,29*REGBYTES(sp)
    STORE  x30,30*REGBYTES(sp)
    STORE  x31,31*REGBYTES(sp)

    # get sr, epc, badvaddr, cause
    csrr s0, sscratch
    csrr s1, sstatus
    csrr s2, sepc
    csrr s3, sbadaddr
    csrr s4, scause

    STORE s0, 2*REGBYTES(sp)
    STORE s1, 32*REGBYTES(sp)
    STORE s2, 33*REGBYTES(sp)
    STORE s3, 34*REGBYTES(sp)
    STORE s4, 35*REGBYTES(sp)
    .endm

    .macro RESTORE_ALL

    csrr a0, sscratch
    addi sp, sp, -36 * REGBYTES

    # restore x registers
    LOAD  x1,1*REGBYTES(a0)
    LOAD  x2,2*REGBYTES(a0)
    LOAD  x3,3*REGBYTES(a0)
    LOAD  x4,4*REGBYTES(a0)
    LOAD  x5,5*REGBYTES(a0)
    LOAD  x6,6*REGBYTES(a0)
    LOAD  x7,7*REGBYTES(a0)
    LOAD  x8,8*REGBYTES(a0)
    LOAD  x9,9*REGBYTES(a0)
    LOAD  x11,11*REGBYTES(a0)
    LOAD  x12,12*REGBYTES(a0)
    LOAD  x13,13*REGBYTES(a0)
    LOAD  x14,14*REGBYTES(a0)
    LOAD  x15,15*REGBYTES(a0)
    LOAD  x16,16*REGBYTES(a0)
    LOAD  x17,17*REGBYTES(a0)
    LOAD  x18,18*REGBYTES(a0)
    LOAD  x19,19*REGBYTES(a0)
    LOAD  x20,20*REGBYTES(a0)
    LOAD  x21,21*REGBYTES(a0)
    LOAD  x22,22*REGBYTES(a0)
    LOAD  x23,23*REGBYTES(a0)
    LOAD  x24,24*REGBYTES(a0)
    LOAD  x25,25*REGBYTES(a0)
    LOAD  x26,26*REGBYTES(a0)
    LOAD  x27,27*REGBYTES(a0)
    LOAD  x28,28*REGBYTES(a0)
    LOAD  x29,29*REGBYTES(a0)
    LOAD  x30,30*REGBYTES(a0)
    LOAD  x31,31*REGBYTES(a0)
    # restore a0 last
    LOAD  x10,10*REGBYTES(a0)
    .endm

    .align 4
    .globl __alltraps
__alltraps:
    SAVE_ALL

    move  a0, sp
    jal trap

    .globl __trapret
__trapret:
    RESTORE_ALL
    j debug
    # go back from supervisor call
    sret
