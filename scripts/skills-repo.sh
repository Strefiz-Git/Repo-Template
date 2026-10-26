#!/usr/bin/env bash
# Finds and installs skills from the central skills library (OpenCode-Skills-Repo).
#   bash scripts/skills-repo.sh list [category]       list skills (category/name)
#   bash scripts/skills-repo.sh search <keyword>      search names and descriptions
#   bash scripts/skills-repo.sh show <name>           print a skill's SKILL.md
#   bash scripts/skills-repo.sh install <name>...     copy skills into .opencode/skills/
#   bash scripts/skills-repo.sh install --category <c>   install a whole category
#   add --force to install to overwrite a skill that already exists
# Source: https://github.com/Strefiz-Git/OpenCode-Skills-Repo (catalog: CATALOG.md in that repo).
# The library is cloned (shallow) to a cache folder OUTSIDE the project and refreshed on every run;
# offline, the last cached copy is used. Override with SKILLS_REPO_URL / SKILLS_REPO_DIR.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
URL="${SKILLS_REPO_URL:-https://github.com/Strefiz-Git/OpenCode-Skills-Repo.git}"
CACHE="${SKILLS_REPO_DIR:-${TMPDIR:-/tmp}/OpenCode-Skills-Repo}"

die() { echo "skills-repo: $*" >&2; exit 1; }

sync_cache() {
  command -v git >/dev/null 2>&1 || die "git is required"
  if [[ -d "$CACHE/.git" ]]; then
    git -C "$CACHE" pull -q --ff-only 2>/dev/null || echo "skills-repo: could not update (offline?); using the cached copy" >&2
  else
    git clone -q --depth 1 "$URL" "$CACHE" 2>/dev/null || die "could not clone $URL"
  fi
  [[ -d "$CACHE/skills" ]] || die "$CACHE has no skills/ folder (is it the right repository?)"
}

find_skill() { # prints the folder of skill $1 or nothing
  local d
  for d in "$CACHE"/skills/*/"$1"; do [[ -f "$d/SKILL.md" ]] && { echo "$d"; return; }; done
}

valid_name() { [[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; }

cmd="${1:-}"; shift || true
case "$cmd" in
  list)
    sync_cache
    for d in "$CACHE"/skills/${1:-*}/*/; do
      [[ -f "$d/SKILL.md" ]] || continue
      echo "$(basename "$(dirname "$d")")/$(basename "$d")"
    done
    ;;
  search)
    [[ -n "${1:-}" ]] || die "usage: search <keyword>"
    sync_cache
    for f in "$CACHE"/skills/*/*/SKILL.md; do
      d="$(dirname "$f")"
      desc="$(grep -m1 '^description:' "$f" || true)"
      if grep -qi -- "$1" <<<"$(basename "$d") $desc"; then
        printf '%-16s %-34s %s\n' "$(basename "$(dirname "$d")")" "$(basename "$d")" "$(sed 's/^description: *"\{0,1\}//' <<<"$desc" | cut -c1-90)"
      fi
    done
    ;;
  show)
    valid_name "${1:-}" || die "usage: show <skill-name>"
    sync_cache
    d="$(find_skill "$1")"; [[ -n "$d" ]] || die "unknown skill: $1"
    cat "$d/SKILL.md"
    ;;
  install)
    force=0; names=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --force) force=1 ;;
        --category) shift; [[ -n "${1:-}" ]] || die "--category needs a name"
                    sync_cache
                    for d in "$CACHE"/skills/"$1"/*/; do [[ -f "$d/SKILL.md" ]] && names+=("$(basename "$d")"); done
                    [[ ${#names[@]} -gt 0 ]] || die "unknown or empty category: $1" ;;
        -*) die "unknown option: $1" ;;
        *) names+=("$1") ;;
      esac
      shift
    done
    [[ ${#names[@]} -gt 0 ]] || die "usage: install <name>... | --category <c>"
    sync_cache
    mkdir -p .opencode/skills
    for n in "${names[@]}"; do
      valid_name "$n" || die "invalid skill name: $n"
      src="$(find_skill "$n")"; [[ -n "$src" ]] || { echo "! unknown skill: $n" >&2; continue; }
      dest=".opencode/skills/$n"
      if [[ -e "$dest" && $force -eq 0 ]]; then echo "- $n: already installed (use --force to overwrite)"; continue; fi
      rm -rf "$dest"; cp -R "$src" "$dest"
      echo "+ $n"
    done
    echo "Next: add each new skill to the table in AGENTS.md §10 and record why in DECISIONS.md."
    ;;
  *)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    [[ -z "$cmd" ]] || exit 1
    ;;
esac
