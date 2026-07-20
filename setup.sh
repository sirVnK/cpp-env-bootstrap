#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly PROJECT_ROOT
# shellcheck source=scripts/common.sh
source "$PROJECT_ROOT/scripts/common.sh"

main() {
  local workspace_path=${1:-"$HOME/cpp-lab"}

  info "1/4 - Ubuntu C++ araçları kuruluyor."
  "$PROJECT_ROOT/scripts/bootstrap_ubuntu.sh"

  info "2/4 - Geliştirme ortamı doğrulanıyor."
  "$PROJECT_ROOT/scripts/check_env.sh"

  info "3/4 - C++ çalışma alanı hazırlanıyor."
  "$PROJECT_ROOT/scripts/create_cpp_workspace.sh" "$workspace_path"

  info "4/4 - Smoke testleri çalıştırılıyor."
  "$PROJECT_ROOT/scripts/run_smoke_tests.sh"

  success "Kurulum ve testler tamamlandı."
  printf '\nSonraki adım:\n  cd %q\n  code .\n' "$workspace_path"
}

main "$@"

