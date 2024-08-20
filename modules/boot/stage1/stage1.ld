OUTPUT_FORMAT(elf32-i386)
ENTRY(entry)
SECTIONS
{
    . = 0x8400;

    .text : {
        *(.text);
    }

    .data : {
        *(.data);
    }

    .bss : {
        *(.bss);
    }
}