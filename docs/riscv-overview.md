# RISC-V Overview

RISC-V是发源于Berkeley的开源instruction set architecture (ISA)。在继续阅读前，建议读者仔细阅读RISC-V的Specifications

* [User-Level ISA Specification v2.1](https://riscv.org/specifications/)
* [Draft Privileged ISA Specification v1.9.1](https://riscv.org/specifications/privileged-isa)

## Modular ISA

RISC-V ISA是模块化的，它由一个基本指令集和一些扩展指令集组成

* Base integer ISAa
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
