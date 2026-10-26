---
description: Define quanto a IA pensa antes de agir — /pensamento baixo|medio|alto|auto [tarefa]
---
Use the skill `thinking-levels`.

Arguments received: `$ARGUMENTS`

Interpret them like this (accept Portuguese and English, with or without accents, any casing):

- **First word = level.** `baixo`/`low`/`1`/`b` → **baixo** · `medio`/`médio`/`medium`/`2`/`m` → **medio** · `alto`/`high`/`3`/`a` → **alto** · `auto` → **auto**.
- **No arguments, or `status`/`estado`** → just show the current level and a 3-line summary of what it means. Change nothing.
- **Rest of the text = task (optional).** If there is one, apply the level and do the task right away. If there is none, only set the level.
- If the first word is not a level, do **not** guess silently: show the valid options (`baixo`, `medio`, `alto`, `auto`) in one line and stop.

Steps:

1. Persist the level (skip when only showing status): `bash scripts/thinking.sh set <level>`. The script prints the normalized level.
2. Confirm in ONE line: `Pensamento: <level> — <what it changes>` (in the user's language).
3. From now on, and until the user changes it, follow the level's rules from the skill `thinking-levels` for every task in this session (the level is also read back by `scripts/session-start.sh` in later sessions).
4. If a task was given, do it now under the level's rules.

Current level before this command:
!`bash scripts/thinking.sh get`
