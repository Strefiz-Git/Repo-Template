---
name: thinking-levels
description: How deeply to deliberate before and while acting — levels baixo (low), medio (medium) and alto (high), set with /pensamento and stored in .opencode/thinking.level. ALWAYS use at the start of every task, when the user runs /pensamento, says "pensa bem", "pensa a fundo", "faz rápido", "think hard", "quick fix", or when you are unsure how much effort a task deserves. Defines what to read, plan, verify and review at each level, and how level "auto" picks one per task.
---

# Thinking levels

The level answers one question: **how much deliberation does this task deserve?** It changes *how much you read, plan, compare and verify* — never the safety rules, never the Definition of Done in `AGENTS.md` §7 for code that ships.

Read the level: `bash scripts/thinking.sh get` (also shown by `scripts/session-start.sh`). No file = **medio**.
Change it: `/pensamento <level>` → `bash scripts/thinking.sh set <level>`.

> This is a *working-depth* setting for the agent (a prompt-level protocol). It does not change the provider's internal reasoning budget of the model; if your model/OpenCode version has a model "variant" with more reasoning, use it **in addition** (see `TEMPLATE_GUIDE.md` §10).

## The three levels

| | **baixo** (fast) | **medio** (default) | **alto** (deep) |
|---|---|---|---|
| Use for | typos, renames, copy changes, docs, config tweaks, obvious one-line fixes, throwaway scripts | normal features, bug fixes with a clear cause, small refactors | new architecture, risky/irreversible changes, security, data migrations, hard bugs, public APIs, anything that failed twice |
| Reading | only the file(s) you touch | the file + its callers/tests + `docs/MODULES.md` (reuse check) | the whole area: callers, tests, `DECISIONS.md`, `ARCHITECTURE.md`, git history of the file |
| Planning | none — just do it | 3–6 step plan in your head or `PROGRESS.md` | written plan with acceptance criteria in `TODO.md` (skill `planning`) **before** coding |
| Decisions | angle 1 (precedent) only | angles 1, 2 and 4 | all **5 angles** + pre-mortem; record in `DECISIONS.md` (skill `decide-without-asking`) |
| Research | never | when an API/library is unfamiliar | `research-first` for every external API/lib/behavior you rely on |
| Edge cases | skip | name the 2–3 most likely | list them explicitly (empty, huge, concurrent, failure, permission, encoding…) |
| Tests | none unless a test already breaks | tests for non-trivial logic | test first when possible; regression test for every bug |
| Verify | the cheapest check that proves it (run it, or `check.sh` if code) | `bash scripts/check.sh` | `check.sh` + manual check of every acceptance criterion + read your own diff |
| Review | none | quick look at the diff | `/review` (skill `code-review`), and `@critic` / `@reviewer` for big decisions |
| Messages | 1–2 lines | short | short, but include the reasoning behind decisions in `DECISIONS.md`, not in chat |

## Level `auto`

Pick the level **per task** from the signals, and say which one you picked in one line when it is not `medio`:

- → **alto** if the task touches auth, payments, data deletion/migration, concurrency, the public API, the build/release pipeline, or the same bug survived 2 attempts, or the task is size L.
- → **baixo** if it is a text/docs/config change with no logic, or a rename the compiler/IDE can verify.
- → **medio** otherwise.

## Rules that do not depend on the level

- **Alto ≠ slow-motion.** Deliberate *once*, thoroughly, then act. Do not re-derive a conclusion you already wrote in `DECISIONS.md`.
- **Baixo ≠ careless.** Never skip a safety check: secrets, destructive commands and `check.sh` before committing code stay mandatory.
- **Escalate on evidence.** If a `baixo` task fails once unexpectedly, move up one level for that task. Two failures on the same approach at any level → change strategy (skill `debugging`) and, if you start repeating yourself, skill `loop-recovery`.
- **De-escalate when it is mechanical.** At `alto`, a purely mechanical sub-step (renaming, formatting) does not need the full ritual.
- A level the user sets explicitly in the message ("faz isto rápido") overrides the stored level **for that task only**.
- Autopilot (`/autopilot`, `/auto`, `/noite`) keeps applying the stored level in every iteration.

## Quick self-check before you start a task

1. What level applies? (`thinking.sh get`; if `auto`, decide now.)
2. Is there something at this level that I am skipping because it is boring? (planning, edge cases, verification)
3. Is there something at this level that I am doing out of habit but is not needed? (reading the whole repo for a typo)
