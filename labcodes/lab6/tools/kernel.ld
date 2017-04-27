/* Simple linker script for the JOS kernel.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_ARCH(riscv)
ENTRY(kern_entry)

BASE_ADDRESS = 0xC0000000;
STACK_SIZE = 0x2000;

SECTIONS
{
    /* Load the kernel at this address: "." means the current address */
    . = BASE_ADDRESS;

    .text : {
        *(.text.kern_entry)
        *(.text)
        *(.text.*)
        *(.stub)
        *(.gnu.linkonce.t.*)
    }
    etext = .;

    .rodata : {
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
    }

    /* Include debugging information in kernel memory */
    .stab : {
        PROVIDE(__STAB_BEGIN__ = .);
        *(.stab);
        PROVIDE(__STAB_END__ = .);
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    .stabstr : {
        PROVIDE(__STABSTR_BEGIN__ = .);
        *(.stabstr);
        PROVIDE(__STABSTR_END__ = .);
        BYTE(0)     /* Force the linker to allocate space
                   for this section */
    }

    /* Adjust the address for the data segment to the next page */
    . = ALIGN(0x1000);

    .data : {
        *(.data)
        *(.data.*)
    }

    . = ALIGN(0x1000);
    /* Stack */
    /* I have to put it here because BBL put page table after BSS section.
       And the recursively call of printnum will corrupt the initial page
       table when putting stack after BSS section */
    bootstack = .;
    . += STACK_SIZE;
    bootstacktop = .;

    PROVIDE(edata = .);

    .bss : {
        *(.sbss)
        *(.sbss.*)
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }

    PROVIDE(ebss = .);

    end = .;

    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame)
        *(.note.GNU-stack)
    }
}
