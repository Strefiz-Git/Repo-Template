---
description: Tira a IA de um loop/bug (repete a mesma coisa) — reset suave a partir dos ficheiros. Usa "hard" para sessão nova
---
Use the skill `loop-recovery`. The agent (you) may be stuck in a loop, repeating the same text, tool call or idea. **Break out of it now.**

Mode: `$ARGUMENTS` (empty or `soft` = soft reset; `hard` = save state and ask for a new session).

Rules for the whole command:

- **Stop the current line of thought.** Do not continue, finish or re-read the repeated text. Whatever you were about to say next is probably part of the loop.
- **Do not trust the earlier chat.** The only truth is: the repository files, `git log`/`git status`, and `bash scripts/check.sh`.
- Keep every message of this command short (no long recap).

Steps:

1. Run `bash scripts/unstick.sh $ARGUMENTS`. It saves `.opencode/RECOVERY.md` (git state, TODO › Now, PROGRESS › Current state, autopilot) and **pauses the autopilot** so it does not wake you up back into the loop.
2. Open `.opencode/RECOVERY.md` and fill in **Loop diagnosis** (what was repeated · probable trigger · what must NOT be tried again) and **Next concrete step** (one specific action: file or command). Maximum 5 lines in total.
3. **If the mode is `hard`:** stop here. Tell the user in 3 lines: `Estado guardado em .opencode/RECOVERY.md. Abre uma sessão nova (/new) e corre /continuar.` Do not do anything else.
4. **Soft mode:** rebuild your state from files only — `bash scripts/session-start.sh`, `PROGRESS.md › Current state`, `QUESTIONS.md`, `TODO.md › Now`. Do not scroll back through the old conversation.
5. Pick a **different strategy** from the one that looped (skill `debugging`: alternative hypotheses; skill `decide-without-asking` if it was an ambiguity). Take only the **smallest next step** and verify it.
6. If the autopilot was running: `bash scripts/autopilot.sh resume`.
7. Tell the user in ≤ 4 lines: what looped, what you will do differently, and: *"se voltar a repetir, usa `/desbloquear-pensamento hard`, abre `/new` e corre `/continuar`"*.
