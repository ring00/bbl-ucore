# BBL-uCore: uCore OS Labs on Berkeley Boot Loader

bbl-ucore is a porting of [ucore_os_lab](https://github.com/chyyuu/ucore_os_lab.git) to RISC-V architecture. It's built on top of the Berkeley Boot Loader, [`bbl`](https://github.com/riscv/riscv-pk.git), a supervisor execution environment for tethered RISC-V systems.

# Quickstart

## Installing riscv-tools

You'll need a forked verison of [riscv-tools](https://github.com/ring00/riscv-tools) to build the toolchain for RV32. Excute the following commands to get started quickly.

```bash
$ sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev
$ git clone https://github.com/ring00/riscv-tools.git
$ git submodule update --init --recursive
$ export RISCV=/path/to/install/riscv/toolchain
$ ./build-rv32g.sh
```
See [Installation Manual](https://github.com/ring00/riscv-tools#the-risc-v-gcc-toolchain-installation-manual) for details.

## Building bbl-ucore

```bash
$ git clone https://github.com/ring00/bbl-ucore.git
$ git submodule update --init --recursive
```

To build all projects at once, run the following commands

```bash
$ cd labcodes
$ ./gccbuildall.sh
```