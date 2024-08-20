org 0x7C00
bits 16

; Entrypoint
_start:
  jmp	0x0000:start16
  times 8-($-$$) db 0

; Boot Information Table
bit:
  .primary_volume_descriptor:  resd  1    ; LBA of the Primary Volume Descriptor
  .boot_file_location:         resd  1    ; LBA of the Boot File
  .boot_file_length:           resd  1    ; Length of the boot file in bytes
  .checksum:                   resd  1    ; 32 bit checksum
  .reserved:                   resb  40   ; Reserved 'for future standardization'

; 16-bit Entrypoint
start16:
    cli
    cld

    mov byte [drive_number], dl

    ; Setup data-segment.
    xor si, si
    mov ds, si
    mov es, si
    mov gs, si
    mov ss, si

    ; Setup the stack.
    mov sp, 0x7c00
    mov bp, sp
    sti

    ; Setup the video mode.
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Load next segments.
    mov eax, [bit.boot_file_location]
    add eax, 1
    mov dword [read_2k_sectors_lba], eax
    push 0x0000
    push 0x8400
    mov al, [drive_number]
    push ax

    mov eax, [bit.boot_file_length]
    mov ebx, 2048
    div ebx
    push eax
    call read_2k_sectors
    add sp, 8

    push hello_message
    call print
    add sp, 2

  .1:
    hlt
    jmp .1

    ; Load GDT, enter protected mode.
    lgdt [gdt]

    cli

    mov eax, cr0
    or al, 1
    mov cr0, eax

    in al, 0x92
    or al, 2
    out 0x92, al

    jmp 0x0000:start32

;
;  Prints a message to the screen.
;
;  message: word @ [bp + 4]
;
print:
    push bp
    mov bp, sp
    sub sp, 4
    mov word [bp - 2], bx
    mov word [bp - 4], si

    xor eax, eax

    mov si, [bp + 4]
    mov bh, 0x00
    mov bl, 0x0F
    mov ah, 0x0E

  .loop:
    mov al, [si]
    add si, 0x01
    cmp al, 0
    jz .end

    int 0x10
    jmp .loop

  .end:
    mov bx, word [bp - 2]
    mov si, word [bp - 4]
    add sp, 4
    pop bp
    ret

;
;  Reads 2K sectors from the disk.
;
;  sectors:        word @ [bp + 4]
;  drive_number:   word @ [bp + 6]
;  buffer_offset:  word @ [bp + 8]
;  buffer_segment: word @ [bp + 10]
;
;  Carry flag set if error.
;
read_2k_sectors:
    push bp
    mov bp, sp
    pusha

    mov eax, [read_2k_sectors_lba]
    mov dword [dap.lba], eax

    mov ax, word [bp + 4]
    mov word [dap.nblocks], ax

    mov dx, word [bp + 6]

    mov ax, word [bp + 8]
    mov word [dap.offset], ax

    mov ax, word [bp + 10]
    mov word [dap.segment], ax

    mov ah, 0x42
    mov si, dap
    int 0x13

    popa
    pop bp
    ret

read_2k_sectors_lba: dd 0

hello_message: db "Hello, world!", 0
goodbye_message: db "Goodbye, world!", 0

drive_number: db 0

align 8
dap:
  .size:    db 0x10
  .null:    db 0x00
  .nblocks: dw 0
  .offset:  dw 0
  .segment: dw 0
  .lba:     dq 0

gdt:
  dw .size - 1  ; GDT size
  dd .start     ; GDT start address

  .start:
    ; NULL
    dq 0

    ; 32-bit code
    dw 0xffff       ; Limit
    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (mid 8 bits)
    db 10011011b    ; Access
    db 11001111b    ; Granularity
    db 0x00         ; Base (high 8 bits)

    ; 32-bit data
    dw 0xffff       ; Limit
    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (mid 8 bits)
    db 10010011b    ; Access
    db 11001111b    ; Granularity
    db 0x00         ; Base (high 8 bits)

  .end:
  .size: equ .end - .start

bits 32
start32:
    jmp 0x0000:8400

; Pad to 2KiB. This is the total amount of data loaded initially.
times 2048-($-$$) db 0