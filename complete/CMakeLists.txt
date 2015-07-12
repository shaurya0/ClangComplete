PROJECT(CLANG_COMPLETE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}")

SET(CMAKE_CXX_COMPILER "g++")
SET(CMAKE_C_COMPILER "gcc")
SET(CLANG_COMPLETE_ROOT_DIR .)
set(
    CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${CMAKE_SOURCE_DIR}/
    )

set(CMAKE_VERBOSE_MAKEFILE 1)
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DNDEBUG -Os -c -fPIC")

find_package(Clang)

include_directories(
    .
    ${CLANG_INCLUDE_DIR}
    )

add_library(complete MODULE complete.cpp)
target_link_libraries(complete ${CLANG_DLL} )
