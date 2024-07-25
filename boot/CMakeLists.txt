add_custom_command(
    OUTPUT stage0.bin
    COMMAND nasm -fbin -ostage0.bin ${CMAKE_CURRENT_SOURCE_DIR}/src/stage0.asm
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/stage0.asm
)

add_custom_target(
    stage0
    DEPENDS stage0.bin
)