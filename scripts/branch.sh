#!/usr/bin/env bash
# Usage:
#   bash scripts/branch.sh <classification> "<short description>"   create + switch to a valid branch
#   bash scripts/branch.sh --check [name]       validate a branch name (default: current branch); protected branches pass
#   bash scripts/branch.sh --is-protected [name] exit 0 if the branch is protected (default: current branch)
# Branch format: <classification>-<kebab-description>-<YYYY-MM-DD>. See AGENTS.md §6 "Branches".
# Protected branches = "skipBranches" in .opencode/autocommit.json (default: main, master; [] = none).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

valid="feat fix hotfix refactor perf a11y ux ui support security docs test chore audit deps build ci experiment spike release revert wip adjust"

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; } # portable: no bash 4 needed

protected_list() {
  local f=.opencode/autocommit.json line
  if [[ -f "$f" ]] && line="$(grep -E '"skipBranches"' "$f" | head -1)" && [[ -n "$line" ]]; then
    printf '%s' "$line" | sed -E 's/.*\[(.*)\].*/\1/; s/[" ]//g' | tr ',' '\n' | sed '/^$/d'
  else
    printf 'main\nmaster\n'
  fi
}

current_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null || true; }

is_protected() { protected_list | grep -qxF -- "$1"; }

name_ok() {
  local re="^($(echo "$valid" | tr ' ' '|'))-[a-z0-9]+(-[a-z0-9]+)*-[0-9]{4}-[0-9]{2}-[0-9]{2}$"
  [[ "$1" =~ $re ]]
}

case "${1:-}" in
  --is-protected)
    b="${2:-$(current_branch)}"
    [[ -n "$b" ]] && is_protected "$b"
    exit $?
    ;;
  --check)
    b="${2:-$(current_branch)}"
    [[ -n "$b" ]] || { echo "No branch to check (not a git repository, or detached HEAD)." >&2; exit 1; }
    if is_protected "$b"; then echo "OK (protected branch): $b — do not work directly on it; start a branch with scripts/branch.sh."; exit 0; fi
    if name_ok "$b"; then echo "OK: $b"; exit 0; fi
    echo "Invalid branch name: $b" >&2
    echo "Expected: <classification>-<kebab-description>-<YYYY-MM-DD>   (classifications: $valid)" >&2
    exit 6
    ;;
esac

class="${1:-}"
desc="${2:-}"

if [[ -z "$class" || -z "$desc" ]]; then
  echo "Usage: bash scripts/branch.sh <classification> \"<short description>\"" >&2
  echo "Classifications: $valid" >&2
  exit 1
fi

class="$(lower "$class")"
if ! echo " $valid " | grep -q " $class "; then
  echo "Invalid classification: $class" >&2
  echo "Allowed: $valid" >&2
  exit 2
fi

kebab=$(printf '%s' "$desc" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g; s/-+/-/g')
if [[ -z "$kebab" ]]; then
  echo "Description produced an empty slug." >&2
  exit 3
fi

date=$(date +%F)
name="${class}-${kebab}-${date}"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repository." >&2; exit 4; }

if git show-ref --verify --quiet "refs/heads/$name"; then
  echo "Branch already exists: $name" >&2
  exit 5
fi

git checkout -b "$name"
echo "Created and switched to branch: $name"
echo "Reminder: update PROGRESS.md > Current state with 'Branch: $name — objective: <one line>'."
