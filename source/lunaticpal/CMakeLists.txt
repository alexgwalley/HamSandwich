# -----------------------------------------------------------------------------
# A precomputer which generates a compressed 16MiB RGB -> 8-bit lookup table.
add_executable(lunaticpal_precompute precompute.main.cpp)
gnu_compile_options(lunaticpal_precompute PRIVATE -Wall -Wextra -Wpedantic -Wno-missing-field-initializers)
target_link_libraries(lunaticpal_precompute z)
# Always optimize, even in Debug mode, because otherwise we're just wasting time.
gnu_compile_options(lunaticpal_precompute PRIVATE -O3)

set(compressed "${CMAKE_CURRENT_BINARY_DIR}/lunaticpal_lookup_table.deflate")
add_custom_command(
	OUTPUT "${compressed}"
	COMMAND lunaticpal_precompute "${compressed}"
	DEPENDS lunaticpal_precompute
	COMMENT "Generating Lunatic palette lookup table"
	VERBATIM
)

# -----------------------------------------------------------------------------
# A library including the compressed lookup table and routines to access it.
if(WIN32 OR EMSCRIPTEN)
	# TODO: Must explicitly declare exported symbols on Windows before it can
	# be a shared library.
	set(ham_library_type STATIC)
else()
	set(ham_library_type SHARED)
endif()
add_library(lunaticpal_lib ${ham_library_type} lunaticpal.cpp)
gnu_compile_options(lunaticpal_lib PRIVATE -Wall -Wextra -Wpedantic -Wno-missing-field-initializers)
target_link_libraries(lunaticpal_lib z SDL2)
target_include_directories(lunaticpal_lib INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}")
HamSandwich_embed_file(lunaticpal_lib "${compressed}" embed_compressed_lookup_table)

# -----------------------------------------------------------------------------
# A simple `lunaticpal` tool which presents open/save dialogs on loop.
add_executable(lunaticpal lunaticpal.main.cpp)
gnu_compile_options(lunaticpal PRIVATE -Wall -Wextra -Wpedantic -Wno-missing-field-initializers)
target_link_libraries(lunaticpal lunaticpal_lib SDL2 SDL2_image tinyfiledialogs)
