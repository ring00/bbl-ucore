#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <clock.h>
#include <trap.h>
#include <x86.h>
#include <stdio.h>
#include <assert.h>
#include <console.h>
#include <kdebug.h>
#include <encoding.h>

#define TICK_NUM 100

static void print_ticks() {
    cprintf("%d ticks\n",TICK_NUM);
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}

/* *
 * Interrupt descriptor table:
 *
 * Must be built at run time because shifted function addresses can't
 * be represented in relocation records.
 * */
static struct gatedesc idt[256] = {{0}};

static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
     /* LAB1 YOUR CODE : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    // extern uintptr_t __vectors[];
    // int i = 0;
    // for (i = 0; i < 256; ++i) {
    //     SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    // }
    // // set the DPL of 0x80 to 3
    // SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);

    // lidt(&idt_pd);

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    // cprintf("stvec : %04x\n", read_csr(stvec));
    set_csr(sstatus, SSTATUS_SIE);
}

static const char *
trapname(int trapno) {
    static const char * const excnames[] = {
        "Divide error",
        "Debug",
        "Non-Maskable Interrupt",
        "Breakpoint",
        "Overflow",
        "BOUND Range Exceeded",
        "Invalid Opcode",
        "Device Not Available",
        "Double Fault",
        "Coprocessor Segment Overrun",
        "Invalid TSS",
        "Segment Not Present",
        "Stack Fault",
        "General Protection",
        "Page Fault",
        "(unknown trap)",
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
        return excnames[trapno];
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
        return "Hardware Interrupt";
    }
    return "(unknown trap)";
}

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
    // return (tf->tf_cs == (uint16_t)KERNEL_CS);
}

static const char *IA32flags[] = {
    "CF", NULL, "PF", NULL, "AF", NULL, "ZF", "SF",
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
    cprintf("trapframe at %p\n", tf);
    print_regs(tf->gpr);
    cprintf("  status   0x%08x\n", tf->status);
    cprintf("  epc      0x%08x\n", tf->epc);
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);

    // cprintf("trapframe at %p\n", tf);
    // print_regs(&tf->tf_regs);
    // cprintf("  ds   0x----%04x\n", tf->tf_ds);
    // cprintf("  es   0x----%04x\n", tf->tf_es);
    // cprintf("  fs   0x----%04x\n", tf->tf_fs);
    // cprintf("  gs   0x----%04x\n", tf->tf_gs);
    // cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
    // cprintf("  err  0x%08x\n", tf->tf_err);
    // cprintf("  eip  0x%08x\n", tf->tf_eip);
    // cprintf("  cs   0x----%04x\n", tf->tf_cs);
    // cprintf("  flag 0x%08x ", tf->tf_eflags);

    // int i, j;
    // for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
    //     if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
    //         cprintf("%s,", IA32flags[i]);
    //     }
    // }
    // cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);

    // if (!trap_in_kernel(tf)) {
    //     cprintf("  esp  0x%08x\n", tf->tf_esp);
    //     cprintf("  ss   0x----%04x\n", tf->tf_ss);
    // }
}

void print_regs(uintptr_t gpr[32]) {
    for (int i = 1; i < 32; ++i) {
        cprintf("  x%d  0x%08x\n", i, gpr[i]);
    }
}

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
    char c;

    // switch (tf->tf_trapno) {
    // case IRQ_OFFSET + IRQ_TIMER:
    //     /* LAB1 YOUR CODE : STEP 3 */
    //     /* handle the timer interrupt */
    //     /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
    //      * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
    //      * (3) Too Simple? Yes, I think so!
    //      */
    //     if (++ticks % TICK_NUM == 0) {
    //         print_ticks();
    //     }
    //     break;
    // case IRQ_OFFSET + IRQ_COM1:
    //     c = cons_getc();
    //     cprintf("serial [%03d] %c\n", c, c);
    //     break;
    // case IRQ_OFFSET + IRQ_KBD:
    //     c = cons_getc();
    //     cprintf("kbd [%03d] %c\n", c, c);
    //     break;
    // //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    // case T_SWITCH_TOU:
    // case T_SWITCH_TOK:
    //     panic("T_SWITCH_** ??\n");
    //     break;
    // case IRQ_OFFSET + IRQ_IDE1:
    // case IRQ_OFFSET + IRQ_IDE2:
    //     /* do nothing */
    //     break;
    // default:
    //     // in kernel, it must be a mistake
    //     if ((tf->tf_cs & 3) == 0) {
    //         print_trapframe(tf);
    //         panic("unexpected trap in kernel.\n");
    //     }
    // }
}

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
        case 0:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_SOFT:
            cprintf("Supervisor software interrupt\n");
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
            break;
        case 4:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_TIMER:
            // "All bits besides SSIP and USIP in the sip register are
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
            if (++ticks % TICK_NUM == 0) {
                print_ticks();
            }
            break;
        case IRQ_H_TIMER:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_TIMER:
            cprintf("Machine software interrupt\n");
            break;
        case 8:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_EXT:
            cprintf("Supervisor external interrupt\n");
            break;
        case IRQ_H_EXT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_EXT:
            cprintf("Machine software interrupt\n");
            break;
        default:
            print_trapframe(tf);
            break;
    }
}

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
        case CAUSE_MISALIGNED_FETCH:
            break;
        case CAUSE_FAULT_FETCH:
            break;
        case CAUSE_ILLEGAL_INSTRUCTION:
            break;
        case CAUSE_BREAKPOINT:
            break;
        case CAUSE_MISALIGNED_LOAD:
            break;
        case CAUSE_FAULT_LOAD:
            break;
        case CAUSE_MISALIGNED_STORE:
            break;
        case CAUSE_FAULT_STORE:
            break;
        case CAUSE_USER_ECALL:
            break;
        case CAUSE_SUPERVISOR_ECALL:
            break;
        case CAUSE_HYPERVISOR_ECALL:
            break;
        case CAUSE_MACHINE_ECALL:
            break;
        default:
            print_trapframe(tf);
                break;
    }
}

/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // cprintf("void trap(struct trapframe *tf);\n");
    // print_trapframe(tf);

    // the following line may be used in future to handle ecall from user mode
    // write_csr(mscratch, tf);

    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        trap_dispatch(tf);
    }
}

void debug(void) {
    cprintf("void debug(void)\n");
}
