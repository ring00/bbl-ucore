    .section .text,"ax",%progbits
    .globl _entry
_entry:
    la sp, bootstacktop

    tail kern_init
