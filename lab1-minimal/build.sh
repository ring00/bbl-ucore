riscv32-unknown-linux-gnu-gcc -std=gnu99 -Wno-unused -fno-builtin -Wall -O2 -nostdinc  -fno-stack-protector -ffunction-sections -fdata-sections -c entry.S -o entry.o
riscv32-unknown-linux-gnu-gcc -std=gnu99 -Wno-unused -fno-builtin -Wall -O2 -nostdinc  -fno-stack-protector -ffunction-sections -fdata-sections -c init.c -o init.o
riscv32-unknown-linux-gnu-ld -m elf32lriscv -nostdlib --gc-sections -T kernel.ld -o kernel entry.o init2.o
cd ../riscv-pk
rm -rf build
mkdir build
cd build
../configure --prefix=$(RISCV) --host=riscv32-unknown-linux-gnu --with-payload=../../tests/kernel
make
cp bbl ../../tests/kernel.img