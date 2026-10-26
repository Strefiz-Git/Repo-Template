#!/usr/bin/env bash
# Controls autopilot mode (used by the plugin .opencode/plugins/autopilot.js).
#   bash scripts/autopilot.sh start [minutes] [max-iterations]   (defaults: 120 min, 60 iterations)
#   bash scripts/autopilot.sh stop "reason"
#   bash scripts/autopilot.sh pause "reason"    (used by unstick.sh; keeps the budget)
#   bash scripts/autopilot.sh resume            (only resumes if it was paused)
#   bash scripts/autopilot.sh status
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
mkdir -p .opencode
S=.opencode/autopilot.state
cmd="${1:-status}"

case "$cmd" in
  start)
    mins="${2:-120}"
    max="${3:-60}"
    rm -f STOP
    printf 'active=1\nstart=%s\nbudget_min=%s\ncount=0\nmax=%s\nwrapup=0\nsession=\nreason=\n' "$(date +%s)" "$mins" "$max" > "$S"
    bash scripts/clock.sh reset >/dev/null 2>&1 || true
    echo "autopilot active: ${mins} min (max ${max} iterations)"
    ;;
  pause)
    reason="${2:-paused}"
    if [[ -f "$S" ]] && grep -q '^active=1' "$S"; then
      sed -i.bak -e 's/^active=.*/active=0/' -e "s|^reason=.*|reason=paused: ${reason//|/ }|" "$S" && rm -f "$S.bak"
      echo "autopilot paused: $reason"
    else
      echo "autopilot was not active"
    fi
    ;;
  resume)
    if [[ -f "$S" ]] && grep -q '^reason=paused' "$S"; then
      sed -i.bak -e 's/^active=.*/active=1/' -e 's|^reason=.*|reason=|' -e 's/^wrapup=.*/wrapup=0/' "$S" && rm -f "$S.bak"
      echo "autopilot resumed"
    else
      echo "nothing to resume (autopilot was not paused)"
    fi
    ;;
  stop)
    reason="${2:-finished}"
    if [[ -f "$S" ]]; then
      sed -i.bak -e 's/^active=.*/active=0/' -e "s|^reason=.*|reason=${reason//|/ }|" "$S" && rm -f "$S.bak"
    else
      printf 'active=0\nreason=%s\n' "${reason//|/ }" > "$S"
    fi
    echo "autopilot stopped: $reason"
    ;;
  status)
    [[ -f "$S" ]] && cat "$S" || echo "autopilot: never started"
    ;;
  *)
    echo "Usage: autopilot.sh start [min] [max] | stop \"reason\" | pause | resume | status" >&2; exit 1 ;;
esac
