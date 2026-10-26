---
description: Liga/desliga ou mostra o auto commit — /auto-commit status|auto|on|off|push-on|push-off
---
Use the skill `auto-commit`.

Arguments: `$ARGUMENTS` (empty = `status`).

- `status` → shows whether auto-commit is effectively active in this folder.
- `auto` → the default: active **whenever a git repository is present**, idle otherwise.
- `on` / `off` → force on / off (`off` is also available per terminal with the env var `AUTOCOMMIT=off`).
- `push-on` / `push-off` → also `git push` after each checkpoint (off by default; `git push` stays on "ask" in `opencode.json`).

Run `bash scripts/autocommit.sh <argument>` and report its output in at most 3 lines. If the argument is not valid, list the valid ones and stop. Never edit `.opencode/autocommit.json` by hand for this.
