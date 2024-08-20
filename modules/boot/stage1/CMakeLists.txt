add_flat_binary(
        stage1

        SOURCES
        src/entry.c

        LINKER_SCRIPT
        ${CMAKE_CURRENT_SOURCE_DIR}/stage1.ld
)