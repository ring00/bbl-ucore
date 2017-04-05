	.section ".text._entry", "ax", %progbits
	.globl _entry
_entry:
	la sp, stack

	tail kern_init
