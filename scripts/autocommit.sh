#!/usr/bin/env bash
# Controls auto commit (config in .opencode/autocommit.json) and shows whether it is effectively active.
#   bash scripts/autocommit.sh status
#   bash scripts/autocommit.sh auto        -> default: active whenever a git repository is present
#   bash scripts/autocommit.sh on|off      -> force on / off
#   bash scripts/autocommit.sh push-on|push-off
# The environment variable AUTOCOMMIT=on|off overrides the file.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p .opencode
C=.opencode/autocommit.json
[[ -f "$C" ]] || printf '{\n  "enabled": "auto",\n  "push": false,\n  "minIntervalSeconds": 15,\n  "blockSecrets": true,\n  "skipBranches": [],\n  "message": "chore(wip): checkpoint"\n}\n' > "$C"

set_key() { # set_key <key> <json-value>
  sed -i.bak -E "s|^([[:space:]]*\"$1\":[[:space:]]*)[^,]*(,?)[[:space:]]*\$|\\1$2\\2|" "$C" && rm -f "$C.bak"
}
get_key() { grep -E "^[[:space:]]*\"$1\"" "$C" | head -1 | sed -E 's/^[^:]*:[[:space:]]*//; s/,[[:space:]]*$//; s/"//g'; }

status() {
  local en push repo eff
  en="$(get_key enabled)"; push="$(get_key push)"
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then repo=yes; else repo=no; fi
  case "${AUTOCOMMIT:-}" in
    off|0|false) eff="OFF (AUTOCOMMIT=off in the environment)" ;;
    on|1|true)   eff="$([[ $repo == yes ]] && echo ACTIVE || echo "idle (no git repository)") (AUTOCOMMIT=on)" ;;
    *)
      case "$en" in
        false|off) eff="OFF (disabled in $C)" ;;
        true|on)   eff="$([[ $repo == yes ]] && echo ACTIVE || echo "idle (no git repository)") (forced on)" ;;
        *)         eff="$([[ $repo == yes ]] && echo "ACTIVE (git repository detected)" || echo "idle (no git repository here)")" ;;
      esac ;;
  esac
  echo "auto-commit: $eff"
  echo "  config enabled=$en · push=$push · git repository: $repo"
}

case "${1:-status}" in
  status)   status ;;
  auto)     set_key enabled '"auto"'; status ;;
  on)       set_key enabled true;     status ;;
  off)      set_key enabled false;    status ;;
  push-on)  set_key push true;        status ;;
  push-off) set_key push false;       status ;;
  *) echo "Usage: autocommit.sh status | auto | on | off | push-on | push-off" >&2; exit 1 ;;
esac
