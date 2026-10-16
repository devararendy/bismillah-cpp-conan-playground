#!/bin/bash
BASE_DIR=$(dirname -- "${BASH_SOURCE[0]}")

# 1. Navigate to your build directory and clear out the corrupted configurations
cd ${BASE_DIR}
rm -rf ./build/*

cd ${BASE_DIR}
conan install . \
	--profile:host="${BASE_DIR}/profiles/macos-x86_64" \
	--profile:build="${BASE_DIR}/profiles/macos-x86_64" \
	--output-folder=build \
	--build=missing

# 2. Reconfigure the project using your Conan toolchain file
cd ${BASE_DIR}/build
cmake .. -DCMAKE_TOOLCHAIN_FILE=./conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

# 3. Compile the binary executable
cmake --build .

