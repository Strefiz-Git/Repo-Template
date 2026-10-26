---
description: Ponto de guardar a meio da sessão — docs em dia + commit, sem fechar a sessão
---
Mid-session checkpoint (not an end of session). Note (optional): $ARGUMENTS

1. `bash scripts/check.sh` — learn the real state.
2. Update `TODO.md` (tick what is done) and `PROGRESS.md › Current state`: what you are doing, what is left, build health, **next concrete step**.
3. If green → commit the pending work in logical commits (`bash scripts/commit.sh "type(scope): message" paths…`, skill `auto-commit`). If red → do not commit broken code; record it in `BUGS.md` or isolate it on a WIP commit and say so in `PROGRESS.md`.
4. `bash scripts/clock.sh` → report elapsed/remaining time.
5. One line to the user: `Checkpoint feito: <hash> · build ✅/❌ · próximo passo: …`. Then continue working.
