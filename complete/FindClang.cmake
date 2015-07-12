# 12.07.2015 Modified by Shaurya Sharma (shaur141@gmail.com)

#Metashell - Interactive C++ template metaprogramming shell
# Copyright (C) 2013, Abel Sinkovics (abel@sinkovics.hu)
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Options for the module
#  CLANG_INCLUDEDIR   Set this if the module can not find the Clang
#                     headers
#  CLANG_LIBRARYDIR   Set this if the module can not find the Clang
#                     library
#  CLANG_BINARYDIR    Set this if the module can not find the clang binary
#  CLANG_DEBUG        Set this for verbose output
#  CLANG_STATIC       Link staticly against libClang (not supported on Windows)
# This module will define the following:
#   CLANG_FOUND
#   CLANG_INCLUDE_DIR
#   CLANG_LIBRARY
#   CLANG_DLL (only on Windows)
#   CLANG_HEADERS (the path to the headers used by clang)
#   CLANG_BINARY

if (NOT $ENV{CLANG_INCLUDEDIR} STREQUAL "" )
  set(CLANG_INCLUDEDIR $ENV{CLANG_INCLUDEDIR})
endif()

if (NOT $ENV{CLANG_LIBRARYDIR} STREQUAL "" )
  set(CLANG_LIBRARYDIR $ENV{CLANG_LIBRARYDIR})
endif()

# Find clang on some Ubuntu versions
foreach(V 3.5 3.4 3.3 3.2)
  set(CLANG_INCLUDEDIR "${CLANG_INCLUDEDIR};/usr/lib/llvm-${V}/include")
  set(CLANG_LIBRARYDIR "${CLANG_LIBRARYDIR};/usr/lib/llvm-${V}/lib")
endforeach()

# Find clang-c on Windows
if (WIN32)
  set(
    CLANG_INCLUDEDIR
    "D:/llvm-3.4/llvm-3.4-mingw-w64-4.8.1-x64-posix-sjlj/include"
  )

  set(
    CLANG_LIBRARYDIR
    "D:/llvm-3.4/llvm-3.4-mingw-w64-4.8.1-x64-posix-sjlj/bin"
  )
endif()


find_path(CLANG_INCLUDE_DIR NAMES clang-c/Index.h HINTS ${CLANG_INCLUDEDIR})


if (WIN32)
  find_file(CLANG_LIBRARY NAMES libclang.dll HINTS ${CLANG_LIBRARYDIR})
  find_file(CLANG_DLL NAMES libclang.dll HINTS ${CLANG_LIBRARYDIR})
endif()

include(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set CLANG_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(
  CLANG DEFAULT_MSG CLANG_LIBRARY CLANG_INCLUDE_DIR
)

mark_as_advanced(CLANG_INCLUDE_DIR CLANG_LIBRARY CLANG_DLL)

if (CLANG_FOUND)
  message(STATUS "libclang found")
  message(STATUS "  CLANG_INCLUDE_DIR = ${CLANG_INCLUDE_DIR}")
  message(STATUS "  CLANG_LIBRARY = ${CLANG_LIBRARY}")
  if (WIN32)
    message(STATUS "  CLANG_DLL = ${CLANG_DLL}")
  endif ()
else()
  message(STATUS "libclang not found")
endif()
