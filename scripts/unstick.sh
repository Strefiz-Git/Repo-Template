#!/usr/bin/env bash
# Soft reset for a looping / stuck agent: saves a RECOVERY snapshot built ONLY from files + git,
# and pauses the autopilot so the plugin does not wake the agent back into the loop.
#   bash scripts/unstick.sh [soft|hard]
# Output: .opencode/RECOVERY.md (local, git-ignored). `session-start.sh` shows it in the next session.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
mode="${1:-soft}"
mkdir -p .opencode
R=.opencode/RECOVERY.md
section() { awk -v s="## $1" '$0 ~ "^"s {f=1; next} /^## /{f=0} f' "$2" 2>/dev/null | sed '/^$/d' | head -"${3:-15}"; }

{
  echo "# RECOVERY — $(date '+%Y-%m-%d %H:%M')  (mode: $mode)"
  echo
  echo "> Snapshot made by \`scripts/unstick.sh\`. The true state is in the files and in git — NOT in the previous chat."
  echo
  echo "## Levels"
  echo "- thinking: $(bash scripts/thinking.sh get 2>/dev/null) · autonomy: $(bash scripts/autonomy.sh get 2>/dev/null)"
  echo
  echo "## Git"
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "- branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    echo '```'
    git status --short 2>/dev/null | head -30
    echo '```'
    echo "Changed (stat):"; echo '```'
    git diff --stat 2>/dev/null | tail -15
    echo '```'
    echo "Latest commits:"; echo '```'
    git log --oneline -8 2>/dev/null
    echo '```'
  else
    echo "(not a git repository)"
  fi
  echo
  echo "## PROGRESS › Current state"
  section "Current state" PROGRESS.md 15
  echo
  echo "## TODO › Now"
  section "Now" TODO.md 10
  echo
  echo "## Autopilot"
  bash scripts/autopilot.sh status 2>/dev/null | head -10
  echo
  echo "## Loop diagnosis (the agent fills this in)"
  echo "- What was being repeated:"
  echo "- Probable trigger (error retried? ambiguous instruction? huge output?):"
  echo "- What must NOT be tried again:"
  echo
  echo "## Next concrete step (the agent fills this in)"
  echo "- "
} > "$R"

bash scripts/autopilot.sh pause "unstick ($mode)" >/dev/null 2>&1 || true
echo "Snapshot saved in $R (autopilot paused if it was active)."
if [[ "$mode" == "hard" ]]; then
  echo "HARD mode: stop working now. Ask the user to open a NEW session (/new) and run /continuar."
fi
