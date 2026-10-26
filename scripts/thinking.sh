#!/usr/bin/env bash
# Thinking level of the agent (how deeply it deliberates). Local state: .opencode/thinking.level
#   bash scripts/thinking.sh get              -> prints the current level (default: medio)
#   bash scripts/thinking.sh set <level>      -> baixo | medio | alto | auto (aliases: low/medium/high, 1/2/3, b/m/a)
#   bash scripts/thinking.sh reset            -> back to the default (medio)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p .opencode
F=.opencode/thinking.level
DEFAULT=medio

normalize() {
  local v
  v="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]' | sed -e 's/é/e/g' -e 's/á/a/g' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  case "$v" in
    baixo|baixa|b|low|l|1|rapido|rápido|fast) echo baixo ;;
    medio|media|m|med|medium|2|normal)        echo medio ;;
    alto|alta|a|high|h|3|profundo|deep)       echo alto ;;
    auto|automatico|automático)               echo auto ;;
    *) return 1 ;;
  esac
}

cmd="${1:-get}"
case "$cmd" in
  get)
    if [[ -f "$F" ]] && lvl="$(normalize "$(cat "$F")")"; then echo "$lvl"; else echo "$DEFAULT"; fi
    ;;
  set)
    if ! lvl="$(normalize "${2:-}")"; then
      echo "Invalid level: '${2:-}'. Use: baixo | medio | alto | auto" >&2; exit 1
    fi
    echo "$lvl" > "$F"; echo "$lvl"
    ;;
  reset)
    echo "$DEFAULT" > "$F"; echo "$DEFAULT"
    ;;
  *)
    echo "Usage: thinking.sh get | set <baixo|medio|alto|auto> | reset" >&2; exit 1 ;;
esac
