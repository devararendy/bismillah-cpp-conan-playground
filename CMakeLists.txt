cmake_minimum_required(VERSION 3.15)
project(ConanHelloWorld CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ❌ REMOVE THIS LINE: set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")

find_package(fmt CONFIG REQUIRED)

add_executable(hello_world main.cpp)

#  FORCE TARGET STATIC LINKING
# This tells the compiler to bundle your source code and fmt together 
# without breaking Android's core dynamic system dependencies.
target_link_libraries(hello_world PRIVATE fmt::fmt)

