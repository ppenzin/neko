add_library(common
  STATIC
  sha1.c
)

target_compile_options(common
  PRIVATE
  -fPIC
)
