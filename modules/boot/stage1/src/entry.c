#include <stdnoreturn.h>
#include <stdint.h>

void WriteCharacter(unsigned char c, unsigned char forecolour, unsigned char backcolour, int x, int y) {
    uint16_t attrib = (backcolour << 4) | (forecolour & 0x0F);
    volatile uint16_t *where;
    where = (volatile uint16_t *) 0xB8000 + (y * 80 + x);
    *where = c | (attrib << 8);
}

noreturn void entry() {
    WriteCharacter('O', 0xF, 0x0, 0, 0);
    WriteCharacter('K', 0xF, 0x0, 1, 0);

    for (;;) {} // Spin.
}

