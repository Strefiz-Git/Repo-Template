#!/usr/bin/env bash
# Autonomy level of the agent (how much it asks vs. decides). Local state: .opencode/autonomy.level
#   bash scripts/autonomy.sh get              -> prints the current level (default: normal)
#   bash scripts/autonomy.sh set <level>      -> guiada | normal | alta | total
#   bash scripts/autonomy.sh reset            -> back to the default (normal)
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p .opencode
F=.opencode/autonomy.level
DEFAULT=normal

normalize() {
  local v
  v="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  case "$v" in
    guiada|guiado|baixa|baixo|guided|low|1)         echo guiada ;;
    normal|media|medio|medium|default|2)            echo normal ;;
    alta|alto|high|3)                               echo alta ;;
    total|maxima|maximo|max|full|sem-perguntas|4)   echo total ;;
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
      echo "Invalid level: '${2:-}'. Use: guiada | normal | alta | total" >&2; exit 1
    fi
    echo "$lvl" > "$F"; echo "$lvl"
    ;;
  reset)
    echo "$DEFAULT" > "$F"; echo "$DEFAULT"
    ;;
  *)
    echo "Usage: autonomy.sh get | set <guiada|normal|alta|total> | reset" >&2; exit 1 ;;
esac
