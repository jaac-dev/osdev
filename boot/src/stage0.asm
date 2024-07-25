org 0x7C00
bits 16

%define STACK_LOCATION 512 + 4096
%define STACK_SIZE 4096

_entry:
    ; Setup the data-segment selector.
    mov dx, 0x0000
    mov ds, dx

    ; Setup the stack.
    mov ax, STACK_LOCATION
    mov ss, ax
    mov sp, STACK_SIZE

    ; Set the video mode.
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Print a message.
    mov si, message
    mov dl, 0x00
    mov dh, 0x00
    call print_string

print_string:
_loop:
    lodsb

    cmp al, 0x00
    jz _loop_end

    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    inc dl

    mov ah, 0x09
    mov bh, 0x00
    mov bl, 0x0F
    mov cx, 0x0001

    int 0x10
    jmp _loop

_loop_end:
    ret



message: db "Hello, world!", 0

times 510-($-$$) db 0
dw 0xAA55