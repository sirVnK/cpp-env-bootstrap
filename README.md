# cpp-env-bootstrap — C++ Development Environment Bootstrap

Shell-based tooling to bootstrap a C++ compile-and-run environment quickly, so you can go from a clean machine to building and running C++ code with minimal manual setup.

## Overview

Setting up a C++ toolchain repeatedly is tedious. This project automates that with shell scripts that prepare a compile/run environment, reducing friction when starting new C++ work or learning exercises.

## Motivation

I built this as developer tooling for my own C++ workflow — a small automation project that removes repetitive setup and makes it faster to start coding and experimenting.

## Features

- Shell-based environment bootstrap
- Automated C++ compile and run helpers
- Quick setup for learning and prototyping

## Tech Stack

- **Language:** Shell / Bash
- **Target:** C++ toolchain
- **Category:** developer tooling / automation

## Installation

```bash
git clone https://github.com/Logshi/cpp-env-bootstrap.git
cd cpp-env-bootstrap
chmod +x *.sh
```

## Usage

```bash
# Example — adapt to the actual scripts
./bootstrap.sh
./run.sh path/to/file.cpp
```

## What I Learned

- Shell scripting for developer automation
- Understanding the C++ build/run cycle well enough to automate it
- Reducing setup friction with reusable tooling

## Security & Privacy

No credentials or sensitive data. Scripts operate on the local environment only.

## License

MIT — see [LICENSE](LICENSE).
