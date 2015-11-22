set(NEKO_BIN_DIR ${CMAKE_CURRENT_BINARY_DIR}/neko)
set(NEKO_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/neko)
set(NEKOML_BIN_DIR ${CMAKE_CURRENT_BINARY_DIR}/nekoml)
set(NEKOML_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/nekoml)

add_custom_target(populate_compilers_src
  COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(neko_compilers_common
  COMMAND ${NEKO_EXE} nekoml -nostd neko/Main.nml nekoml/Main.nml
  DEPENDS neko populate_compilers_src neko/Main.nml nekoml/Main.nml
)

add_custom_target(nekoc
  ALL
  COMMAND ${NEKO_EXE} nekoc -link ${NEKOC_BOOT} neko/Main
  DEPENDS std neko_compilers_common
)

add_custom_target(nekoml
  ALL
  COMMAND ${NEKO_EXE} nekoc -link ${NEKOML_BOOT} nekoml/Main
  DEPENDS std neko_compilers_common
)

