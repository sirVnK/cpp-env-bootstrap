# cpp-env-bootstrap

`cpp-env-bootstrap` prepares a reproducible C++17 learning and development environment on Ubuntu, including Ubuntu running under WSL 2. It installs and verifies the toolchain, creates a ready-to-use exercise workspace, and runs compile-and-execute smoke tests.

The main Ubuntu entry point is `./setup.sh`. Bash scripts must be run in an Ubuntu terminal, not in Windows PowerShell, Command Prompt, or Git Bash.

## Supported and tested environments

- Windows 11 with WSL 2 and Ubuntu
- Native Ubuntu 22.04 and 24.04 (the scripts continue with a warning on other Ubuntu releases)
- GitHub Actions on Ubuntu 22.04 and 24.04

The complete setup has been tested successfully on Windows 11, WSL 2, Ubuntu 22.04, GCC/G++ 11.4, CMake 3.22, Ninja 1.10, and GDB 12.1. Newer package versions supplied by supported Ubuntu releases are also expected to work.

## What is installed

The Ubuntu bootstrap uses `apt` to install missing packages from this list:

`build-essential`, `gdb`, `cmake`, `ninja-build`, `git`, `pkg-config`, `clang-format`, `clang`, `lldb`, `make`, `tree`, `curl`, and `unzip`.

Requirements are an internet connection, an Ubuntu 22.04 or 24.04 environment, and either root access or a user with `sudo`. On Windows, install WSL 2, Ubuntu, Visual Studio Code, and the WSL extension first.

## Repository structure

```text
.
├── setup.sh                       # Main Ubuntu setup entry point
├── scripts/
│   ├── bootstrap_ubuntu.sh        # Installs missing Ubuntu packages
│   ├── bootstrap_windows.ps1      # Read-only Windows prerequisite check
│   ├── check_env.sh               # Verifies Linux/WSL and required commands
│   ├── create_cpp_workspace.sh    # Copies templates without overwriting files
│   └── run_smoke_tests.sh         # Tests direct g++ and CMake/Ninja builds
├── templates/
│   ├── cpp-workspace/             # Thirteen standalone C++ exercises
│   └── cmake-sample/              # Minimal C++17 CMake project
├── .vscode/                       # Build, debug, and formatting configuration
├── .github/workflows/             # ShellCheck and Ubuntu smoke-test CI
└── docs/                          # Workflow, troubleshooting, and study notes
```

## Windows and WSL preparation

Windows üzerinde ilk kez kurulum yapıyorsanız ekran ekran ilerleyen Türkçe kılavuzu kullanın: **[Windows, WSL 2, Ubuntu ve Git Kurulum Kılavuzu](docs/WINDOWS_WSL_KURULUM.md)**. Kılavuz; WSL 2 ve Ubuntu kurulumunu, Ubuntu içinde Git kurmayı, repoyu Linux ev dizinine klonlamayı ve VS Code ile açmayı kapsar.

In Windows PowerShell, inspect WSL and the installed distributions:

```powershell
wsl --status
wsl -l -v
```

Ubuntu should show version `2`. If WSL or Ubuntu is not installed, run this from an Administrator PowerShell and complete any requested restart and Ubuntu first-run setup:

```powershell
wsl --install -d Ubuntu
```

The optional Windows checker reports whether WSL, an Ubuntu WSL 2 distribution, VS Code, and the `code` command are available:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap_windows.ps1
```

Despite its historical filename, `bootstrap_windows.ps1` only checks prerequisites and prints guidance. It does not install, delete, reset, unregister, or convert a WSL distribution and does not change Windows settings.

After the Windows checks, open the Ubuntu application or enter it with `wsl`. Run all following `.sh` commands there.

> **Git prerequisite:** The recommended workflow clones the repository inside Ubuntu, so `git` must already be available there before `setup.sh` can install the rest of the toolchain. If `git --version` fails in Ubuntu, run `sudo apt update && sudo apt install -y git`. Git for Windows is optional and is only needed if you also want to use Git directly from PowerShell; it does not replace Git inside WSL Ubuntu.

## Installation

Clone into the Linux home directory. This is recommended over `/mnt/c` because the WSL Linux filesystem avoids common Windows-mounted-file permission and line-ending problems and generally gives better filesystem performance.

```bash
cd ~

git clone https://github.com/sirVnK/cpp-env-bootstrap.git
cd cpp-env-bootstrap

chmod +x setup.sh scripts/*.sh
./setup.sh
```

By default, setup creates `~/cpp-lab`. To use another destination, pass it as the only argument:

```bash
./setup.sh ~/another-cpp-workspace
```

Setup performs these operations in order:

1. Installs missing Ubuntu packages and reports tool versions.
2. Verifies the runtime and every required command.
3. Copies C++ examples, the CMake sample, `.vscode`, and `.clang-format` into the workspace.
4. Compiles and executes temporary direct-G++ and CMake/Ninja smoke tests.

These final messages indicate success:

```text
[OK] Ubuntu C++ araç zinciri hazır.
[OK] C++ WSL development environment is ready.
[OK] Kurulum ve testler tamamlandı.
```

`[WARN] Korundu, zaten var: ...` is not an error. It means an existing workspace file was preserved rather than overwritten.

## Verification and tests

Run individual checks from the repository directory in Ubuntu:

```bash
./scripts/check_env.sh
./scripts/run_smoke_tests.sh
```

Contributors can also run:

```bash
shellcheck setup.sh scripts/*.sh
./setup.sh "$(mktemp -d)/cpp-lab"
```

The smoke-test script creates and removes its own temporary build directory. The command above also isolates workspace generation from your real `~/cpp-lab`.

## Using the generated workspace in VS Code

```bash
cd ~/cpp-lab
code .
```

The lower-left VS Code status area should display `WSL: Ubuntu`. If it does not, reopen the folder from an Ubuntu terminal or use **WSL: Reopen Folder in WSL** from the command palette. With Microsoft C/C++ installed, `Ctrl+Shift+B` builds the active C++ file and `F5` starts it under GDB.

## Compile and run an example

```bash
cd ~/cpp-lab/01-hello-world
g++ -std=c++17 -Wall -Wextra main.cpp -o app
./app
```

One-line form:

```bash
g++ -std=c++17 -Wall -Wextra main.cpp -o app && ./app
```

The generated CMake sample uses the executable name defined in its actual `CMakeLists.txt`:

```bash
cd ~/cpp-lab/cmake-sample
cmake -S . -B build -G Ninja
cmake --build build
./build/cmake_sample
```

## Safe re-running

`setup.sh` is designed to be rerun. Package installation checks what is missing, environment checks are read-only, smoke tests use a temporary directory, and workspace creation never overwrites an existing file. Re-running setup can add template files that do not yet exist, but it preserves any path already present and prints `Korundu, zaten var`.

The package index is refreshed on every full setup, so reruns still require network access and may request the Ubuntu `sudo` password.

## Troubleshooting

### `g++ is not recognized`

This Windows-style error usually means `g++` was entered in PowerShell rather than Ubuntu. Open WSL Ubuntu, then run `./scripts/check_env.sh`. The Bash setup installs the compiler inside Ubuntu; it does not add a Windows compiler to PowerShell.

### `Permission denied`

From the repository directory in Ubuntu:

```bash
chmod +x setup.sh scripts/*.sh
```

### `/usr/bin/env: 'bash\r': No such file or directory`

Windows CRLF line endings reached a Bash script. Safely normalize the repository scripts in Ubuntu:

```bash
sed -i 's/\r$//' setup.sh scripts/*.sh
chmod +x setup.sh scripts/*.sh
```

Cloning again under `~` rather than `/mnt/c` also helps avoid this problem. The repository's `.gitattributes` declares LF endings for shell scripts.

### `code: command not found`

Install Visual Studio Code on Windows, ensure its installer adds `code` to `PATH`, reopen the terminals, and install the WSL extension:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

Then return to Ubuntu and run `code .` from the workspace.

### Ubuntu is using WSL 1

Get the exact distribution name in PowerShell:

```powershell
wsl -l -v
```

Then convert it without deleting or unregistering it:

```powershell
wsl --set-version Ubuntu 2
```

Replace `Ubuntu` with the exact listed name if necessary. Confirm the result with `wsl -l -v`.

### Existing files are not replaced

This is intentional. `create_cpp_workspace.sh` refuses to overwrite existing files. Compare your file with the corresponding file under `templates/` and merge desired changes manually.

### Package manager errors

Wait for another `apt` or `dpkg` process to finish; do not delete lock files. Check with `ps aux | grep -E 'apt|dpkg'`. For package availability, use `sudo apt update` and `apt-cache policy cmake ninja-build clang-format`.

More diagnostics are in [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Known limitations

- Automated package installation is Ubuntu-specific and targets Ubuntu 22.04/24.04; other Linux distributions need manual equivalents.
- The Windows script checks prerequisites only. WSL/Ubuntu installation and WSL 1-to-2 migration remain explicit user actions.
- VS Code and its WSL/C++ extensions are not installed automatically.
- The generated VS Code configuration assumes `/usr/bin/g++` and `/usr/bin/gdb`.
- Existing workspace files never receive later template updates automatically.

## Contributing and license

Keep changes non-destructive, C++17-compatible, and clean under ShellCheck and the smoke tests. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full checklist.

This project is licensed under the [MIT License](LICENSE).

