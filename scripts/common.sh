#!/usr/bin/env bash
set -euo pipefail

# Bu dosya diğer Bash scriptleri tarafından source edilir.
# Doğrudan çalıştırıldığında herhangi bir işlem yapmaz.

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  readonly COLOR_BLUE='\033[0;34m'
  readonly COLOR_GREEN='\033[0;32m'
  readonly COLOR_YELLOW='\033[0;33m'
  readonly COLOR_RED='\033[0;31m'
  readonly COLOR_RESET='\033[0m'
else
  readonly COLOR_BLUE=''
  readonly COLOR_GREEN=''
  readonly COLOR_YELLOW=''
  readonly COLOR_RED=''
  readonly COLOR_RESET=''
fi

info() {
  printf '%b[INFO]%b %s\n' "$COLOR_BLUE" "$COLOR_RESET" "$*"
}

success() {
  printf '%b[OK]%b %s\n' "$COLOR_GREEN" "$COLOR_RESET" "$*"
}

warn() {
  printf '%b[WARN]%b %s\n' "$COLOR_YELLOW" "$COLOR_RESET" "$*" >&2
}

error() {
  printf '%b[ERROR]%b %s\n' "$COLOR_RED" "$COLOR_RESET" "$*" >&2
}
