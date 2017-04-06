/* Simple linker script for the JOS kernel.
   See the GNU ld 'info' manual ("info ld") to learn the syntax. */

OUTPUT_ARCH(riscv)
ENTRY(reset_vector)

SECTIONS
{
    /*--------------------------------------------------------------------*/
    /* Code and read-only segment                                         */
    /*--------------------------------------------------------------------*/

    /* Begining of code and text segment */
    . = 0x80000000;
    _ftext = .;

    .text :
    {
        *(.text.init)
    }

    /* text: Program code section */
    .text : 
    {
        *(.text)
        *(.text.*)
        *(.gnu.linkonce.t.*)
    }

    /* rodata: Read-only data */
    .rodata : 
    {
        *(.rdata)
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
    }

    /* End of code and read-only segment */
    PROVIDE(etext = .);
    _etext = .;

    /*--------------------------------------------------------------------*/
    /* HTIF, isolated onto separate page                                  */
    /*--------------------------------------------------------------------*/
    . = ALIGN(0x1000);
    htif :
    {
        *(htif)
    }
    . = ALIGN(0x1000);

    /*--------------------------------------------------------------------*/
    /* Include debugging information in kernel memory                     */
    /*--------------------------------------------------------------------*/
    .stab : {
        PROVIDE(__STAB_BEGIN__ = .);
        *(.stab);
        PROVIDE(__STAB_END__ = .);
        BYTE(0) /* Force the linker to allocate space for this section */
    }

    .stabstr : {
        PROVIDE(__STABSTR_BEGIN__ = .);
        *(.stabstr);
        PROVIDE(__STABSTR_END__ = .);
        BYTE(0) /* Force the linker to allocate space for this section */
    }

    /*--------------------------------------------------------------------*/
    /* Initialized data segment                                           */
    /*--------------------------------------------------------------------*/

    /* Start of initialized data segment */
    . = ALIGN(0x1000);
    _fdata = .;

    /* data: Writable data */
    .data : 
    {
        *(.data)
        *(.data.*)
        *(.srodata*)
        *(.gnu.linkonce.d.*)
        *(.comment)
    }

    /* End of initialized data segment */
    . = ALIGN(4);
    PROVIDE(edata = .);
    _edata = .;

    /*--------------------------------------------------------------------*/
    /* Uninitialized data segment                                         */
    /*--------------------------------------------------------------------*/

    /* Start of uninitialized data segment */
    . = .;
    _fbss = .;

    /* sbss: Uninitialized writeable small data section */
    . = .;

    /* bss: Uninitialized writeable data section */
    . = .;
    _bss_start = .;
    .bss : 
    {
        *(.bss)
        *(.bss.*)
        *(.sbss*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
    }
    PROVIDE(ebss = .);

    .sbi :
    {
        *(.sbi)
    }

    . = ALIGN(0x1000);
    _machine_estack = .;
    . += 0x1000;
    _machine_stack = .;
    . = ALIGN(0x1000);

    . = ALIGN(0x1000);
    bootstack = .;
    . += 0x2000;
    bootstacktop = .;
    . = ALIGN(0x1000);

    PROVIDE(end = .);
    _end = .;
}
