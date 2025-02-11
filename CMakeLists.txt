# Single & multi bin template

# Main --------------------------------------------------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.28.3)


set(PROJECT_NAME "Universe")
set(PROJECT_VERSION "888.0.0")


set(BIN1 "universe")
# [add executeables here] main name definition


project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES CXX)


set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)


# Compiler choice ---------------------------------------------------------------------------------------------------------------------------
option(USE_CLANG "Clang as compiler instead of g++" ON)

if(USE_CLANG)
    find_program(CXX_COMPILER NAMES clang++-14 clang++-15 clang++-16 clang++-17 clang++-18 PATHS /usr/bin /usr/local/bin)
else()
    find_program(CXX_COMPILER NAMES g++-11 g++-12 g++-13 g++-14 PATHS /usr/bin /usr/local/bin)
endif()


if(NOT CXX_COMPILER)
    message(FATAL_ERROR "Compiler not found! Please install Clang > 14 or GCC > 11.0 or higher.")
endif()


execute_process(
    COMMAND ${CXX_COMPILER} --version
    OUTPUT_VARIABLE COMPILER_VERSION_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)


string(REGEX MATCH "([0-9]+\\.[0-9]+)" COMPILER_VERSION ${COMPILER_VERSION_OUTPUT})


if(USE_CLANG)
    if(COMPILER_VERSION VERSION_LESS "14.0.0")
        message(FATAL_ERROR "Compiler version Clang >= 14.0.0 is required, found version: ${COMPILER_VERSION}")
    endif()
else()
    if(COMPILER_VERSION VERSION_LESS "11.0.0")
        message(FATAL_ERROR "Compiler version GCC >= 11.0.0 is required, found version: ${COMPILER_VERSION}")
    endif()
endif()


execute_process(
    COMMAND ${CXX_COMPILER} -v
    OUTPUT_VARIABLE DETECT_COMPILER
    ERROR_VARIABLE DETECT_COMPILER
    OUTPUT_STRIP_TRAILING_WHITESPACE
)


if(DETECT_COMPILER MATCHES "clang")
    set(CMAKE_CXX_COMPILER_ID "Clang")
elseif(DETECT_COMPILER MATCHES "gcc")
    set(CMAKE_CXX_COMPILER_ID "GNU")
else()
    message(FATAL_ERROR "Unknown compiler detected in: ${DETECT_COMPILER}")
endif()


set(CMAKE_CXX_COMPILER ${CXX_COMPILER})


# Compiler flags main -----------------------------------------------------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type (Debug, Release, RelWithDebInfo, MinSizeRel)" FORCE)
endif()


set(COMPILER_FLAGS_BASE "-Wall -Wextra -Wpedantic -fPIC -pthread")
set(COMPILER_FLAGS_DEBUG "-O0 -g")
set(COMPILER_FLAGS_RELEASE "-O3")
set(COMPILER_FLAGS_RELWITHDEBINFO "-O2 -g")
set(COMPILER_FLAGS_MINSIZEREL "-Os")


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS_BASE} ${COMPILER_FLAGS_DEBUG}")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS_BASE} ${COMPILER_FLAGS_RELEASE}")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS_BASE} ${COMPILER_FLAGS_RELWITHDEBINFO}")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
    set(CMAKE_CXX_FLAGS "${COMPILER_FLAGS_BASE} ${COMPILER_FLAGS_MINSIZEREL}")
endif()


# Compiler flags ON/OFF ---------------------------------------------------------------------------------------------------------------------
option(ENABLE_DEPENDENCY_GENERATION "Enable dependency generation compile flags" OFF)
if(ENABLE_DEPENDENCY_GENERATION)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -MMD -MP")
endif()

## generalized, needs update, maybe
option(ENABLE_SANITIZERS "Enable sanitizer compile flags for runtime debugging" ON)
# man gcc | grep -A 10 'sanitize'
# clang --help | grep -A 10 'sanitize'
if(ENABLE_SANITIZERS)
    set(COMMON_SANITIZERS
        "undefined"
        "shift"
        "shift-exponent"
        "shift-base"
        "integer-divide-by-zero"
        "vla-bound"
        "null"
        "return"
        "signed-integer-overflow"
        "bounds"
        "alignment"
        "object-size"
        "float-divide-by-zero"
        "float-cast-overflow"
        "nonnull-attribute"
        "returns-nonnull-attribute"
        "bool"
        "enum"
        "vptr"
        "pointer-overflow"
        "builtin"
        "address"
        "leak"
        "pointer-compare"
    )

    set(SANITIZER_FLAGS "")
    foreach(SANITIZER ${COMMON_SANITIZERS})
        list(APPEND SANITIZER_FLAGS "-fsanitize=${SANITIZER}")
    endforeach()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        list(APPEND SANITIZER_FLAGS
            "-fsanitize=shadow-call-stack"
            "-fno-sanitize-address-globals-dead-stripping"
            "-fno-sanitize-address-outline-instrumentation"
            "-fno-sanitize-address-poison-custom-array-cookie"
            "-fno-sanitize-address-use-after-scope"
            "-fno-sanitize-address-use-odr-indicator"
            "-fno-sanitize-cfi-cross-dso"
        )

    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        list(APPEND SANITIZER_FLAGS
            #"-fsanitize=kernel-address"
            "-fno-sanitize-address-use-after-scope"
            #"-fsanitize-address-use-odr-indicator"
            "-Wno-maybe-uninitialized"  # as, clang ignoring the warnings.
            "-fsanitize=leak"
            "-fsanitize=bounds-strict"
            "-fsanitize=pointer-compare"
        )
    endif()

    string(REPLACE ";" " " SANITIZER_FLAGS "${SANITIZER_FLAGS}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SANITIZER_FLAGS}")
endif()


option(ENABLE_COMPILE_COMMANDS "Enable generation of compile_commands.json" ON)
if(ENABLE_COMPILE_COMMANDS)
    set(CMAKE_EXPORT_COMPILE_COMMANDS YES CACHE BOOL "Export compile commands" FORCE)
endif()


option(ENABLE_VERBOSE_MAKEFILES "Enable verbose makefiles" ON)
if(ENABLE_VERBOSE_MAKEFILES)
    set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "Enable verbose makefile output" FORCE)
endif()


option(ENABLE_WARNINGS_AS_ERRORS "Treat warnings as errors" OFF)
if(ENABLE_WARNINGS_AS_ERRORS)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
endif()


option(ENABLE_LOGGING "Enable detailed logging" ON)
if(ENABLE_LOGGING)
    add_definitions(-DENABLE_LOGGING)
else()
    add_definitions(-DDISABLE_LOGGING)
endif()


# Directories -------------------------------------------------------------------------------------------------------------------------------
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(BUILD_DIR ${CMAKE_BINARY_DIR}/build)
set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)


include_directories(
#    /usr/include
    ${SRC_DIR}
    ${SRC_DIR}/shared
    ${SRC_DIR}/${BIN1}
    # [add executeables here (main dir)]
)


# need globbing? ...
# file(GLOB_RECURSE SRCS ${SRC_DIR}/*.cpp)  # depth 1
# file(GLOB_RECURSE SRCS ${SRC_DIR}/**/*.cpp)  # depth 1+


# Build -------------------------------------------------------------------------------------------------------------------------------------


#find_package(OpenCV REQUIRED)
#
#if(NOT (OpenCV_VERSION VERSION_GREATER "4.6.0" OR OpenCV_VERSION VERSION_EQUAL "4.6.0"))
#    message(FATAL_ERROR "OpenCV version must be 4.6.0 or higher, found version ${OpenCV_VERSION}")
#endif()

# find_package(OpenCV REQUIRED VERSION 4.5.0 EXACT)
# find_package(OpenCV REQUIRED VERSION 3.4.0 EXACT 4.5.0)
#find_package(OpenCV REQUIRED)


# global
set(LIBS_MAIN
)
set(LIBS_${BIN1}
icuuc
icui18n
)
# [add executeables here] (lib linking as above eg bin1, 2 , 3 ...)


option(BUILD_${BIN1} "Enable ${BIN1}" ON) # appling general cmake template so leaving this here ...
# [add executeables here]


function(add_feature_executable FEATURE FEATURE_SOURCES)
    set(FEATURE_OPTION "BUILD_${FEATURE}")

    if(${${FEATURE_OPTION}})
        add_executable(${FEATURE} ${FEATURE_SOURCES})
        target_link_libraries(${FEATURE} PRIVATE ${LIBS_MAIN})

        # Conditionally link feature-specific libraries
        if(${FEATURE} STREQUAL ${BIN1})
            target_link_libraries(${FEATURE} PRIVATE ${LIBS_${BIN1}})
        endif()
        # [add executeables here]

        set_target_properties(${FEATURE} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})
    endif()
endfunction()


add_feature_executable(${BIN1} ${SRC_DIR}/${BIN1}/main.cpp)
# [add executeables here]


file(MAKE_DIRECTORY ${BUILD_DIR})
file(MAKE_DIRECTORY ${BIN_DIR})


# Clean -------------------------------------------------------------------------------------------------------------------------------------
add_custom_target(my_clean
    COMMAND rm -rf ${BUILD_DIR} ${BIN_DIR}
    COMMENT "Clean build and bin directories"
)


# Print settings info (before build) --------------------------------------------------------------------------------------------------------
message(STATUS "------------------------------------------------------------")
#message(STATUS "Project: ${PROJECT_NAME} (Version: ${PROJECT_VERSION})")
set(ASCII_ART "

0x55 0x6e 0x69 0x76 0x65 0x72 0x73 0x65
 +-+-+-+-+-+-+-+-+
 |U|n|i|v|e|r|s|e|
 +-+-+-+-+-+-+-+-+
VERSION ${PROJECT_VERSION}")
message(STATUS "${ASCII_ART}")
message(STATUS "------------------------------------------------------------")
message(STATUS "CMake generator: ${CMAKE_GENERATOR}")
message(STATUS "Compiler: ${CXX_COMPILER}")
message(STATUS "------------------------------------------------------------")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Default flags: ${COMPILER_FLAGS_BASE}")
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
message(STATUS "Debug build! Additional flags: ${COMPILER_FLAGS_DEBUG}")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
message(STATUS "Release build! Additional flags: ${COMPILER_FLAGS_RELEASE}")
elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
message(STATUS "RelWithDebInfo build! Additional flags: ${COMPILER_FLAGS_RELWITHDEBINFO}")
elseif(CMAKE_BUILD_TYPE STREQUAL "MinSizeRel")
message(STATUS "MinSizeRel build! Additional flags: ${COMPILER_FLAGS_MINSIZEREL}")
endif()
#message(STATUS "Flags all: ${CMAKE_CXX_FLAGS}")
message(STATUS "------------------------------------------------------------")
message(STATUS "Dependency Generation: ${ENABLE_DEPENDENCY_GENERATION}")
message(STATUS "Enable sanitizer compile flags for runtime debugging: ${ENABLE_SANITIZERS}")
message(STATUS "Warnings as Errors: ${ENABLE_WARNINGS_AS_ERRORS}")
message(STATUS "Verbose Makefiles: ${ENABLE_VERBOSE_MAKEFILES}")
message(STATUS "Compile Commands Export: ${ENABLE_COMPILE_COMMANDS}")
message(STATUS "------------------------------------------------------------")
message(STATUS "Build ${BIN1}: ${BUILD_${BIN1}}")
# [add executeables here]
message(STATUS "------------------------------------------------------------")
#message(STATUS "Found OpenCV version: ${OpenCV_VERSION}")
#message(STATUS "OpenCV_LIBS: ${OpenCV_LIBS}")
#message(STATUS "OpenCV_INCLUDE_DIRS: ${OpenCV_INCLUDE_DIRS}")
#message(STATUS "------------------------------------------------------------")




