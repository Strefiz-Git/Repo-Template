---
description: Automação total de um objetivo — planeia, implementa, verifica, faz commits e revê, sem perguntas. /auto <objetivo> [--min N]
---
Use the skills `automation-pipeline`, `autonomous-workflow` and `thinking-levels`.

Goal and options: `$ARGUMENTS`

- Parse an optional `--min N` (minutes; also accept `--horas H` → H×60). No option = **120 minutes**.
- Everything else is the **goal**. If the goal is empty, take it from `TODO.md › Now` / `ROADMAP.md`; if both are empty, run the "queue runs out" order of `AGENTS.md` §4.4.

Pipeline (run it end to end, without asking for confirmations):

1. **Prepare** — `bash scripts/session-start.sh`. If the unfilled template placeholders (double curly braces) are still in `AGENTS.md`/`README.md`, run the skill `project-bootstrap` first. Make sure there is a git repository (none → `git init` and a first commit; the user asked for full automation) and that auto-commit is active (`bash scripts/autocommit.sh status`).
2. **Plan** — skill `planning`: break the goal into tasks with acceptance criteria in `TODO.md`. If the thinking level is `baixo`, keep it to a short list.
3. **Start autopilot** — `bash scripts/autopilot.sh start <minutes>`.
4. **Work loop** — `AGENTS.md` §4.1 for every task: implement → `bash scripts/check.sh` → record → commit (`bash scripts/commit.sh`). Doubts → 5 angles, decide, record in `DECISIONS.md`.
5. **Close** — 15 min before the budget ends (or when the queue is empty): `/review` the work, fix blockers, `/structure` if code was added, then the handoff (skill `session-handoff`) and `bash scripts/autopilot.sh stop "done"`.

Hard limits (they never change, whatever the autonomy level): no `git push --force`, no secrets in the repo, nothing destructive outside the repo, nothing published or sent anywhere. If something is stuck for 2 attempts, change strategy; if you start repeating yourself, use the skill `loop-recovery`.

Final message (≤ 10 lines): done · decisions (D-NNN) · what needs the user (Q-NNN) · state · next step.
