#!/usr/bin/env bash
# Lists every slash command of the project (always up to date: reads the files in .opencode/commands/).
#   bash scripts/commands.sh
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
for f in .opencode/commands/*.md; do
  [[ -e "$f" ]] || continue
  name="$(basename "$f" .md)"
  desc="$(awk '/^---$/{c++; next} c==1 && /^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$f")"
  printf '/%-26s %s\n' "$name" "$desc"
done | sort
