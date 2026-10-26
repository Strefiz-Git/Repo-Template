---
name: automation-pipeline
description: End-to-end automation recipe for a whole goal with no supervision — prepare, plan, start autopilot, work loop, review, handoff — plus overnight safeguards. ALWAYS use when the user runs /auto or /noite, asks you to "faz tudo sozinho", "automatiza", "trabalha enquanto durmo", "do it end to end", or hands you a large goal and goes away. Complements autonomous-workflow (the loop) with the pipeline around it (setup, budgets, safeguards, closing).
---

# Automation pipeline

`autonomous-workflow` is the **inner loop** (task → verify → commit). This skill is the **outer pipeline** that wraps it so a whole goal can run unattended.

## Levels that shape the pipeline

- Thinking level (`/pensamento`, skill `thinking-levels`) — depth per task. Default for unattended runs: **medio**; raise to **alto** only for risky tasks.
- Autonomy level (`/autonomia`, `AGENTS.md` §4.8) — how blockers are handled. Unattended runs use **alta** (or **total** if the user chose it).

## Pipeline

1. **Prepare (≤ 3 min)** — `bash scripts/session-start.sh`; placeholders still unfilled → skill `project-bootstrap`; confirm a git repository exists and `bash scripts/autocommit.sh status` says ACTIVE (no repo → `git init` + first commit).
2. **Budget** — default 120 min (`/auto`) or 8 h (`/noite`). Leave the last 15 min for the closing.
3. **Plan** — skill `planning`: goal → tasks in `TODO.md` with IDs, size and acceptance criteria; nothing larger than M (split L tasks). Write the session goal at the top of today's `PROGRESS.md` entry.
4. **Start autopilot** — `bash scripts/autopilot.sh start <min> [max-iterations]`.
5. **Run the loop** — skill `autonomous-workflow`. One commit per logical unit. Checkpoint `PROGRESS.md` every ~25 min.
6. **Close** — with ≤ 15 min left or an empty queue: `/review` → fix blockers → `/structure` (if code was added) → skill `session-handoff` → `bash scripts/autopilot.sh stop "done"`.

## Safeguards (always on in unattended runs)

| Risk | Safeguard |
|------|-----------|
| Crash loses work | Commit after every task; auto-commit checkpoints in between |
| Broken build snowballs | `check.sh` must be green before each commit; 3 red runs on different attempts → revert to last green on `wip/<date>` branch, log in `BUGS.md`, take another task |
| Scope creep | New ideas → `IDEAS.md`; only `TODO.md`/`ROADMAP.md` items are implemented |
| Endless loop | Skill `loop-recovery`; iteration limit and time budget in the autopilot plugin; a `STOP` file in the root ends everything |
| Irreversible / costly action | Never unattended: record in `QUESTIONS.md` with a default and skip |
| Secrets | `scripts/commit.sh` and the auto-commit plugin block them; never print or log secrets |
| Silent drift from the goal | Re-read the session goal in `PROGRESS.md` at every checkpoint |

## Stopping honestly

Stop when: budget spent · queue empty after the §4.4 order · everything left is blocked · `STOP` file. Say which one, and what is left. Never pad the time with invented work.

## Final report (≤ 10 lines)

Done (IDs) · decisions to validate (D-NNN) · needs the user (Q-NNN, with your default) · state (build/tests/branch/last hash) · next step.
