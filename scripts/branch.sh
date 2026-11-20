#!/usr/bin/env bash
# Usage: bash scripts/branch.sh <classification> "<short description>"
# Creates a branch named <classification>-<kebab-description>-<YYYY-MM-DD>
# after validating the classification. See AGENTS.md §6 "Branches".
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

valid="feat fix hotfix refactor perf a11y ux ui support security docs test chore audit deps build ci experiment spike release revert wip adjust"

class="${1:-}"
desc="${2:-}"
if [[ -z "$class" || -z "$desc" ]]; then
  echo "Usage: bash scripts/branch.sh <classification> \"<short description>\"" >&2
  echo "Classifications: $valid" >&2
  exit 1
fi

class="${class,,}"
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