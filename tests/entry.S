//#include <mmu.h>
//#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop

    tail kern_init

.section .data
    .align 2^12  #PGSHIFT
    .global bootstack
bootstack:
    .space 4096  #KSTACKSIZE
    .global bootstacktop
bootstacktop:
