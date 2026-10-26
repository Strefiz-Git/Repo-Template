---
description: Lista todos os comandos disponíveis com uma linha de explicação cada
---
Current commands (generated from `.opencode/commands/`, always up to date):

!`bash scripts/commands.sh`

Show them to the user grouped like this, in the user's language, one line each, without inventing commands that are not in the list above:

1. **Começar e planear** — `bootstrap`, `start`, `continuar`, `plan`, `status`
2. **Autonomia e automação** — `auto`, `noite`, `autopilot`, `autopilot-stop`, `autonomia`
3. **Controlo da IA** — `pensamento`, `desbloquear-pensamento`
4. **Código e qualidade** — `module`, `structure`, `review`, `decide`
5. **Git e sessão** — `commit`, `auto-commit`, `checkpoint`, `handoff`

Any command in the list that is not in these groups goes under **Outros**. End with: *"Detalhes e exemplos: `TEMPLATE_GUIDE.md` (secções 10–14)."* (it is `docs/TEMPLATE_GUIDE.md` in projects created with `scripts/init.sh`).
