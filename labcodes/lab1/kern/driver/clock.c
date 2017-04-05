#include <x86.h>
#include <trap.h>
#include <stdio.h>
#include <picirq.h>
#include <sbi.h>

/* *
 * Support for time-related hardware gadgets - the 8253 timer,
 * which generates interruptes on IRQ-0.
 * */

#define IO_TIMER1           0x040               // 8253 Timer #1

/* *
 * Frequency of all three count-down timers; (TIMER_FREQ/freq)
 * is the appropriate count to generate a frequency of freq Hz.
 * */

#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ + (x) / 2) / (x))

#define TIMER_MODE      (IO_TIMER1 + 3)         // timer mode port
#define TIMER_SEL0      0x00                    // select counter 0
#define TIMER_RATEGEN   0x04                    // mode 2, rate generator
#define TIMER_16BIT     0x30                    // r/w counter 16 bits, LSB first

volatile size_t ticks;

static inline uint64_t get_cycles(void)
{
#if __riscv_xlen == 64
	uint64_t n;
	__asm__ __volatile__ (
		"rdtime %0"
		: "=r" (n));
	return n;
#else
	uint32_t lo, hi, tmp;
	__asm__ __volatile__ (
		"1:\n"
		"rdtimeh %0\n"
		"rdtime %1\n"
		"rdtimeh %2\n"
		"bne %0, %2, 1b"
		: "=&r" (hi), "=&r" (lo), "=&r" (tmp));
	return ((uint64_t)hi << 32) | lo;
#endif
}

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
    // set 8253 timer-chip
    // outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    // outb(IO_TIMER1, TIMER_DIV(100) % 256);
    // outb(IO_TIMER1, TIMER_DIV(100) / 256);
    cprintf("sstatus = %04x\n", read_csr(sstatus));
	cprintf("sie = %04x\n", read_csr(sie));
	cprintf("sip = %04x\n", read_csr(sip));
	cprintf("get_cycles() = %08llu\n", get_cycles());
	cprintf("get_cycles() = %08llu\n", get_cycles());
	cprintf("get_cycles() = %08llu\n", get_cycles());
	cprintf("get_cycles() = %08llu\n", get_cycles());



	sbi_set_timer(get_cycles() + 0x100000UL);

	cprintf("sie = %04x\n", read_csr(sie));
	cprintf("sip = %04x\n", read_csr(sip));
    // initialize time counter 'ticks' to zero
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
    // pic_enable(IRQ_TIMER);
}

void clock_set_next_event(void) {
	sbi_set_timer(get_cycles() + 0x100000UL);
}
