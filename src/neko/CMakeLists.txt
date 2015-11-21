add_custom_command(OUTPUT Main.n
  COMMAND ${NEKO_EXE} nekoml -nostd Main.nml
  DEPENDS neko Main.nml
)

add_custom_command(OUTPUT nekoc
  COMMAND ${NEKO_EXE} nekoc -link ${NEKOC_BOOT} Main
  DEPENDS neko Main.n
)

add_custom_target(neko_compiler
  ALL
  DEPENDS nekoc
)
