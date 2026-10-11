#!/bin/bash

# 1. Navigate to your build directory and clear out the corrupted configurations
cd /data/data/com.termux/files/home/git/c++/bismillah-1/build
rm -rf *

cd /data/data/com.termux/files/home/git/c++/bismillah-1
conan install . --output-folder=build --build=missing

# 2. Reconfigure the project using your Conan toolchain file
cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=./conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

# 3. Compile the binary executable
cmake --build .

