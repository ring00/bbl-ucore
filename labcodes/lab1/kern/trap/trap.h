#ifndef __KERN_TRAP_TRAP_H__
#define __KERN_TRAP_TRAP_H__

#include <defs.h>

/* Trap Numbers */

/* Processor-defined: */
#define T_DIVIDE                0    // divide error
#define T_DEBUG                    1    // debug exception
#define T_NMI                    2    // non-maskable interrupt
#define T_BRKPT                    3    // breakpoint
#define T_OFLOW                    4    // overflow
#define T_BOUND                    5    // bounds check
#define T_ILLOP                    6    // illegal opcode
#define T_DEVICE                7    // device not available
#define T_DBLFLT                8    // double fault
// #define T_COPROC                9    // reserved (not used since 486)
#define T_TSS                    10    // invalid task switch segment
#define T_SEGNP                    11    // segment not present
#define T_STACK                    12    // stack exception
#define T_GPFLT                    13    // general protection fault
#define T_PGFLT                    14    // page fault
// #define T_RES                15    // reserved
#define T_FPERR                    16    // floating point error
#define T_ALIGN                    17    // aligment check
#define T_MCHK                    18    // machine check
#define T_SIMDERR                19    // SIMD floating point error

#define T_SYSCALL               0x80 // SYSCALL, ONLY FOR THIS PROJ

/* Hardware IRQ numbers. We receive these as (IRQ_OFFSET + IRQ_xx) */
#define IRQ_OFFSET                32    // IRQ 0 corresponds to int IRQ_OFFSET

#define IRQ_TIMER                0
#define IRQ_KBD                    1
#define IRQ_COM1                4
#define IRQ_IDE1                14
#define IRQ_IDE2                15
#define IRQ_ERROR                19
#define IRQ_SPURIOUS                31

/* *
 * These are arbitrarily chosen, but with care not to overlap
 * processor defined exceptions or interrupt vectors.
 * */
#define T_SWITCH_TOU                120    // user/kernel switch
#define T_SWITCH_TOK                121    // user/kernel switch

struct trapframe {
    uintptr_t gpr[32];
    uintptr_t status;
    uintptr_t epc;
    uintptr_t badvaddr;
    uintptr_t cause;
};

void trap(struct trapframe *tf);
void idt_init(void);
void print_trapframe(struct trapframe *tf);
void print_regs(uintptr_t gpr[32]);
bool trap_in_kernel(struct trapframe *tf);

void debug(void);

#endif /* !__KERN_TRAP_TRAP_H__ */

