# C++ Conan Playground

This project is a very small C++ + Conan setup. The goal is to keep the initial setup as simple as possible, similar to a `go mod init` flow: create a Python virtual environment, install the required packages, detect or create a Conan profile, then configure and build the project.

---

## 1) Create and activate a Python virtual environment

From the project root:

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
```

If you are on Windows PowerShell:

```powershell
py -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
```

Notes:
- The virtual environment keeps project dependencies isolated.
- You should activate it whenever you work on the project.

---

## 2) Install the required Python packages

Install the dependencies from the project requirements file:

```bash
python -m pip install -r requirements.txt
```

This project currently installs Conan and utilities needed for profile detection and dependency generation.

---

## 3) Initialize Conan

After installing the Python packages, initialize Conan in the repository:

```bash
conan profile detect --force
```

This creates a default profile for your machine at:

```bash
~/.conan2/profiles/default
```

You can also inspect profiles:

```bash
conan profile list
conan profile show
```

---

## 4) Create a custom Conan profile for this project

This project already includes an example profile in:

- [profiles/macos-x86_64](profiles/macos-x86_64)

Example:

```ini
[settings]
os=Macos
arch=x86_64
build_type=Release
compiler=apple-clang
compiler.version=15
compiler.cppstd=20
compiler.libcxx=libc++
```

### Create a new profile for your machine

For macOS Intel:

```bash
mkdir -p profiles
cat > profiles/macos-x86_64 <<'EOF'
[settings]
os=Macos
arch=x86_64
build_type=Release
compiler=apple-clang
compiler.version=15
compiler.cppstd=20
compiler.libcxx=libc++
EOF
```

For macOS Apple Silicon:

```bash
cat > profiles/macos-arm64 <<'EOF'
[settings]
os=Macos
arch=armv8
build_type=Release
compiler=apple-clang
compiler.version=15
compiler.cppstd=20
compiler.libcxx=libc++
EOF
```

For Linux x86_64:

```bash
cat > profiles/linux-x86_64 <<'EOF'
[settings]
os=Linux
arch=x86_64
build_type=Release
compiler=gcc
compiler.version=13
compiler.cppstd=20
compiler.libcxx=libstdc++11
EOF
```

---

## 5) Android / Termux setup

If you are running this project from Android via Termux, the setup is similar, but you need Android-specific tooling and a profile for the target device.

### Install basic dependencies in Termux

```bash
pkg update
pkg install git clang cmake ninja python make
```

Then create the virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### Create an Android profile

Example profile for Android ARM64:

```bash
mkdir -p profiles
cat > profiles/android-termux-arm64 <<'EOF'
[settings]
os=Linux
arch=armv8
compiler=clang
compiler.version=21
compiler.cppstd=20
compiler.libcxx=c++_shared
build_type=Release

[conf]
tools.android:ndk_path=.
EOF
```

If the toolchain is different on your system, the most important part is matching the target platform and compiler details for the device you are building for.

---

## 6) Build the project

This project includes a helper script to regenerate the Conan build environment:

```bash
bash reconfig.sh
```

It uses the default Release profile at:

```bash
profiles/macos-x86_64
```

### Switch between Release and Debug

The script always writes under the project `build/` directory, with a `release` or `debug` subfolder.

```bash
./reconfig.sh                           # build/release
./reconfig.sh ./profiles/macos-x86_64-debug   # build/debug
./reconfig.sh ./profiles/macos-x86_64 debug    # force build/debug
```

The script automatically chooses:

- `Release` for profiles without `debug` in the name
- `Debug` for profiles with `debug` in the name

If you want to use a different profile manually, you can call Conan directly:

```bash
conan install . \
  --profile:host=profiles/macos-x86_64 \
  --profile:build=profiles/macos-x86_64 \
  --output-folder=build/release \
  --build=missing

cmake -S . -B build/release \
  -DCMAKE_TOOLCHAIN_FILE=build/release/conan_toolchain.cmake \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build/release
```

---

## 7) Setup VS Code for C++ debugging

Install these VS Code extensions:

- `ms-vscode.cpptools`
- `ms-vscode.cmake-tools`
- `vadimcn.vscode-lldb`

Then:

1. Open the project in VS Code.
2. Run **CMake: Select Configure Preset** and choose `conan-release`.
3. Run **CMake: Configure**.
4. Open the Run and Debug tab.
5. Choose one of the launch configs:
   - `Debug hello_world (Release)`
   - `Debug hello_world (Debug)`

The debug launch configuration is already defined in [.vscode/launch.json](.vscode/launch.json).

### Debug in VS Code

For a debug build:

```bash
./reconfig.sh ./profiles/macos-x86_64-debug
```

This produces the binary at:

```bash
build/debug/hello_world
```

Then select **Debug hello_world (Debug)** in VS Code and press `F5`.

For a release build:

```bash
./reconfig.sh
```

This produces the binary at:

```bash
build/release/hello_world
```

Then select **Debug hello_world (Release)** and press `F5`.

---

## 8) Simple “init” flow

If you want the shortest possible setup, use this sequence:

```bash
python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
conan profile detect --force
mkdir -p profiles
cat > profiles/macos-x86_64 <<'EOF'
[settings]
os=Macos
arch=x86_64
build_type=Release
compiler=apple-clang
compiler.version=15
compiler.cppstd=20
compiler.libcxx=libc++
EOF
bash reconfig.sh
```

That is the project bootstrap in one simple flow.

---

## 9) Useful commands

```bash
source venv/bin/activate
conan profile list
conan profile show
conan install . --profile:host=profiles/macos-x86_64 --profile:build=profiles/macos-x86_64 --output-folder=build/release --build=missing
cmake --build build/release
./build/release/hello_world
./reconfig.sh ./profiles/macos-x86_64-debug
```

---

## 10) Troubleshooting

- If Conan says your profile is missing, run `conan profile detect --force`.
- If you change architecture or OS, create a new profile instead of reusing the old one.
- If you are building on mobile or Android, make sure the profile matches the target architecture and ABI.
- If you are using Termux, install the required native tools first (`clang`, `cmake`, `make`, `ninja`).

This should keep the setup easy and predictable for future builds.
