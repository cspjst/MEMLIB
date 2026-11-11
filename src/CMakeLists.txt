# Copyright (c) 2026 Jeremy Simon Thornton, License: MIT
cmake_minimum_required(VERSION 3.10)

# Toolchain (DOS / I86 / wcl) comes from cmk.sh -D flags.          # <-- CHANGED: MEM -> DOS
project(MEMLIB VERSION 0.6.0 LANGUAGES C)

# Compiler options
# Reference: https://users.pja.edu.pl/~jms/qnx/help/watcom/compiler-tools/cpopts.html
add_compile_options(
    -0          # 8086/8088 instructions only
    -bt=dos     # Target DOS
    -ml         # Large memory model: MUST match every program linking this lib
    -za99       # C99 (partial in OW2)
    -zp1        # 1-byte struct packing (structs are filled from asm)
    -ox         # Full optimisation (note: implies -s, no stack checks)
    -os         # Favour size
    -d2         # Full debug info
    -w2         # Warning level 2
    -zq         # Quiet
)
# Optional switches:
#   -e<n>   stop after n errors
#   -fpi87  assume 8087 present (only if every target XT has one)

# Dependencies
# DOSLIB (vendored copy: include/DOS/*.h, lib/DOS.lib)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
set(DOS_LIB ${CMAKE_CURRENT_SOURCE_DIR}/lib/DOS.lib)

# Sources
# Library code
file(GLOB MEM_SOURCES
    CONFIGURE_DEPENDS
    MEM/*.c
)
# Test harness
file(GLOB TEST_SOURCES
    CONFIGURE_DEPENDS
    *.c
    TEST/*.c
)

# Versioning
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/MEM/mem_version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/MEM/mem_version.h
  @ONLY
)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/../README.md.in
  ${CMAKE_CURRENT_SOURCE_DIR}/../README.md
  @ONLY
)

# Build mode selection
set(MAKE_LIB ON)

if(MAKE_LIB)
    # MEM.LIB from library code; TEST.exe gets MEM code only via the lib
    add_library(MEMLIB STATIC ${MEM_SOURCES})
    set_target_properties(MEMLIB PROPERTIES OUTPUT_NAME MEM)
    add_executable(TEST ${TEST_SOURCES})
    target_link_libraries(TEST PRIVATE MEMLIB ${DOS_LIB})
else()
    # Everything compiled straight into TEST.exe
    add_executable(TEST ${TEST_SOURCES} ${MEM_SOURCES})
    target_link_libraries(TEST PRIVATE ${DOS_LIB})
endif()
