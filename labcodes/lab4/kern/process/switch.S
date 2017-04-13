#include <bits.h>

.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    // movl 4(%esp), %eax          # eax points to from
    // popl 0(%eax)                # save eip !popl
    // movl %esp, 4(%eax)          # save esp::context of from
    // movl %ebx, 8(%eax)          # save ebx::context of from
    // movl %ecx, 12(%eax)         # save ecx::context of from
    // movl %edx, 16(%eax)         # save edx::context of from
    // movl %esi, 20(%eax)         # save esi::context of from
    // movl %edi, 24(%eax)         # save edi::context of from
    // movl %ebp, 28(%eax)         # save ebp::context of from

    // movl 4(%esp), %eax          # not 8(%esp): popped return address already
    //                             # eax now points to to
    // movl 28(%eax), %ebp         # restore ebp::context of to
    // movl 24(%eax), %edi         # restore edi::context of to
    // movl 20(%eax), %esi         # restore esi::context of to
    // movl 16(%eax), %edx         # restore edx::context of to
    // movl 12(%eax), %ecx         # restore ecx::context of to
    // movl 8(%eax), %ebx          # restore ebx::context of to
    // movl 4(%eax), %esp          # restore esp::context of to

    // pushl 0(%eax)               # push eip

    // ret

    # save from's registers
    STORE ra, 0*REGBYTES(a0)
    STORE sp, 1*REGBYTES(a0)
    STORE s0, 2*REGBYTES(a0)
    STORE s1, 3*REGBYTES(a0)
    STORE s2, 4*REGBYTES(a0)
    STORE s3, 5*REGBYTES(a0)
    STORE s4, 6*REGBYTES(a0)
    STORE s5, 7*REGBYTES(a0)
    STORE s6, 8*REGBYTES(a0)
    STORE s7, 9*REGBYTES(a0)
    STORE s8, 10*REGBYTES(a0)
    STORE s9, 11*REGBYTES(a0)
    STORE s10, 12*REGBYTES(a0)
    STORE s11, 13*REGBYTES(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
    LOAD sp, 1*REGBYTES(a1)
    LOAD s0, 2*REGBYTES(a1)
    LOAD s1, 3*REGBYTES(a1)
    LOAD s2, 4*REGBYTES(a1)
    LOAD s3, 5*REGBYTES(a1)
    LOAD s4, 6*REGBYTES(a1)
    LOAD s5, 7*REGBYTES(a1)
    LOAD s6, 8*REGBYTES(a1)
    LOAD s7, 9*REGBYTES(a1)
    LOAD s8, 10*REGBYTES(a1)
    LOAD s9, 11*REGBYTES(a1)
    LOAD s10, 12*REGBYTES(a1)
    LOAD s11, 13*REGBYTES(a1)

    ret