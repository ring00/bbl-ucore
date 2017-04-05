/* Simple linker script for the JOS kernel.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_ARCH(riscv)
ENTRY(_entry)

BASE_ADDRESS = 0xC0000000;
HEAP_SIZE = 0x1000;
STACK_SIZE = 0x1000;

SECTIONS
{
	/* Load the kernel at this address: "." means the current address */
	. = BASE_ADDRESS;

	.text : {
		*(.text._entry)
		*(.text)
		*(.text.*)
	}
	etext = .;

	.rodata : {
		*(.rodata)
		*(.rodata.*)
	}

	/* Include debugging information in kernel memory */
	.stab : {
		PROVIDE(__STAB_BEGIN__ = .);
		*(.stab);
		PROVIDE(__STAB_END__ = .);
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}

	.stabstr : {
		PROVIDE(__STABSTR_BEGIN__ = .);
		*(.stabstr);
		PROVIDE(__STABSTR_END__ = .);
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}

	/* Adjust the address for the data segment to the next page */
	. = ALIGN(0x1000);

	.data : {
		*(.data)
		*(.data.*)
	}
	edata = .;

	.bss : {
		*(.sbss)
		*(.sbss.*)
		*(.bss)
		*(.bss.*)
		*(COMMON)
	}
	ebss = .;

	/* Stack and heap */
	. = ALIGN(16);
	heap = .;
	. += HEAP_SIZE;
	. = ALIGN(16);
	eheap = .;

	estack = .;
	. += STACK_SIZE;
	. = ALIGN(16);
	stack = .;	

	end = .;

	/DISCARD/ : {
		*(.comment)
		*(.note*)
	}
}

