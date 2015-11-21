cmake_minimum_required (VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# Disallow in-source builds
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
   message(FATAL_ERROR "In-source builds are not allowed.")
endif()

project(neko)

set(VM_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/vm)
set(VM_BIN_DIR ${CMAKE_CURRENT_BINARY_DIR}/vm)
set(STD_BIN_DIR ${CMAKE_CURRENT_BINARY_DIR}/libs/std)
set(BOOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/boot)
set(NEKOC_BOOT ${CMAKE_CURRENT_SOURCE_DIR}/boot/nekoc.n)
set(NEKOML_BOOT ${CMAKE_CURRENT_SOURCE_DIR}/boot/nekoml.n)
set(NEKO_EXE NEKOPATH=${BOOT_DIR}:${STD_BIN_DIR} ${VM_BIN_DIR}/neko)

add_subdirectory(vm)
add_subdirectory(libs)
add_subdirectory(src)
