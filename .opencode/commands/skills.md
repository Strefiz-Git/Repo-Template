---
description: Find and install a skill from the central library (OpenCode-Skills-Repo). /skills <keyword|name>
---
Use the skill `skills-library`.

Request: `$ARGUMENTS`

1. If empty, run `bash scripts/skills-repo.sh list` and summarise the categories.
2. Otherwise run `bash scripts/skills-repo.sh search "$ARGUMENTS"` (try 2 or 3 related keywords before giving up).
3. Read the best candidates with `bash scripts/skills-repo.sh show <name>` and pick only what the current task needs.
4. Install them with `bash scripts/skills-repo.sh install <name>...`, add each one to the table in `AGENTS.md` §10, and log the decision in `DECISIONS.md`.
5. Reply with: what was installed, why, and what was not installed.
