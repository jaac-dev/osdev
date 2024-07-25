cmake_minimum_required(VERSION 3.19)

set(CMAKE_C_COMPILER_WORKS 1)

project(
    osdev

    DESCRIPTION
    "A operating-system development project."

    LANGUAGES
    "C"
)

add_subdirectory(boot)