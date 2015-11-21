find_package(BoehmGCThreaded REQUIRED)

add_library(libneko
  SHARED
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

set_target_properties(libneko
  PROPERTIES PREFIX ""
)

target_include_directories(libneko
  PUBLIC
  ${GC_THREADED_INCLUDE_DIR}
)

target_link_libraries(libneko
  ${GC_THREADED_LIBRARY}
  m
)

add_executable(neko
  main.c
  stats.c
)

target_link_libraries(neko
  libneko
)

install(TARGETS neko libneko
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
)
