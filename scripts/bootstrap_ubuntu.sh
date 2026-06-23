#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

readonly PACKAGES=(
  build-essential
  gdb
  cmake
  ninja-build
  git
  pkg-config
  clang-format
  clang
  lldb
  make
  tree
  curl
  unzip
)

check_platform() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    error "Bu script Linux/WSL Ubuntu içinde çalıştırılmalıdır."
    error "Windows PowerShell veya Git Bash yerine önce 'wsl' komutuyla Ubuntu'yu açın."
    return 1
  fi

  if [[ ! -r /etc/os-release ]]; then
    error "/etc/os-release okunamadı; desteklenen bir Ubuntu sistemi algılanamadı."
    return 1
  fi

  # shellcheck disable=SC1091
  source /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    error "Bu kurulum Ubuntu 22.04/24.04 için tasarlandı. Algılanan sistem: ${PRETTY_NAME:-bilinmiyor}"
    return 1
  fi

  case "${VERSION_ID:-}" in
    22.04|24.04)
      success "Desteklenen Ubuntu sürümü algılandı: $VERSION_ID"
      ;;
    *)
      warn "Ubuntu ${VERSION_ID:-bilinmiyor} algılandı. Script çalışmayı sürdürecek ancak hedef sürümler 22.04 ve 24.04'tür."
      ;;
  esac

  if grep -qi microsoft /proc/version 2>/dev/null || [[ -n "${WSL_INTEROP:-}" ]]; then
    success "WSL ortamı algılandı."
  else
    warn "WSL algılanmadı. Yerel Ubuntu üzerinde kuruluma devam ediliyor."
  fi
}

configure_privilege_command() {
  if [[ "$EUID" -eq 0 ]]; then
    SUDO=()
    return
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    error "Paket kurulumu için sudo gerekli fakat bulunamadı."
    return 1
  fi

  info "Paket yöneticisi erişimi doğrulanıyor; Ubuntu parolanız istenebilir."
  sudo -v
  SUDO=(sudo)
}

list_missing_packages() {
  MISSING_PACKAGES=()
  local package
  for package in "${PACKAGES[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'ok installed'; then
      MISSING_PACKAGES+=("$package")
    fi
  done
}

install_packages() {
  info "Ubuntu paket listesi güncelleniyor (apt-get update)."
  "${SUDO[@]}" apt-get update

  list_missing_packages
  if (( ${#MISSING_PACKAGES[@]} == 0 )); then
    success "Gerekli paketlerin tamamı zaten kurulu."
    return
  fi

  info "Eksik paketler kuruluyor: ${MISSING_PACKAGES[*]}"
  "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get install -y "${MISSING_PACKAGES[@]}"
  success "Eksik paketlerin kurulumu tamamlandı."
}

show_version() {
  local label=$1
  shift

  if command -v "$1" >/dev/null 2>&1; then
    local version
    version=$("$@" 2>&1)
    version=${version%%$'\n'*}
    success "$label: $version"
    return 0
  fi

  error "$label komutu bulunamadı."
  return 1
}

verify_versions() {
  local failures=0
  info "Kurulan geliştirme araçlarının sürümleri kontrol ediliyor."

  show_version "g++" g++ --version || ((failures += 1))
  show_version "gcc" gcc --version || ((failures += 1))
  show_version "gdb" gdb --version || ((failures += 1))
  show_version "cmake" cmake --version || ((failures += 1))
  show_version "ninja" ninja --version || ((failures += 1))
  show_version "git" git --version || ((failures += 1))
  show_version "clang-format" clang-format --version || ((failures += 1))

  if (( failures > 0 )); then
    error "$failures zorunlu araç doğrulanamadı."
    return 1
  fi

  success "Ubuntu C++ araç zinciri hazır."
}

main() {
  check_platform
  configure_privilege_command
  install_packages
  verify_versions
}

main "$@"
