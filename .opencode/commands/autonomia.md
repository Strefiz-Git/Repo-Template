---
description: Define quanto a IA decide sozinha vs. pergunta — /autonomia guiada|normal|alta|total|status
---
Arguments: `$ARGUMENTS`

Levels (full rules in `AGENTS.md` §4.8):

- **guiada** — asks before non-trivial design choices and before anything large; good when you want to steer.
- **normal** — the default: decides on its own, asks only on real blockers (`AGENTS.md` §4.3).
- **alta** — a real blocker does not stop the work: record the question with a default recommendation in `QUESTIONS.md`, apply the default as `Provisional`, and keep going.
- **total** — never stops to ask. Skips (and records) anything that needs credentials, money or irreversible actions. The hard limits of `AGENTS.md` §8 still apply.

Steps:

1. No arguments or `status` → run `bash scripts/autonomy.sh get`, show the level and its one-line meaning. Change nothing.
2. Otherwise run `bash scripts/autonomy.sh set <level>` (accepts `guiada|normal|alta|total`, plus aliases such as `baixa`, `media`, `maxima`, `sem-perguntas`). If the script rejects the value, show the valid levels and stop.
3. Confirm in ONE line: `Autonomia: <level> — <meaning>`. Follow it for the rest of the session.

Current level before this command:
!`bash scripts/autonomy.sh get`
