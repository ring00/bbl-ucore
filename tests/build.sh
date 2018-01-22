riscv32-unknown-elf-gcc -std=gnu99 -Wno-unused -fno-builtin -Wall -O2 -nostdinc  -fno-stack-protector -ffunction-sections -fdata-sections -c entry.S -o entry.o
riscv32-unknown-elf-gcc -std=gnu99 -Wno-unused -fno-builtin -Wall -O2 -nostdinc  -fno-stack-protector -ffunction-sections -fdata-sections -c init2.c -o init2.o
riscv32-unknown-elf-ld -m elf32lriscv -nostdlib --gc-sections -T kernel.ld -o kernel entry.o init2.o
