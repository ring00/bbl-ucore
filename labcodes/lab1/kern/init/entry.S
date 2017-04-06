	.section .text,"ax",%progbits
	.globl _entry
_entry:
	la sp, stack

	tail kern_init
