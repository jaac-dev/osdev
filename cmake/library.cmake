#
#  Adds a flat binary target.
#
function(add_flat_binary TARGET)
    cmake_parse_arguments(
            PARSE_ARGV 1 ARG "" "LINKER_SCRIPT" "SOURCES"
    )

    add_executable(
            ${TARGET}-elf

            ${ARG_SOURCES}
    )

    target_compile_options(
            ${TARGET}-elf

            PRIVATE

            -ffreestanding
            -ffunction-sections
            -fdata-sections
            -fno-stack-protector
            -fno-stack-check
            -fno-omit-frame-pointer
            -fno-strict-aliasing
            -fno-lto
    )

    target_link_options(
            ${TARGET}-elf

            PRIVATE

            -T ${ARG_LINKER_SCRIPT}
            -nostdlib
            -nostartfiles
    )

    set_target_properties(
            ${TARGET}-elf

            PROPERTIES PREFIX "" SUFFIX ".elf" OUTPUT_NAME "${TARGET}"
    )

    add_custom_command(
            OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}.bin
            COMMAND ${CMAKE_OBJCOPY} ARGS -O binary ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}.elf ${TARGET}.bin
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}-elf
    )

    add_custom_target(
            ${TARGET}-bin
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}.bin
    )
endfunction()
