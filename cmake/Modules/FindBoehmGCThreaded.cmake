# - Try to find Boehm Garbage Collector threaded library
# Once done this will define
#  GC_THREADED_FOUND - System has GC-threaded library
#  GC_THREADED_INCLUDE_DIRS - The library include directories
#  GC_THREADED_LIBRARIES - The libraries needed to use the garbage collector library
#  GC_THREADED_DEFINITIONS - Compiler switches required for using GC library

find_package(PkgConfig)
pkg_check_modules(PC_LIBGC QUIET libgc-threaded)
set(GC_THREADED_DEFINITIONS ${PC_LIBGC_CFLAGS_OTHER})

find_path(GC_THREADED_INCLUDE_DIR gc/gc.h
          HINTS ${PC_LIBGC_INCLUDEDIR} ${PC_LIBGC_INCLUDE_DIRS}
          PATH_SUFFIXES libgc-threaded )

find_library(GC_THREADED_LIBRARY NAMES gc-threaded libgc-threaded
             HINTS ${PC_LIBGC_LIBDIR} ${PC_LIBGC_LIBRARY_DIRS} )

set(GC_THREADED_LIBRARIES ${GC_THREADED_LIBRARY} )
set(GC_THREADED_INCLUDE_DIRS ${GC_THREADED_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set GC_THREADED_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(BoehmGCThreaded  DEFAULT_MSG
                                  GC_THREADED_LIBRARY GC_THREADED_INCLUDE_DIR)

mark_as_advanced(GC_THREADED_INCLUDE_DIR GC_THREADED_LIBRARY )
