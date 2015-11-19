find_package(BoehmGCThreaded REQUIRED)

add_library(neko
  alloc.c
  builtins.c
  callback.c
  elf.c
  interp.c
  load.c
  objtable.c
  others.c
  hash.c
  module.c
  jit_x86.c
  threads.c
)

target_include_directories(neko
  PUBLIC
  ${GC_THREADED_INCLUDE_DIR}
)

target_link_libraries(neko
  ${GC_THREADED_LIBRARY}
)
