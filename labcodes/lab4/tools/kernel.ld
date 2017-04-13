/* Simple linker script for the JOS kernel.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_ARCH(riscv)
ENTRY(_start)

BASE_ADDRESS = 0xC0000000;
STACK_SIZE = 0x2000;

SECTIONS
{
    /* Load the kernel at this address: "." means the current address */
    . = BASE_ADDRESS;

    .text : {
        *(.text._start)
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

    PROVIDE(edata = .);

    .bss : {
        *(.sbss)
        *(.sbss.*)
        *(.bss)
        *(.bss.*)
        *(COMMON)
    }
/*    .bss : {
        *(.bss)
    }*/
    PROVIDE(ebss = .);

    /* Stack */
    bootstack = .;
    . += STACK_SIZE;
    bootstacktop = .; 

    end = .;

    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame)
        *(.note.GNU-stack)
    }
}