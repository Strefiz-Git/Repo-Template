---
description: Retoma o trabalho a partir dos ficheiros (depois de /new, crash, compactação ou /desbloquear-pensamento)
---
Resume the work from where it stopped — **from the files, not from the chat**. Extra focus (optional): $ARGUMENTS

State:
!`bash scripts/session-start.sh`

1. If `.opencode/RECOVERY.md` exists: read it, follow its **Next concrete step**, and when you have used it, delete the file (`rm .opencode/RECOVERY.md`) — it is local and git-ignored.
2. Run the startup ritual of `AGENTS.md` §2 (skill `session-handoff`, part "Startup"): `PROGRESS.md`, `QUESTIONS.md` (new answers!), `TODO.md › Now`, `ROADMAP.md`, `BUGS.md`.
3. Run `bash scripts/check.sh` to learn the real state before touching code.
4. Apply the current levels shown above (thinking → skill `thinking-levels`; autonomy → `AGENTS.md` §4.8).
5. Do not recap the past. Start the next task now. If the autopilot was paused (`bash scripts/autopilot.sh status` shows `reason=paused…`), run `bash scripts/autopilot.sh resume`.
