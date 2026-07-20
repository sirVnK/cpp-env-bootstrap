#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly SCRIPT_DIR
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

readonly REQUIRED_COMMANDS=(
  "g++:build-essential"
  "gcc:build-essential"
  "gdb:gdb"
  "cmake:cmake"
  "ninja:ninja-build"
  "git:git"
  "pkg-config:pkg-config"
  "clang-format:clang-format"
  "clang:clang"
  "lldb:lldb"
  "make:make"
  "tree:tree"
  "curl:curl"
  "unzip:unzip"
)

check_runtime() {
  local kernel
  kernel=$(uname -s 2>/dev/null || printf 'unknown')

  if [[ "$kernel" != "Linux" ]]; then
    error "Linux çekirdeği algılanmadı ($kernel)."
    error "Bu script Windows PowerShell/Git Bash içinde değil, WSL Ubuntu terminalinde çalıştırılmalıdır."
    return 1
  fi

  if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "${WSL_INTEROP:-}" ]]; then
    success "OK: WSL ortamı bulundu"
  else
    warn "WSL algılanmadı; yerel Linux/CI ortamı olarak kontrole devam ediliyor."
  fi

  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    if [[ "${ID:-}" == "ubuntu" ]]; then
      success "OK: Ubuntu ${VERSION_ID:-bilinmiyor} bulundu"
    else
      warn "Ubuntu yerine ${PRETTY_NAME:-bilinmeyen Linux} algılandı. Paket adları farklı olabilir."
    fi
  else
    warn "/etc/os-release bulunamadı; dağıtım doğrulanamadı."
  fi
}

check_commands() {
  local missing_count=0
  local item command_name package_name

  info "C++ geliştirme komutları kontrol ediliyor."
  for item in "${REQUIRED_COMMANDS[@]}"; do
    command_name=${item%%:*}
    package_name=${item#*:}

    if command -v "$command_name" >/dev/null 2>&1; then
      success "OK: $command_name bulundu"
    else
      error "MISSING: $command_name bulunamadı (Ubuntu paketi: $package_name)"
      ((missing_count += 1))
    fi
  done

  if (( missing_count > 0 )); then
    error "Özet: $missing_count komut eksik. './scripts/bootstrap_ubuntu.sh' çalıştırın."
    return 1
  fi

  success "Özet: gerekli komutların tamamı hazır."
}

main() {
  local runtime_status=0
  local command_status=0

  check_runtime || runtime_status=$?
  check_commands || command_status=$?

  if (( runtime_status != 0 || command_status != 0 )); then
    return 1
  fi

  return 0
}

main "$@"
