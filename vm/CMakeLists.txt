
add_library(libneko SHARED
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

add_library(nekostats STATIC stats.c)

add_executable(nekovm
	main.c
)

target_link_libraries(nekovm nekostats)

if (STATIC_BOEHMGC)
	if (WIN32)
		ExternalProject_Add(BoehmGC
			${EP_CONFIGS}
			URL http://www.hboehm.info/gc/gc_source/gc-7.1.tar.gz
			URL_MD5 2ff9924c7249ef7f736ecfe6f08f3f9b
			CMAKE_ARGS
				-Wno-dev
				-Denable_threads=ON
				-DCMAKE_USE_WIN32_THREADS_INIT=ON
			PATCH_COMMAND
				${CMAKE_COMMAND} -E copy
					${CMAKE_SOURCE_DIR}/libs/gc/CMakeLists.txt
					${CMAKE_BINARY_DIR}/libs/src/BoehmGC/CMakeLists.txt
				&& cd ${CMAKE_BINARY_DIR}/libs/src/BoehmGC &&
				${GIT_EXECUTABLE} apply --ignore-space-change --ignore-whitespace --whitespace=nowarn --unsafe-paths ${CMAKE_SOURCE_DIR}/libs/gc/av_safety.patch
			INSTALL_COMMAND
				${CMAKE_COMMAND} -E copy_directory
					${CMAKE_BINARY_DIR}/libs/src/BoehmGC/include
					${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/include/gc
		)
		set(GC_INCLUDE_DIR ${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/include)
		set(GC_LIBRARIES
			${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/${CMAKE_CFG_INTDIR}/gcmt-dll.lib
		)
		add_custom_command(OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/gcmt-dll.dll
			DEPENDS BoehmGC
			COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/${CMAKE_CFG_INTDIR}/gcmt-dll.dll ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
		)
		add_custom_target(gcmt-dll.dll ALL
			DEPENDS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/gcmt-dll.dll
		)
		add_dependencies(nekovm gcmt-dll.dll)
	else()
		ExternalProject_Add(libatomic_ops
			${EP_CONFIGS}
			URL http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.2.tar.gz
			URL_MD5 1d6538604b314d2fccdf86915e5c0857
			CONFIGURE_COMMAND echo skip config
			BUILD_COMMAND echo skip build
			INSTALL_COMMAND echo skip install
		)

		ExternalProject_Add(BoehmGC
			${EP_CONFIGS}
			DEPENDS libatomic_ops
			URL http://hboehm.info/gc/gc_source/gc-7.4.2.tar.gz
			URL_MD5 12c05fd2811d989341d8c6d81f66af87
			PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/libs/src/libatomic_ops ${CMAKE_BINARY_DIR}/libs/src/BoehmGC/libatomic_ops
			CONFIGURE_COMMAND cd ${CMAKE_BINARY_DIR}/libs/src/BoehmGC &&
				./configure
					--prefix=${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build
					--enable-threads=posix
					--with-pic
					--enable-shared=no
					--enable-static=yes
					--enable-silent-rules
					--silent
			BUILD_COMMAND cd ${CMAKE_BINARY_DIR}/libs/src/BoehmGC &&
				make CFLAGS=-w
			INSTALL_COMMAND cd ${CMAKE_BINARY_DIR}/libs/src/BoehmGC &&
				make install
		)

		# don't want to add libatomic_ops to external_deps,
		# but want download_static_deps depends on it
		add_dependencies(BoehmGC-download libatomic_ops-download)

		set(GC_INCLUDE_DIR ${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/include)
		set(GC_LIBRARIES
			${CMAKE_BINARY_DIR}/libs/src/BoehmGC-build/lib/libgc.a
		)
	endif()
	set_target_properties(BoehmGC PROPERTIES ${EP_PROPS})
	add_dependencies(libneko BoehmGC)
else()
	find_package(BoehmGC REQUIRED)
endif()

target_include_directories(libneko PRIVATE ${GC_INCLUDE_DIR})

target_link_libraries(libneko ${GC_LIBRARIES})
target_link_libraries(nekovm libneko)

if(UNIX)
        if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "FreeBSD")
		set(DL_LIB "dl")
	endif()
	find_package(Threads)
	target_link_libraries(libneko ${DL_LIB} m ${CMAKE_THREAD_LIBS_INIT})
endif()

set_target_properties(nekovm libneko
	PROPERTIES
	OUTPUT_NAME neko
)

set_target_properties(libneko
	PROPERTIES
	VERSION ${NEKO_VERSION}
	SOVERSION ${NEKO_VERSION_MAJOR}
	COMPILE_DEFINITIONS "_USRDLL;NEKOVM_DLL_EXPORTS;NEKO_SOURCES"
	PUBLIC_HEADER "${libneko_public_headers}"
)

install (
	TARGETS
		nekovm
		libneko
	EXPORT NekoTargets
	RUNTIME DESTINATION ${DEST_BIN}
	LIBRARY DESTINATION ${DEST_LIB}
	PUBLIC_HEADER DESTINATION ${DEST_INCLUDE}
)

install(SCRIPT ${NEKO_FLATTEN_SCRIPT})

