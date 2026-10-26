---
name: loop-recovery
description: Detect and break out of loops — the agent repeating the same text, tool call, error fix or idea, or producing degenerate/random repeated output — and restart cleanly from the files. ALWAYS use when the user runs /desbloquear-pensamento or says "está preso", "entrou em loop", "repete sempre a mesma coisa", "bugou", "stuck in a loop"; when you notice you produced the same output or the same tool call 3 times; when the same command fails twice with the same error; or when an autopilot iteration makes no measurable progress.
---

# Loop recovery

A loop = **you keep doing the same thing and expecting a different result.** Typical shapes:

- the same sentence/paragraph repeated, or text that drifts into random repeated fragments;
- the same tool call (same arguments) again and again;
- fix → error → same fix → same error;
- reading the same files over and over without starting to edit;
- asking/answering the same question in different words.

The chat itself is now **contaminated** by the repetition: the more of it is in the context, the more likely the next token repeats it. So the cure is to **move the truth out of the chat and into files, and (if needed) leave the chat.**

## Self-detection (do this without being asked)

Stop and run the recovery if **any** is true:

1. You are about to emit text or a tool call identical (or nearly) to one of your last 3.
2. The same error appeared 2 times after 2 different "fixes" that were really the same idea.
3. 10+ minutes (`bash scripts/clock.sh`) or 15+ tool calls without a new file edit, a new test result or a new fact.
4. You catch yourself "re-reading to be sure" something you already read.

## Soft reset (default) — stay in the same session

1. **Stop.** Do not finish the sentence or the call you were about to make.
2. `bash scripts/unstick.sh` → writes `.opencode/RECOVERY.md` (git state, TODO › Now, PROGRESS › Current state, autopilot) and pauses the autopilot.
3. Fill in **Loop diagnosis** (what repeated · probable trigger · what must **not** be tried again) and **Next concrete step** in `RECOVERY.md`. Max 5 lines. Probable triggers to check: an error being retried unchanged · ambiguous/contradictory instruction · huge tool output flooding the context · a missing file/permission · a test that cannot pass · waiting for an answer that never comes.
4. **Rebuild state from files only:** `bash scripts/session-start.sh`, `PROGRESS.md › Current state`, `QUESTIONS.md`, `TODO.md › Now`, `bash scripts/check.sh`. Do not scroll the old chat.
5. **Change the strategy.** Options, in order: (a) different hypothesis (skill `debugging`) · (b) shrink the problem to the smallest reproducible step · (c) decide the ambiguity with the 5 angles (`decide-without-asking`) · (d) skip the task: mark it blocked in `TODO.md`/`BUGS.md` and pick another.
6. Take **one** small step and verify it. Then continue the normal loop.
7. `bash scripts/autopilot.sh resume` if it was running.

## Hard reset — leave the contaminated chat

Use when the soft reset does not hold (the repetition comes back), the output is gibberish, or the user runs `/desbloquear-pensamento hard`:

1. `bash scripts/unstick.sh hard` and fill in `RECOVERY.md`.
2. Make sure everything stable is committed (`bash scripts/commit.sh …`) or isolated (WIP commit/branch).
3. Tell the user, in 3 lines: state saved in `.opencode/RECOVERY.md` · open a new session (`/new`) · run `/continuar`.
4. **Stop.** Do nothing else in this session.

`/compact` summarizes the chat and may carry the loop into the summary — prefer a new session.

## After recovering

- Add a line to `BUGS.md` if the loop came from a real defect (a test that cannot pass, a script that hangs), or to `DECISIONS.md` if you decided around an ambiguity.
- Delete `.opencode/RECOVERY.md` once its **Next concrete step** has been used (`/continuar` does it).

## Anti-patterns

- "One more try" with the same command.
- Apologizing and re-explaining instead of changing approach.
- Reading the repeated text to "understand" it — it carries no information.
- Asking the user a question to escape the loop when files would answer it.
