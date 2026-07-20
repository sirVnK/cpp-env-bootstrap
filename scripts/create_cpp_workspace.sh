#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly SCRIPT_DIR
PROJECT_ROOT=$(cd -- "$SCRIPT_DIR/.." && pwd)
readonly PROJECT_ROOT
# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/common.sh"

expand_home() {
  local path=$1
  case "$path" in
    \~) printf '%s\n' "$HOME" ;;
    \~/*) printf '%s/%s\n' "$HOME" "${path:2}" ;;
    *) printf '%s\n' "$path" ;;
  esac
}

copy_tree_without_overwrite() {
  local source_root=$1
  local destination_root=$2
  local source_file relative_path destination_file

  if [[ ! -d "$source_root" ]]; then
    error "Şablon klasörü bulunamadı: $source_root"
    return 1
  fi

  while IFS= read -r -d '' source_file; do
    relative_path=${source_file#"$source_root"/}
    destination_file="$destination_root/$relative_path"
    mkdir -p -- "$(dirname -- "$destination_file")"

    if [[ -e "$destination_file" ]]; then
      warn "Korundu, zaten var: $destination_file"
    else
      cp -- "$source_file" "$destination_file"
      success "Oluşturuldu: $destination_file"
    fi
  done < <(find "$source_root" -type f -print0 | sort -z)
}

copy_file_without_overwrite() {
  local source_file=$1
  local destination_file=$2

  mkdir -p -- "$(dirname -- "$destination_file")"
  if [[ -e "$destination_file" ]]; then
    warn "Korundu, zaten var: $destination_file"
  else
    cp -- "$source_file" "$destination_file"
    success "Oluşturuldu: $destination_file"
  fi
}

main() {
  local requested_path=${1:-"$HOME/cpp-lab"}
  local workspace_path
  workspace_path=$(expand_home "$requested_path")

  info "C++ çalışma alanı hazırlanıyor: $workspace_path"
  mkdir -p -- "$workspace_path"

  copy_tree_without_overwrite "$PROJECT_ROOT/templates/cpp-workspace" "$workspace_path"
  copy_tree_without_overwrite "$PROJECT_ROOT/templates/cmake-sample" "$workspace_path/cmake-sample"
  copy_tree_without_overwrite "$PROJECT_ROOT/.vscode" "$workspace_path/.vscode"
  copy_file_without_overwrite "$PROJECT_ROOT/.clang-format" "$workspace_path/.clang-format"

  success "C++ çalışma alanı hazır: $workspace_path"
  info "Mevcut dosyaların hiçbirinin üzerine yazılmadı."
}

main "$@"

