bits 16
org 0x1000

start:
    mov si, welcome
    call print

shell:
    mov si, prompt
    call print

    mov di, command
    call read_line

    mov si, command
    mov di, help_cmd
    call startswith
    cmp ax, 0
    je do_help

    mov si, command
    mov di, clear_cmd
    call startswith
    cmp ax, 0
    je do_clear

    mov si, command
    mov di, about_cmd
    call startswith
    cmp ax, 0
    je do_about

    mov si, command
    mov di, print_cmd
    call startswith
    cmp ax, 0
    je do_print

    mov si, command
    mov di, reboot_cmd
    call startswith
    cmp ax, 0
    je do_reboot

    mov si, unknown
    call print
    jmp shell

do_help:
    mov si, help_text
    call print
    jmp shell

do_clear:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    jmp shell

do_about:
    mov si, about_text
    call print
    mov si, newline
    call print
    jmp shell

do_print:
    mov si, command
    add si, 6

    call print

    mov si, newline
    call print

    jmp shell

do_reboot:
    int 0x19
    .hang:
        hlt
        jmp .hang
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

read_line:
    xor cx, cx
.key:
    xor ah, ah
    int 0x16

    cmp al, 13
    je .enter

    cmp al, 8
    je .backspace

    cmp cx, 255
    jae .key

    stosb
    inc cx

    mov ah, 0x0e
    int 0x10
    jmp .key

.backspace:
    cmp cx, 0
    je .key

    dec di
    dec cx

    mov ah, 0x0e
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    jmp .key

.enter:
    mov al, 0
    stosb

    mov si, newline
    call print
    ret

startswith:
.loop:
    mov al, [di]
    test al, al
    jz .equal

    mov bl, [si]
    cmp al, bl
    jne .not_equal

    inc si
    inc di
    jmp .loop

.equal:
    xor ax, ax
    ret

.not_equal:
    mov ax, 1
    ret

welcome db 'Welcome to SmallOS shell!', 13, 10, 0
prompt db 'SmallOS> ', 0
newline db 13, 10, 0
reboot_cmd db "reboot", 0
print_cmd db 'print ', 0
help_cmd db 'help', 0
clear_cmd db 'clear', 0
about_cmd db 'about', 0
help_text db 'Commands: help, clear, about, print <text>, reboot', 13, 10, 0
unknown db 'Unknown command. Try help.', 13, 10, 0
about_text db "SmallOS v1, A simple half vibe coded OS thats designed to be simple", 13, 10, 0
command times 256 db 0