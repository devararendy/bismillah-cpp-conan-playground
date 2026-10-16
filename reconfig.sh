#!/bin/bash
BASE_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PROFILE="${BASE_DIR}/profiles/macos-x86_64"
PROFILE_PATH="${1:-${DEFAULT_PROFILE}}"

# Always keep outputs under build/, with a build type subfolder.
case "${PROFILE_PATH}" in
  *debug*) BUILD_TYPE="Debug" ; MODE="debug" ;;
  *) BUILD_TYPE="Release" ; MODE="release" ;;
esac

OUTPUT_DIR="${BASE_DIR}/build/${2:-${MODE}}"

usage() {
  echo "Usage: $0 [profile_path] [release|debug]"
  echo ""
  echo "Examples:"
  echo "  $0                               # Release build under build/release"
  echo "  $0 ./profiles/macos-x86_64-debug # Debug build under build/debug"
  echo "  $0 ./profiles/macos-x86_64 debug # Force debug output under build/debug"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${PROFILE_PATH}" != /* ]]; then
  PROFILE_PATH="${BASE_DIR}/${PROFILE_PATH}"
fi

if [[ -n "${2:-}" ]]; then
  case "${2}" in
    debug) OUTPUT_DIR="${BASE_DIR}/build/debug" ;;
    release) OUTPUT_DIR="${BASE_DIR}/build/release" ;;
    *) OUTPUT_DIR="${BASE_DIR}/build/${2}" ;;
  esac
fi

# 2. Clear the target output folder and regenerate dependencies.
mkdir -p "${OUTPUT_DIR}"
rm -rf "${OUTPUT_DIR}"/*

conan install . \
  --profile:host="${PROFILE_PATH}" \
  --profile:build="${PROFILE_PATH}" \
  --output-folder="${OUTPUT_DIR}" \
  --build=missing

# 3. Reconfigure the project using the Conan-generated toolchain.
cmake -S "${BASE_DIR}" -B "${OUTPUT_DIR}" \
  -DCMAKE_TOOLCHAIN_FILE="${OUTPUT_DIR}/conan_toolchain.cmake" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"

# 4. Compile the binary executable.
cmake --build "${OUTPUT_DIR}"

