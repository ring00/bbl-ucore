#ifndef __LIBS_X86_H__
#define __LIBS_X86_H__

#include <defs.h>
#include <../riscv/encoding.h>

#define do_div(n, base)                              \
    ({                                               \
        int __res;                                   \
        __res = ((unsigned long)n) % (unsigned)base; \
        n = ((unsigned long)n) / (unsigned)base;     \
        __res;                                       \
    })

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline uint8_t inb(uint16_t port) __attribute__((always_inline));
static inline uint16_t inw(uint16_t port) __attribute__((always_inline));
static inline void insl(uint32_t port, void *addr, int cnt) __attribute__((always_inline));
static inline void outb(uint16_t port, uint8_t data) __attribute__((always_inline));
static inline void outw(uint16_t port, uint16_t data) __attribute__((always_inline));
static inline void outsl(uint32_t port, const void *addr, int cnt) __attribute__((always_inline));
static inline uint32_t read_ebp(void) __attribute__((always_inline));
static inline void breakpoint(void) __attribute__((always_inline));
static inline uint32_t read_dr(unsigned regnum) __attribute__((always_inline));
static inline void write_dr(unsigned regnum, uint32_t value) __attribute__((always_inline));

/* Pseudo-descriptors used for LGDT, LLDT(not used) and LIDT instructions. */
struct pseudodesc {
    uint16_t pd_lim;        // Limit
    uintptr_t pd_base;      // Base address
} __attribute__ ((packed));

static inline void lidt(struct pseudodesc *pd) __attribute__((always_inline));
static inline void sti(void) __attribute__((always_inline));
static inline void cli(void) __attribute__((always_inline));
static inline void ltr(uint16_t sel) __attribute__((always_inline));
static inline uint32_t read_eflags(void) __attribute__((always_inline));
static inline void write_eflags(uint32_t eflags) __attribute__((always_inline));
static inline void lcr0(uintptr_t cr0) __attribute__((always_inline));
static inline void lcr3(uintptr_t cr3) __attribute__((always_inline));
static inline uintptr_t rcr0(void) __attribute__((always_inline));
static inline uintptr_t rcr1(void) __attribute__((always_inline));
static inline uintptr_t rcr2(void) __attribute__((always_inline));
static inline uintptr_t rcr3(void) __attribute__((always_inline));
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    return 0;
}

static inline uint16_t
inw(uint16_t port) {
    return 0;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {

}

static inline void
outb(uint16_t port, uint8_t data) {

}

static inline void
outw(uint16_t port, uint16_t data) {

}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {

}

static inline uint32_t
read_ebp(void) {
    return 0;
}

static inline void
breakpoint(void) {

}

static inline uint32_t
read_dr(unsigned regnum) {
    uint32_t value = 0;
    return value;
}

static void
write_dr(unsigned regnum, uint32_t value) {

}

static inline void
lidt(struct pseudodesc *pd) {

}

static inline void
sti(void) {
    set_csr(sstatus, SSTATUS_SIE);
}

static inline void
cli(void) {
    clear_csr(sstatus, SSTATUS_SIE);
}

static inline void
ltr(uint16_t sel) {

}

static inline uint32_t
read_eflags(void) {

}

static inline void
write_eflags(uint32_t eflags) {

}

static inline void
lcr0(uintptr_t cr0) {

}

static inline void
lcr3(uintptr_t cr3) {
#define PGSHIFT 12
    write_csr(sptbr, cr3 >> PGSHIFT);
}

static inline uintptr_t
rcr0(void) {
    return 0;
}

static inline uintptr_t
rcr1(void) {
    return 0;
}

static inline uintptr_t
rcr2(void) {
    return 0;
}

static inline uintptr_t
rcr3(void) {
    return 0;
}

static inline void
invlpg(void *addr) {

}

#endif /* !__LIBS_X86_H__ */

