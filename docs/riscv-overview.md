# RISC-V Overview

RISC-V是发源于Berkeley的开源instruction set architecture (ISA)。在继续阅读前，建议读者仔细阅读RISC-V的Specifications

* [User-Level ISA Specification v2.1](https://riscv.org/specifications/)
* [Draft Privileged ISA Specification v1.9.1](https://riscv.org/specifications/privileged-isa)

## Modular ISA

RISC-V ISA是模块化的，它由一个基本指令集和一些扩展指令集组成

* Base integer ISAs
    - RV32I
    - RV64I
    - RV128I
* Standard extensions
    - M: Integer **M**ultiply
    - A: **A**tomic Memory Operations
    - F: Single-percison **F**loating-point
    - D: **D**ouble-precision Floating-point
    - G: IMAFD, **G**eneral Purpose ISA

举例来说，`RV32IMA`表示支持基本整数操作和原子操作的32位RISC-V指令集。

## Privileged ISA

### Software Stacks

RISC-V在设计时就考虑了虚拟化的需求，三种典型RISC-V系统的结构如下

![software-stacks](_images/software-stacks.png)

上图中各个英文缩写对应的全称如下

* ABI: Application Binary Interface
* AEE: Application Execution Environment
* SBI: Supervisor Binary Interface
* SEE: Supervisor Execution Environment
* HBI: Hypervisor Binary Interface
* HEE: Hypervisor Execution Environment

RISC-V通过各层之间的Binary Interface实现了对下一层的抽象，方便了虚拟机的实现以及OS在不同RISC-V架构间的移植。[bbl-ucore](https://github.com/ring00/bbl-ucore)采用了图中第二种结构，[bbl](https://github.com/riscv/riscv-pk)在其中充当了SEE的角色。

### Privilege Levels

RISC-V共有4种不同的特权级，与x86不同的是，RISC-V中特权级对应数字越小，权限越低

| Level | Encoding |       Name       | Abbreviation |
| :---: | :------: | :--------------: | :----------: |
|   0   |    00    | User/Application |      U       |
|   1   |    01    |    Supervisor    |      S       |
|   2   |    10    |    Hypervisor    |      H       |
|   3   |    11    |     Machine      |      M       |

一个RISC-V的实现并不要求同时支持这四种特权级，可接受的特权级组合如下

| Number of levels | Supported Modes | Intended Usage                           |
| :--------------: | --------------- | ---------------------------------------- |
|        1         | M               | Simple embedded systems                  |
|        2         | M, U            | Secure embedded systems                  |
|        3         | M, S, U         | Systems running Unix-like operating systems |
|        4         | M, H, S, U      | Systems running Type-1 hypervisors       |

目前官方的[Spike](https://github.com/riscv/riscv-isa-sim)模拟器只部分实现了3个特权级。

### Control and Status Registers

RISC-V中各个特权级都有单独的Control and Status Registers (CSRs)，其中应当注意的有以下几个

| Name     | Description                              |
| -------- | ---------------------------------------- |
| sstatus  | Supervisor status register               |
| sie      | Supervisor interrupt-enable register     |
| stvec    | Supervisor trap handler base address     |
| sscratch | Scratch register for supervisor trap handlers |
| sepc     | Supervisor exception program counter     |
| scause   | Supervisor trap cause                    |
| sbadaddr | Supervisor bad address                   |
| sip      | Supervisor interrupt pending             |
| sptbr    | Page-table base register                 |
| mstatus  | Machine status register                  |
| medeleg  | Machine exception delegation register    |
| mideleg  | Machine interrupt delegation register    |
| mie      | Machine interrupt-enable register        |
| mtvec    | Machine trap-handler base address        |
| mscratch | Scratch register for machine trap handlers |
| mepc     | Machine exception program counter        |
| mcause   | Machine trap cause                       |
| mbadaddr | Machine bad address                      |
| mip      | Machine interrupt pending                |

在继续阅读前，读者应当查阅[Privileged Spec 1.9.1](https://riscv.org/specifications/privileged-isa)以熟悉以上CSR的功能和用途。

#### CSR Instructions

RISC-V ISA中提供了一些修改CSR的原子操作，下面介绍之后常用到的`csrrw`指令

```nasm
# Atomic Read & Write Bit
cssrw rd, csr, rs
```

语义上等价的C++函数如下

```cpp
void cssrw(unsigned int& rd, unsigned int& csr, unsigned int& rs) {
  unsigned int tmp = rs;
  rd = csr;
  csr = tmp;
}
```

几种有趣的用法如下

```nasm
# csr = rs
cssrw x0, csr, rs

# csr = 0
cssrw x0, csr, x0

# rd = csr, csr = 0
cssrw rd, csr, x0

# swap rd and csr
cssrw rd, csr, rd
```

## Calling Convention

The RISC-V calling convention passes arguments in registers when possible. Up to eight integer registers, a0–a7, and up to eight floating-point registers, fa0–fa7, are used for this purpose.

If the arguments to a function are conceptualized as fields of a C struct, each with pointer alignment, the argument registers are a shadow of the first eight pointer-words of that struct.If argument i< 8 is a floating-point type, it is passed in floating-point register fai; otherwise, it is passed in integer register ai. However, floating-point arguments that are part of unions or array fields of structures are passed in integer registers. Additionally, floating-point arguments to variadic functions (except those that are explicitly named in the parameter list) are passed in integer registers.

Arguments smaller than a pointer-word are passed in the least-significant bits of argument registers. Correspondingly, sub-pointer-word arguments passed on the stack appear in the lower addresses of a pointer-word, since RISC-V has a little-endian memory system.

When primitive arguments twice the size of a pointer-word are passed on the stack, they are naturally aligned. When they are passed in the integer registers, they reside in an aligned even-odd register pair, with the even register holding the least-significant bits. In RV32, for example, the function void foo(int, long long) is passed its first argument in a0 and its second in a2 and a3. Nothing is passed in a1.

Arguments more than twice the size of a pointer-word are passed by reference.

The portion of the conceptual struct that is not passed in argument registers is passed on the stack. The stack pointer sp points to the first argument not passed in a register.

Values are returned from functions in integer registers a0 and a1 and floating-point registers fa0 and fa1. Other return values that fit into two pointer-words are returned in a0 and a1. Larger return values are passed entirely in memory; the caller allocates this memory region and passes a pointer to it as an implicit first parameter to the callee.

In the standard RISC-V calling convention, the stack grows downward and the stack pointer is always kept 16-byte aligned.

In addition to the argument and return value registers, seven integer registers t0–t6 and twelve floating-point registers ft0–ft11 are temporary registers that are volatile across calls and must be saved by the caller if later used. Twelve integer registers s0–s11 and twelve floating-point registers fs0–fs11 are preserved across calls and must be saved by the callee if used.

## DEVICE

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

