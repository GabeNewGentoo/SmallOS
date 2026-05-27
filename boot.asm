bits 16
org 0x7c00

KERNEL_OFFSET equ 0x1000
KERNEL_SECTORS equ 4

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [BOOT_DRIVE], dl

    mov si, loading_msg
    call print

    xor ax, ax
    mov es, ax

    mov ah, 0x02
    mov al, KERNEL_SECTORS
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]
    mov bx, KERNEL_OFFSET
    int 0x13

    jc disk_error

    jmp KERNEL_OFFSET

disk_error:
    mov si, diskerrormsg
    call print
    jmp $
print:
    mov ah, 0x0e
.next:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .next
.done:
    ret

BOOT_DRIVE db 0

loading_msg db 'Loading SmallOS...', 13, 10, 0
diskerrormsg db 'Unknown disk error occurred, cannot boot', 13, 10, 0

times 510-($ - $$) db 0
dw 0xaa55