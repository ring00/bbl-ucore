# Lab 1

lab 1的移植中，主要改动有以下几点

* I/O函数
  - `kern/driver/console.c`
* 中断处理例程
  - `kern/trap/`
* 时钟中断设置
  - `kern/driver/clock.c`

其中对中断处理例程和时钟中断做了较大改动

## I/O Functions

I/O部分的修改十分直观

```c
/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
  sbi_console_putchar((unsigned char)c);
}
```

## Interrupt Service Routine

### Setting Trap Entry

RISC-V中并无中断向量的概念，当发生中断时，硬件只负责将`pc`寄存器指向Interrupt Service Routine (ISR) 的入口处。ISR入口地址应当存放于`stvec`寄存器中，我们可以修改`idt_init`函数，在其中设置`stvec`寄存器

```c
/**
 * idt_init - initialize stvec to the entry points in kern/trap/trapentry.S
 */
void idt_init(void) {
  extern void __alltraps(void);
  // Set sscratch register to 0, indicating to exception vector that we are
  // presently executing in the kernel
  write_csr(sscratch, 0);
  // Set the exception vector address
  write_csr(stvec, &__alltraps);
  // enable interrupt
  set_csr(sstatus, SSTATUS_SIE);
}
```

将`sscratch`寄存器置0也许让人费解，我们会在lab 6中详细分析，这里是否置0其实并无影响。

### Data Structures

我们将中断帧对应的数据结构修改如下

```c
struct pushregs {
  uintptr_t zero;  // Hard-wired zero
  uintptr_t ra;    // Return address
  uintptr_t sp;    // Stack pointer
  uintptr_t gp;    // Global pointer
  uintptr_t tp;    // Thread pointer
  uintptr_t t0;    // Temporary
  uintptr_t t1;    // Temporary
  uintptr_t t2;    // Temporary
  uintptr_t s0;    // Saved register/frame pointer
  uintptr_t s1;    // Saved register
  uintptr_t a0;    // Function argument/return value
  uintptr_t a1;    // Function argument/return value
  uintptr_t a2;    // Function argument
  uintptr_t a3;    // Function argument
  uintptr_t a4;    // Function argument
  uintptr_t a5;    // Function argument
  uintptr_t a6;    // Function argument
  uintptr_t a7;    // Function argument
  uintptr_t s2;    // Saved register
  uintptr_t s3;    // Saved register
  uintptr_t s4;    // Saved register
  uintptr_t s5;    // Saved register
  uintptr_t s6;    // Saved register
  uintptr_t s7;    // Saved register
  uintptr_t s8;    // Saved register
  uintptr_t s9;    // Saved register
  uintptr_t s10;   // Saved register
  uintptr_t s11;   // Saved register
  uintptr_t t3;    // Temporary
  uintptr_t t4;    // Temporary
  uintptr_t t5;    // Temporary
  uintptr_t t6;    // Temporary
};
```

```c
struct trapframe {
  struct pushregs gpr;
  uintptr_t status;
  uintptr_t epc;
  uintptr_t badvaddr;
  uintptr_t cause;
};
```

### Trap Handling

我们定义了一些宏来帮助操作

```c
#if __riscv_xlen == 64
#define SLL32    sllw
#define STORE    sd
#define LOAD     ld
#define LWU      lwu
#define LOG_REGBYTES 3
#else
#define SLL32    sll
#define STORE    sw
#define LOAD     lw
#define LWU      lw
#define LOG_REGBYTES 2
#endif
#define REGBYTES (1 << LOG_REGBYTES)
```

ISR的主体并不复杂

```nasm
    .globl __alltraps
__alltraps:
    SAVE_ALL
    move  a0, sp
    jal trap
    .globl __trapret
__trapret:
    RESTORE_ALL
    # return from supervisor call
    sret
```

其中`SAVE_ALL`和`RESTORE_ALL`都是宏，分别定义如下

```nasm
    .macro SAVE_ALL
    # store sp in sscratch
    csrw sscratch, sp
    # provide room for trap frame
    addi sp, sp, -36 * REGBYTES
    # save x registers except x2 (sp)
    STORE  x1,1*REGBYTES(sp)
    STORE  x3,3*REGBYTES(sp)
    STORE  x4,4*REGBYTES(sp)
    STORE  x5,5*REGBYTES(sp)
    STORE  x6,6*REGBYTES(sp)
    STORE  x7,7*REGBYTES(sp)
    STORE  x8,8*REGBYTES(sp)
    STORE  x9,9*REGBYTES(sp)
    STORE  x10,10*REGBYTES(sp)
    STORE  x11,11*REGBYTES(sp)
    STORE  x12,12*REGBYTES(sp)
    STORE  x13,13*REGBYTES(sp)
    STORE  x14,14*REGBYTES(sp)
    STORE  x15,15*REGBYTES(sp)
    STORE  x16,16*REGBYTES(sp)
    STORE  x17,17*REGBYTES(sp)
    STORE  x18,18*REGBYTES(sp)
    STORE  x19,19*REGBYTES(sp)
    STORE  x20,20*REGBYTES(sp)
    STORE  x21,21*REGBYTES(sp)
    STORE  x22,22*REGBYTES(sp)
    STORE  x23,23*REGBYTES(sp)
    STORE  x24,24*REGBYTES(sp)
    STORE  x25,25*REGBYTES(sp)
    STORE  x26,26*REGBYTES(sp)
    STORE  x27,27*REGBYTES(sp)
    STORE  x28,28*REGBYTES(sp)
    STORE  x29,29*REGBYTES(sp)
    STORE  x30,30*REGBYTES(sp)
    STORE  x31,31*REGBYTES(sp)

    # get sp, sstatus, sepc, sbadvaddr, scause
    csrr s0, sscratch
    csrr s1, sstatus
    csrr s2, sepc
    csrr s3, sbadaddr
    csrr s4, scause
    # store sp, sstatus, sepc, sbadvaddr, scause
    STORE s0, 2*REGBYTES(sp)
    STORE s1, 32*REGBYTES(sp)
    STORE s2, 33*REGBYTES(sp)
    STORE s3, 34*REGBYTES(sp)
    STORE s4, 35*REGBYTES(sp)
    .endm
```

```nasm
    .macro RESTORE_ALL
    # sstatus and sepc may be changed in ISR
    LOAD s1, 32*REGBYTES(sp)
    LOAD s2, 33*REGBYTES(sp)
    csrw sstatus, s1
    csrw sepc, s2

    # restore x registers except x2 (sp)
    LOAD  x1,1*REGBYTES(sp)
    LOAD  x3,3*REGBYTES(sp)
    LOAD  x4,4*REGBYTES(sp)
    LOAD  x5,5*REGBYTES(sp)
    LOAD  x6,6*REGBYTES(sp)
    LOAD  x7,7*REGBYTES(sp)
    LOAD  x8,8*REGBYTES(sp)
    LOAD  x9,9*REGBYTES(sp)
    LOAD  x10,10*REGBYTES(sp)
    LOAD  x11,11*REGBYTES(sp)
    LOAD  x12,12*REGBYTES(sp)
    LOAD  x13,13*REGBYTES(sp)
    LOAD  x14,14*REGBYTES(sp)
    LOAD  x15,15*REGBYTES(sp)
    LOAD  x16,16*REGBYTES(sp)
    LOAD  x17,17*REGBYTES(sp)
    LOAD  x18,18*REGBYTES(sp)
    LOAD  x19,19*REGBYTES(sp)
    LOAD  x20,20*REGBYTES(sp)
    LOAD  x21,21*REGBYTES(sp)
    LOAD  x22,22*REGBYTES(sp)
    LOAD  x23,23*REGBYTES(sp)
    LOAD  x24,24*REGBYTES(sp)
    LOAD  x25,25*REGBYTES(sp)
    LOAD  x26,26*REGBYTES(sp)
    LOAD  x27,27*REGBYTES(sp)
    LOAD  x28,28*REGBYTES(sp)
    LOAD  x29,29*REGBYTES(sp)
    LOAD  x30,30*REGBYTES(sp)
    LOAD  x31,31*REGBYTES(sp)
    # restore sp last
    LOAD  x2,2*REGBYTES(sp)
    .endm
```

这两部分应该较容易理解，现在我们来看看`trap`函数的实现

```c
/**
 * trap - handles an exception/interrupt. If and when trap() returns, the code
 * in kern/trap/trapentry.S restores the old CPU state saved in the trapframe
 * and then uses the sret instruction to return from the exception.
 */
void trap(struct trapframe *tf) {
  // dispatch based on what type of trap occurred
  if ((intptr_t)tf->cause < 0) {
    // interrupts
    interrupt_handler(tf);
  } else {
    // exceptions
    exception_handler(tf);
  }
}
```

RISC-V ISA规定当`scause`的Most Significant Bit (MSB) 为0时表示exception，为1时表示interrupt，因此我们可以通过`(intptr_t)tf->cause`的符号快速判断trap的类型，接下来只需在`interrupt_handler`和`exception_handler`中做相应处理即可。

## Timer Interrupt

### Getting Time

我们首先要面对的问题是读取时间，我们在[Instruction Emulation](toolchain-overview.md)中已经提到过`rdtime`指令的细节，这里我们只关注kernel层面对时间的读取

```c
static inline uint64_t get_cycles(void) {
#if __riscv_xlen == 64
  uint64_t n;
  __asm__ __volatile__("rdtime %0" : "=r"(n));
  return n;
#else
  uint32_t lo, hi, tmp;
  __asm__ __volatile__(
      "1:\n"
      "rdtimeh %0\n"
      "rdtime %1\n"
      "rdtimeh %2\n"
      "bne %0, %2, 1b"
      : "=&r"(hi), "=&r"(lo), "=&r"(tmp));
  return ((uint64_t)hi << 32) | lo;
#endif
}
```

由于`mtime`为64位寄存器，在32位环境下的读取过程并不直观

1. 读取`mtime`的高32位到`hi`中
2. 读取`mtime`的低32位到`lo`中
3. 读取`mtime`的高32位到`tmp`中
4. 若`hi != tmp`，返回第1步
5. 将`hi`和`lo`拼接后返回

汇编中`1b`表示前一个label 1处，类似的，`1f`表示后一个label 1处。

### Clock Initialization

```c
static uint64_t timebase;
/* *
 * clock_init - initialize clock to interrupt 100 times per second
 * */
void clock_init(void) {
  // divided by 500 when using Spike (2MHz)
  // divided by 100 when using QEMU (10MHz)
  timebase = sbi_timebase() / 100;
  // initialize time counter 'ticks' to zero
  ticks = 0;

  clock_set_next_event();
  cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) {
  sbi_set_timer(get_cycles() + timebase);
}
```

`sbi_timebase`会返回CPU工作频率，由于我们需要100Hz的时钟，将返回值除以100即可得到两次时钟中断间隔的周期数。Spike模拟器虽然运行频率只有2MHz，但返回值也为10MHz，所以若使用Spike模拟器，建议除以500。

### Handling Timer Interrupt

> All bits besides SSIP and USIP in the sip register are read-only.
>
> — Privileged ISA Specification v1.9.1, 4.1.4

时钟中断的处理非常简单

```c
void interrupt_handler(struct trapframe *tf) {
  // remove MSB
  intptr_t cause = (tf->cause << 1) >> 1;
  switch (cause) {
    case IRQ_S_TIMER:
      clock_set_next_event();
      if (++ticks % TICK_NUM == 0) {
        print_ticks();
      }
      break;
    default:
      print_trapframe(tf);
      break;
  }
}
```

然而bbl中的底层实现却并不trivial，我们先来看看`sbi_set_timer`在bbl中调用的`mcall_set_timer`

```c
static uintptr_t mcall_set_timer(uint64_t when)
{
  *HLS()->timecmp = when;
  clear_csr(mip, MIP_STIP);
  set_csr(mie, MIP_MTIP);
  return 0;
}
```

该函数先将`mtimecmp`寄存器设置为用户给定的时间，然后清空`mip`中的Supervisor Timer Interrupt Pending Bit (STIP)，设置`mie`中的Machine Timer Interrupt Enable Bit (MTIE，与MTIP位置相同) 以使能M-mode下的时钟中断。发生时钟中断时，会由bbl中的ISR处理，并一步步转发到`timer_interrupt`函数中

```c
uintptr_t timer_interrupt()
{
  // just send the timer interrupt to the supervisor
  clear_csr(mie, MIP_MTIP);
  set_csr(mip, MIP_STIP);

  // and poll the HTIF console
  htif_interrupt();

  return 0;
}
```

首先清空`mie`中的Machine Timer Interrupt Enable Bit，然后设置`mip`中的Supervisor Timer Interrupt Pending Bit (STIP)，返回S-mode后，由于`sip`寄存器中STIP被置为1，立即引发一个时钟中断。在ISR中，我们调用的`clock_set_next_event`会调用`sbi_set_timer`并被bbl中的`mcall_set_timer`处理，从而清空`sip`中的STIP位，又回到了开始的状态。

以上对时钟中断的处理流程和Spike模拟器的undocumented feature耦合十分紧密，处理SEE和模拟器层的读者应特别注意。



## 附录

编译最新的riscv-pk, qemu, 

### 0. install gcc for rv32

参看 [[toolchain-overview.md]]

### 1. setenv

```
export RISCV=/chydata/thecode/riscv-related/install-rv32
export PATH=$RISCV/bin:$PATH
```

### 2. build qemu

```
git clone https://github.com/riscv/riscv-qemu.git
cd riscv-qemu
./configure --target-list=riscv32-softmmu
make
cp riscv32-softmmu/qemu-system-riscv32 /chydata/thecode/riscv-related/install-rv32/bin
```

### 3. build bbl

```
git clone https://github.com/riscv/riscv-pk.git
cd riscv-pk
mkdir build
cd build
../configure \
    --enable-logo \
    --enable-print-device-tree \
    --host=riscv32-unknown-elf \
    --with-payload=../../../ucore-lab1-rv32
make
```

### 4. run qemu

当前qemu支持的riscv 开发板有：

```
qemu-system-riscv32 -machine help
Supported machines are:
none                 empty machine
sifive_e300          RISC-V Board compatible with SiFive E300 SDK
sifive_u500          RISC-V Board compatible with SiFive U500 SDK
spike_v1.10          RISC-V Spike Board (Privileged ISA v1.10)
spike_v1.9           RISC-V Spike Board (Privileged ISA v1.9.1) (default)
virt                 RISC-V VirtIO Board (Privileged spec v1.10)
```

执行

```
qemu-system-riscv32 -nographic -machine virt -kernel bbl
```

能看到logo和bbl输出的device tree

```
              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    
rr                vvvvvvvvvvvvvvvvvvvvvv      
rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr
rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr
rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr
rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr
rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr
rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr
rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr
rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr

       INSTRUCTION SETS WANT TO BE FREE
 {
  #address-cells = <0x00000002>;
  #size-cells = <0x00000002>;
  compatible = "riscv-virtio";
  model = "riscv-virtio,qemu";
  chosen {
    bootargs = "";
    stdout-path = <0x2f756172 0x74403130 0x30303030>;
  }
  uart@10000000 {
    interrupts = <0x0000000a>;
    interrupt-parent = <0x00000002>;
    clock-frequency = <0x00384000>;
    reg = <0x00000000 0x10000000 0x00000000 0x00000100>;
    compatible = "ns16550a";
  }
....
```



### Flattened Device Tree (FDT)

Device Tree是一种描述硬件的数据结构，它起源于 OpenFirmware (OF)。在Linux 2.6中，ARM架构的板极硬件细节过多地被硬编码在arch/arm/plat-xxx和arch/arm/mach-xxx，采用Device Tree后，许多硬件的细节可以直接透过它传递给OS kernel，而不再需要在kernel中进行大量的冗余编码。
Device Tree由一系列被命名的结点（node）和属性（property）组成，而结点本身可包含子结点。所谓属性，其实就是成对出现的name和value。在Device Tree中，可描述的信息包括：

- CPU的数量和类别
- 内存基地址和大小
- 总线和桥外设连接
- 中断控制器和中断使用情况
- GPIO控制器和GPIO使用情况
- Clock控制器和Clock使用情况

它基本上就是画一棵电路板上CPU、总线、设备组成的树，Bootloader会将这棵树传递给内核，然后内核可以识别这棵树，并根据它展开出内核中的platform_device、i2c_client、spi_device等设备，而这些设备用到的内存、IRQ等资源，也被传递给了内核，内核会将这些资源绑定给展开的相应的设备。



参考

- [ARM Linux 3.x的设备树（Device Tree）](http://www.cnblogs.com/wi100sh/p/4597898.html)
- http://www.wowotech.net/linux_kenrel/dt_basic_concept.html



### BIOS in RISC-V

```
位于0x1000处的BIOS代码
/* reset vector */
    uint32_t reset_vec[8] = {
        0x00000297,                  /* 1:  auipc  t0, %pcrel_hi(dtb) */
        0x02028593,                  /*     addi   a1, t0, %pcrel_lo(1b) */
        0xf1402573,                  /*     csrr   a0, mhartid  */
#if defined(TARGET_RISCV32)
        0x0182a283,                  /*     lw     t0, 24(t0) */
#elif defined(TARGET_RISCV64)
        0x0182b283,                  /*     ld     t0, 24(t0) */
#endif
        0x00028067,                  /*     jr     t0 */
        0x00000000,
        memmap[VIRT_DRAM].base,      /* start: .dword memmap[VIRT_DRAM].base */
        0x00000000,
                                     /* dtb: */
    };
    接下来的内容是Device Tree Binary的内容，包括CPU/MEM/UART/INTR等
    
在 gdb中看到的代码如下：
(gdb) x/10i 0x1000
=> 0x1000:	auipc	t0,0x0
   0x1004:	addi	a1,t0,32
   0x1008:	csrr	a0,mhartid
   0x100c:	lw	t0,24(t0)
   0x1010:	jr	t0
   0x1014:	unimp
   0x1016:	unimp
   0x1018:	unimp
   0x101a:	0x8000
   0x101c:	unimp
当执行到0x1010时， t0=0x80000000 即bbl被加载到的起始地址，此时a0=0, a1=0x1020 即dtb的起始地址
```

在qemu-system-riscv32模拟的virt board的dbt的内容是：

```
/dts-v1/;
// magic:		0xd00dfeed
// totalsize:		0x10000 (65536)
// off_dt_struct:	0x40
// off_dt_strings:	0x848
// off_mem_rsvmap:	0x30
// version:		17
// last_comp_version:	16
// boot_cpuid_phys:	0x0
// size_dt_strings:	0x129
// size_dt_struct:	0x808

/ {
    #address-cells = <0x00000002>;
    #size-cells = <0x00000002>;
    compatible = "riscv-virtio";
    model = "riscv-virtio,qemu";
    chosen {
        bootargs = [00];
        stdout-path = "/uart@10000000";
    };
    uart@10000000 {
        interrupts = <0x0000000a>;
        interrupt-parent = <0x00000002>;
        clock-frequency = <0x00384000>;
        reg = <0x00000000 0x10000000 0x00000000 0x00000100>;
        compatible = "ns16550a";
    };
    virtio_mmio@10008000 {
        interrupts = <0x00000008>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10008000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10007000 {
        interrupts = <0x00000007>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10007000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10006000 {
        interrupts = <0x00000006>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10006000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10005000 {
        interrupts = <0x00000005>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10005000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10004000 {
        interrupts = <0x00000004>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10004000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10003000 {
        interrupts = <0x00000003>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10003000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10002000 {
        interrupts = <0x00000002>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10002000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    virtio_mmio@10001000 {
        interrupts = <0x00000001>;
        interrupt-parent = <0x00000002>;
        reg = <0x00000000 0x10001000 0x00000000 0x00001000>;
        compatible = "virtio,mmio";
    };
    cpus {
        #address-cells = <0x00000001>;
        #size-cells = <0x00000000>;
        timebase-frequency = <0x00989680>;
        cpu@0 {
            device_type = "cpu";
            reg = <0x00000000>;
            status = "okay";
            compatible = "riscv";
            riscv,isa = "rv32imafdc";
            mmu-type = "riscv,sv48";
            clock-frequency = <0x3b9aca00>;
            interrupt-controller {
                #interrupt-cells = <0x00000001>;
                interrupt-controller;
                compatible = "riscv,cpu-intc";
                linux,phandle = <0x00000001>;
                phandle = <0x00000001>;
            };
        };
    };
    memory@80000000 {
        device_type = "memory";
        reg = <0x00000000 0x80000000 0x00000000 0x08000000>;
    };
    soc {
        #address-cells = <0x00000002>;
        #size-cells = <0x00000002>;
        compatible = "riscv-virtio-soc";
        ranges;
        interrupt-controller@c000000 {
            linux,phandle = <0x00000002>;
            phandle = <0x00000002>;
            riscv,ndev = <0x0000000a>;
            riscv,max-priority = <0x00000007>;
            reg-names = "control";
            reg = <0x00000000 0x0c000000 0x00000000 0x04000000>;
            interrupts-extended = <0x00000001 0x0000000b 0x00000001 0x00000009>;
            interrupt-controller;
            compatible = "riscv,plic0";
            #interrupt-cells = <0x00000001>;
        };
        clint@2000000 {
            interrupts-extended = <0x00000001 0x00000003 0x00000001 0x00000007>;
            reg = <0x00000000 0x02000000 0x00000000 0x00010000>;
            compatible = "riscv,clint0";
        };
    };
};
```

可以用如下命令得到：

```
$ qemu-system-riscv32  -nographic -machine virt,dumpdtb=virt.out
$ fdtdump virt.out
```



### Bootloader in RISC-V

1. 从bios中得到 mhartid in a0, dtb addr in a1， call init_first_hart() //mentry.S

2. 根据dtb，调用qeury_uart16660()获得 uart 硬件信息  //minit.c

3. hart_init()进一步调用 mstatus_init(), fp_init(), delegate_traps() 完成初步硬件初始化 //minit.c

   - mstatus_init:  Enable software interrupts,  Disable paging 
   - delegate_traps:  send S-mode interrupts and most exceptions straight to S-mode

   ​       IRQ包括：IRQ_S_SOFT ，IRQ_S_TIMER， IRQ_S_EXT

   ​       Execption包括：MISALIGNED_FETCH， FETCH_PAGE_FAULT，BREAKPOINT，LOAD/STORE_PAGE_FAULT，USER_ECALL

4. hls_init(0)：好像是对multi core的自己core做一些准备
5. qeury_mem(dtb)：获得内存配置 base=0x80000000 size=128MB
6. query_harts(dtb):查询其他cpu core
7. query_clint(dtb):查询local interrupt  CLINT：Core Local Interruptor
8. query_plic(dtb): 查询平台级的中断控制器 PLIC:Platform Level Interrupt Controller
9. wake_harts(): 唤醒其他cpu cores
10. plic_init, hart_plic_init, 初始化平台级的中断控制器
11. memory_init(): 设置mem_size，保证页对齐。
12. boot_loader(dtb) : call  enter_supervisor_mode(entry, hartid, dtb_output()); 跳到kernel处执行 //bbl.c
13. enter_supervisor_mode: 设置PMP，设置 mstatus的MPP为PRV_S， MPIE为0, mscratch= MACHINE_STACK_TOP() - MENTRY_FRAME_SIZE, mepc=kernel entry, a0= hartid, a1=dtb addr 输出位置 在payload_end的后面的4MB页对齐处，为返回S mode做好设置, 执行 mret，返回到PRV态的kernel 入口处  //minit.c

