cmake_minimum_required(VERSION 3.19)

set(CMAKE_C_COMPILER_WORKS 1)

project(
        osdev

        DESCRIPTION
        "A operating-system development project."

        LANGUAGES
        "C"
)

include(cmake/library.cmake)

add_subdirectory(modules)

add_custom_command(
        OUTPUT os.iso
        COMMAND mkisofs ARGS -c boot/catalog -b boot/boot.bin -boot-load-size 4 -boot-info-table -no-emul-boot -o os.iso iso
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/iso
)
add_custom_target(os-iso DEPENDS os.iso)

add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/iso
        COMMAND rm -rf iso
        COMMAND mkdir -p iso/boot
        COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/modules/boot/boot.bin ${CMAKE_CURRENT_BINARY_DIR}/iso/boot/boot.bin
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/modules/boot/boot.bin
)
add_custom_target(iso-root DEPENDS iso)

add_custom_target(
        qemu
        COMMAND qemu-system-x86_64 -cdrom ${CMAKE_CURRENT_BINARY_DIR}/os.iso
        DEPENDS os-iso
)

add_custom_target(
        qemu-debug
        COMMAND qemu-system-x86_64 -s -S -cdrom ${CMAKE_CURRENT_BINARY_DIR}/os.iso
        DEPENDS os-iso
)