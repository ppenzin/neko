add_library(std
  SHARED
  buffer.c
  date.c
  file.c
  init.c
  int32.c
  math.c
  string.c
  random.c
  serialize.c
  socket.c
  sys.c
  xml.c
  module.c
  md5.c
  unicode.c
  utf8.c
  memory.c
  misc.c
  thread.c
  process.c
  elf_update.c
)

target_include_directories(std
  PRIVATE
  ${LIB_COMMON_DIR}
  ${VM_SRC_DIR}
)

target_link_libraries(std
  libneko
  common
)

set_target_properties(std
  PROPERTIES PREFIX "" SUFFIX ".ndll"
)

install(TARGETS std
  LIBRARY DESTINATION lib
)
