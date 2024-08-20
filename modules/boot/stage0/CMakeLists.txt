add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/stage0.bin
        COMMAND nasm -fbin -ostage0.bin ${CMAKE_CURRENT_SOURCE_DIR}/src/entry.asm
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/entry.asm
)
add_custom_target(stage0-bin DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/stage0.bin)