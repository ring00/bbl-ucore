    .section .text,"ax",%progbits
    .globl _start
_start:
    la sp, bootstacktop

    tail kern_init
