#ifndef __LIBS_ATOMIC_H__
#define __LIBS_ATOMIC_H__

#include "encoding.h"

// #define disable_irqsave() (0)
static inline bool disable_irqsave() {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        clear_csr(sstatus, SSTATUS_SIE);
        return 1;
    }
    return 0;
}

// #define enable_irqrestore(flags) ((void)(flags))
static inline void enable_irqrestore(bool flags) {
    if (flags) {
        set_csr(sstatus, SSTATUS_SIE);
    }
}

typedef struct { int lock; } spinlock_t;
#define SPINLOCK_INIT \
    { 0 }

#define mb() asm volatile("fence" ::: "memory")
#define atomic_set(ptr, val) (*(volatile typeof(*(ptr))*)(ptr) = val)
#define atomic_read(ptr) (*(volatile typeof(*(ptr))*)(ptr))

#ifdef __riscv_atomic
#define atomic_add(ptr, inc) __sync_fetch_and_add(ptr, inc)
#define atomic_or(ptr, inc) __sync_fetch_and_or(ptr, inc)
#define atomic_swap(ptr, swp) __sync_lock_test_and_set(ptr, swp)
#define atomic_cas(ptr, cmp, swp) __sync_val_compare_and_swap(ptr, cmp, swp)
#else
#define atomic_binop(ptr, inc, op)             \
    ({                                         \
        long flags = disable_irqsave();        \
        typeof(*(ptr)) res = atomic_read(ptr); \
        atomic_set(ptr, op);                   \
        enable_irqrestore(flags);              \
        res;                                   \
    })
#define atomic_add(ptr, inc) atomic_binop(ptr, inc, res + (inc))
#define atomic_or(ptr, inc) atomic_binop(ptr, inc, res | (inc))
#define atomic_swap(ptr, inc) atomic_binop(ptr, inc, (inc))
#define atomic_cas(ptr, cmp, swp)                               \
    ({                                                          \
        long flags = disable_irqsave();                         \
        typeof(*(ptr)) res = *(volatile typeof(*(ptr))*)(ptr);  \
        if (res == (cmp)) *(volatile typeof(ptr))(ptr) = (swp); \
        enable_irqrestore(flags);                               \
        res;                                                    \
    })
#endif

static inline int spinlock_trylock(spinlock_t* lock) {
    int res = atomic_swap(&lock->lock, -1);
    mb();
    return res;
}

static inline void spinlock_lock(spinlock_t* lock) {
    do {
        while (atomic_read(&lock->lock))
            ;
    } while (spinlock_trylock(lock));
}

static inline void spinlock_unlock(spinlock_t* lock) {
    mb();
    atomic_set(&lock->lock, 0);
}

static inline long spinlock_lock_irqsave(spinlock_t* lock) {
    long flags = disable_irqsave();
    spinlock_lock(lock);
    return flags;
}

static inline void spinlock_unlock_irqrestore(spinlock_t* lock, long flags) {
    spinlock_unlock(lock);
    enable_irqrestore(flags);
}

/* Atomic operations that C can't guarantee us. Useful for resource counting etc.. */

static inline void set_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline void clear_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline void change_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline bool test_bit(int nr, volatile void *addr) __attribute__((always_inline));

#define BITS_PER_LONG __riscv_xlen

#if (BITS_PER_LONG == 64)
#define __AMO(op) "amo" #op ".d"
#elif (BITS_PER_LONG == 32)
#define __AMO(op) "amo" #op ".w"
#else
#error "Unexpected BITS_PER_LONG"
#endif

#define BIT_MASK(nr) (1UL << ((nr) % BITS_PER_LONG))
#define BIT_WORD(nr) ((nr) / BITS_PER_LONG)

#define __op_bit(op, mod, nr, addr)                 \
    __asm__ __volatile__(__AMO(op) " zero, %1, %0"  \
                         : "+A"(addr[BIT_WORD(nr)]) \
                         : "r"(mod(BIT_MASK(nr))))

/* Bitmask modifiers */
#define __NOP(x) (x)
#define __NOT(x) (~(x))

/* *
 * set_bit - Atomically set a bit in memory
 * @nr:     the bit to set
 * @addr:   the address to start counting from
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile long *)addr));
}

/* *
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile long *)addr));
}

/* *
 * change_bit - Atomically toggle a bit in memory
 * @nr:     the bit to change
 * @addr:   the address to start counting from
 * */
static inline void
change_bit(int nr, volatile void *addr) {
    __op_bit(xor, __NOP, nr, ((volatile long *)addr));
}

/* *
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    return (((*(volatile long *)addr) >> nr) & 1);
}

#endif /* !__LIBS_ATOMIC_H__ */
