# SmallOS
A tiny lil OS

Instructions:

Downloading source:
Download source and extract it somewhere, then simply run compile.sh, it will compile it and run QEMU

Downloading precompiled:
Move it somewhere and run:
qemu-system-x86_64 -drive file=os.img,format=raw,if=floppy

Note: The compile script requires NASM and Qemu, and also uses linux commands, so please do it in WSL if on windows.
