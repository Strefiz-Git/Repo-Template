#!/usr/bin/env bash
# Installs auto-commit GLOBALLY, so it works in ANY folder that contains a git repository,
# even in projects that do not have this template (default "auto" mode: active only if a repo is present).
#   bash scripts/install-global.sh              install the plugin in ~/.config/opencode/plugins/
#   bash scripts/install-global.sh --skills     also copy the skills (.opencode/skills/*) to ~/.config/opencode/skills/
#   bash scripts/install-global.sh --uninstall  remove what this script installed
# Commands (/pensamento, /auto…) are NOT installed globally on purpose: they call scripts/*.sh of the project.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
CFG="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"

if [[ "${1:-}" == "--uninstall" ]]; then
  rm -f "$CFG/plugins/auto-commit.js"
  echo "Removed $CFG/plugins/auto-commit.js (skills, if any, were left untouched)."
  exit 0
fi

mkdir -p "$CFG/plugins"
cp .opencode/plugins/auto-commit.js "$CFG/plugins/auto-commit.js"
echo "Installed: $CFG/plugins/auto-commit.js"

if [[ "${1:-}" == "--skills" ]]; then
  mkdir -p "$CFG/skills"
  cp -r .opencode/skills/. "$CFG/skills/"
  echo "Installed skills in $CFG/skills/"
fi

cat <<MSG

Restart OpenCode. From now on, in any folder inside a git repository, a 'chore(wip): checkpoint' is made
when the session goes idle (never pushes; blocks secrets). Without a repository it does nothing.
Per-project tuning: .opencode/autocommit.json · disable in a terminal: AUTOCOMMIT=off
If a project also has this template's copy of the plugin, only one of them acts (guard built in).
MSG
