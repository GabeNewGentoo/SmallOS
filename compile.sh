nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
cat boot.bin kernel.bin > os.img
qemu-system-x86_64 -drive file=os.img,format=raw,if=floppy
