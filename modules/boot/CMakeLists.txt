add_subdirectory(stage0)
add_subdirectory(stage1)

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
        COMMAND cp ARGS ${CMAKE_CURRENT_BINARY_DIR}/stage0/stage0.bin ${CMAKE_CURRENT_BINARY_DIR}/boot.bin
        COMMAND dd ARGS of=${CMAKE_CURRENT_BINARY_DIR}/boot.bin if=${CMAKE_CURRENT_BINARY_DIR}/stage1/stage1.bin conv=notrunc oflag=append
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/stage0/stage0.bin ${CMAKE_CURRENT_BINARY_DIR}/stage1/stage1.bin
)
add_custom_target(boot-bin DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/boot.bin)