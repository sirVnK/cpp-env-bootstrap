#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly SCRIPT_DIR
PROJECT_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
readonly PROJECT_ROOT
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

TEMP_DIR=''

cleanup() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR"
  fi
}
trap cleanup EXIT

test_direct_compilation() {
  local expected='Merhaba, C++ WSL!'
  local actual

  info "Geçici C++17 Hello World programı derleniyor."
  cat > "$TEMP_DIR/main.cpp" <<'CPP'
#include <iostream>

int main() {
    std::cout << "Merhaba, C++ WSL!" << '\n';
    return 0;
}
CPP

  g++ -std=c++17 -Wall -Wextra -Werror -g "$TEMP_DIR/main.cpp" -o "$TEMP_DIR/app"
  actual=$("$TEMP_DIR/app")

  if [[ "$actual" != "$expected" ]]; then
    error "Hello World çıktısı beklenenden farklı. Beklenen='$expected', alınan='$actual'"
    return 1
  fi
  success "Doğrudan g++ derleme ve çalıştırma testi geçti."
}

test_cmake_project() {
  local source_dir="$PROJECT_ROOT/templates/cmake-sample"
  local build_dir="$TEMP_DIR/cmake-build"
  local expected='CMake + Ninja örneği çalıştı.'
  local actual

  info "CMake + Ninja örnek projesi derleniyor."
  cmake -S "$source_dir" -B "$build_dir" -G Ninja
  cmake --build "$build_dir"
  actual=$("$build_dir/cmake_sample")

  if [[ "$actual" != "$expected" ]]; then
    error "CMake örneği çıktısı beklenenden farklı. Beklenen='$expected', alınan='$actual'"
    return 1
  fi
  success "CMake + Ninja smoke testi geçti."
}

main() {
  info "Ortam kontrolü çalıştırılıyor."
  "$SCRIPT_DIR/check_env.sh"

  TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/cpp-env-bootstrap.XXXXXX")
  test_direct_compilation
  test_cmake_project

  success "C++ WSL development environment is ready."
}

main "$@"

