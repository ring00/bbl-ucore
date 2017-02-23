# 实验一：系统软件启动过程

## 练习一

### ucore.img的生成

运行`make "V="`后输出类似如下内容可分为四个部分

#### 第一部分

```shell
- cc kern/init/init.c
  gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
- cc kern/libs/stdio.c
  gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o
- cc kern/libs/readline.c
  gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o
......
```

该部分将各个C文件编译为obj文件，主要编译选项有：

* `-m32` 生成32位环境下的目标
* `-ggdb`,`-gsatbs` 提供调试信息
* `-nostdinc` 不搜索当前环境下的标准头文件
* `-Ikern/libs`等 将文件夹加入头文件搜索路径

#### 第二部分

```shell
ld bin/kernel

ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/stdio.o obj/kern/libs/readline.o obj/kern/debug/panic.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/picirq.o obj/kern/driver/intr.o obj/kern/trap/trap.o obj/kern/trap/vectors.o obj/kern/trap/trapentry.o obj/kern/mm/pmm.o  obj/libs/string.o obj/libs/printfmt.o
```

该部分将上一步生成的obj文件链接到一起，产生`bin/kernel`文件

* `-m elf_i386` 模拟elf_i386连接器
* `-nostdlib` 不使用标准库
* `-T tools/kernel.ld` 使用kernel.ld中的配置链接文件

#### 第三部分

```shell
- cc boot/bootasm.S
  gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
- cc boot/bootmain.c
  gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
- cc tools/sign.c
  gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
  gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
```

编译BootLoader，并生成将BootLoader补齐到512字节的工具`bin/sign`

* `-Os` 提示编译器尽量减小目标码的体积

#### 第四部分

```shell
+ ld bin/bootblock
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
'obj/bootblock.out' size: 488 bytes
build 512 bytes boot sector: 'bin/bootblock' success!
dd if=/dev/zero of=bin/ucore.img count=10000
dd if=bin/bootblock of=bin/ucore.img conv=notrunc
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
```

* 将`bootasm.o`和`bootmain.o`链接到一起
    * `-N` 设置text和data部分可读可写，并且不对数据段进行对齐
    * `-e start` 将entry point设为start
    * `-Ttext 0x7C00` 将代码段的起始地址设为0x7C00
* 执行`bin/sign obj/bootblock.out bin/bootblock`生成512字节的bootblock
    * 不足510字节的部分补0
    * 最后两个字节设为`0x55 0xAA`作为signature
* 用dd生成一个空镜像，然后将bootblock和kernel按次序写入
    * `if=FILE` 从FILE读入数据
    * `of=FILE` 输出到FILE
    * `conv=notrunc` 不截断输出文件
    * `seek=1` 跳过输出开头的512个字节

### 主引导扇区

标准的MBR分区表结构为前466字节为代码段，紧跟64字节的分区表，最后两个字节为Boot Signature

实际上第511和512个字节分别为0x55和0xAA即可被BIOS读入内存中，实验过程如下

```shell
dd if=/dev/zero of=bootloader count=1
echo -ne "\x55\xaa" | dd seek=510 bs=1 of=bootloader
qemu-system-i386 bootloader
```

## 练习二
