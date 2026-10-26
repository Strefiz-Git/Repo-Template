# Template guide

This repository is a **template** for starting programming projects with [OpenCode](https://opencode.ai) already set up: management documents, skills, commands, agents, *auto commit* and an autonomous mode.

## 1. Starting a new project

```bash
cp -r repo-template my-project && cd my-project     # or "Use this template" on GitHub
bash scripts/init.sh "My Project" "Short description" "Stack (e.g. TypeScript + React)"
opencode
```

`init.sh` replaces the placeholders (`{{PROJECT_NAME}}`, `{{DESCRIPTION}}`, `{{STACK}}`, `{{DATE}}`), initializes git if needed, moves this guide to `docs/TEMPLATE_GUIDE.md` and makes the first commit.

Then, inside OpenCode:

1. `/bootstrap` — the agent detects the stack, fills in the build/test commands, `ARCHITECTURE.md`, `docs/CONVENTIONS.md`, the first `ROADMAP.md` and `TODO.md`.
2. Review `ROADMAP.md` (it is your direction; the agent proposes, you decide).
3. `/autopilot 120` — and let it work.

## 2. How the agent works

- **Startup:** reads `AGENTS.md`, `PROGRESS.md`, `QUESTIONS.md`, `TODO.md`, `ROADMAP.md`.
- **Loop:** choose a task → plan → implement → verify → record → commit → repeat.
- **Autonomy:** it only stops for real blockers. Before asking, it analyzes the doubt from **5 angles** (precedent, intent, external evidence, risk/reversibility, simplicity) and decides, recording it in `DECISIONS.md`.
- **Questions:** go to `QUESTIONS.md` (in a batch, with a default recommendation). **Answer below the question** in the file, or in the chat; the agent reads it next session.
- **Ideas:** go to `IDEAS.md`; they do not become code without moving to `TODO.md`/`ROADMAP.md`.

## 3. Commands

| Command | What it does |
|---------|--------------|
| `/bootstrap` | Sets up the project (first time) |
| `/start` | Session startup ritual and start of work |
| `/plan <goal>` | Breaks a goal into tasks with acceptance criteria |
| `/autopilot [min]` | Long autonomous work (default: 120 min) |
| `/autopilot-stop` | Stops autopilot |
| `/decide <question>` | 5-angle analysis + recorded decision |
| `/review [scope]` | Self-review → `REVIEW.md` |
| `/structure [scope]` | Audits folders, documentation and reuse, and fixes them |
| `/module <name>` | Creates a new module (public API, README, tests) and registers it |
| `/commit` | Organised commit of pending work |
| `/handoff` | Closes the session: updates docs and summarizes |
| `/status` | Quick summary of the project state |
| `/pensamento baixo\|medio\|alto\|auto [task]` | How deeply the agent thinks — see §10 |
| `/desbloquear-pensamento [hard]` | Gets the agent out of a loop — see §11 |
| `/continuar` | Resumes from the files (after `/new`, a crash or an unstick) — see §11 |
| `/autonomia guiada\|normal\|alta\|total` | How much the agent decides vs. asks — see §12 |
| `/auto <goal> [--min N]` | Whole goal, end to end, unattended — see §12 |
| `/noite [hours]` | Long unattended session (default 8 h) — see §12 |
| `/checkpoint` | Mid-session save: docs up to date + commit — see §12 |
| `/auto-commit status\|auto\|on\|off` | Controls auto commit — see §13 |
| `/comandos` | Lists every command, always up to date — see §14 |

## 4. Auto commit

The plugin `.opencode/plugins/auto-commit.js` makes a `chore(wip): checkpoint` commit whenever the session goes idle and there are changes.

- **On by default whenever a git repository is present** in the working folder (`"enabled": "auto"`); with no repository it stays idle — see §13.
- Config in `.opencode/autocommit.json` (see below), `/auto-commit`, or `AUTOCOMMIT=off` in the environment.
- Block sensitive files (`.env`, keys…) and secret patterns in the diff.
- Does **not** push by default (`"push": true` to enable).
- The "real" commits (with a good message) are made by the agent via the `auto-commit` skill / `scripts/commit.sh`.

```json
{ "enabled": "auto", "push": false, "minIntervalSeconds": 15, "blockSecrets": true, "skipBranches": [], "message": "chore(wip): checkpoint" }
```

## 5. Autopilot (experimental)

`/autopilot` writes `.opencode/autopilot.state` and the `autopilot.js` plugin sends a continuation prompt again when the agent goes idle, until:

- the time budget runs out (default 120 min) — it sends one last message to do a handoff;
- `scripts/autopilot.sh stop "reason"` (the agent calls it when it finishes or gets blocked);
- a `STOP` file exists in the root;
- an error or an interruption from you (Esc) — it **stops on purpose**;
- an iteration limit (default 60).

If the plugin API changes and the plugin stops working, the rest stays valid: the agent still follows the autonomy protocol in `AGENTS.md`, it is just not woken up automatically.

## 6. Customising

- **Permissions:** `opencode.json` (`git push` asks for confirmation; `push --force`, `sudo`, `rm -rf /` denied).
- **Skills:** `.opencode/skills/<name>/SKILL.md`. The folder name must match `name:`. Keep it < 500 lines and make the descriptions "insistent" about *when* to use them.
- **Language:** the docs are in English; commits in English. Change `AGENTS.md` (section 9) if you prefer another language.
- **Global skills:** copy folders from `.opencode/skills/` to `~/.config/opencode/skills/` to use them in every project.

## 7. Structure, documentation and reuse

The template pushes the agent to write **modular and reusable** code, well organized and documented:

- **Skills:** `reusable-modules` (reuse before writing; pure functions; minimal API; the 1-2-3 rule), `project-structure` (where each thing lives; by feature; moving safely) and `code-documentation` (docstrings, per-module README, comments only for the why).
- **Catalog:** `docs/MODULES.md` lists reusable modules and functions. The agent consults it (and runs `scripts/find-reuse.sh`) before writing new code, and updates it in the same commit.
- **Module README template:** `docs/templates/MODULE_README.md`.
- **Audit:** `scripts/structure-check.sh` (large files, modules without a README, `utils/misc/old` folders, backups, placeholders). It only warns; `--strict` fails. It runs inside `scripts/check.sh`.
- **Commands:** `/module <name>` creates a full module; `/structure` audits and fixes.
- **Adjusting limits:** `MAX_FILE_LINES=400 bash scripts/structure-check.sh`.

## 8. Windows

The scripts are `bash` (Git Bash or WSL). The plugins are plain JavaScript and work on any system.

## 9. Troubleshooting

| Symptom | Check |
|---------|-------|
| Skill does not appear | `SKILL.md` in uppercase; frontmatter with `name` and `description`; `name` = folder name; restart OpenCode |
| Plugin does not run | File in `.opencode/plugins/`; restart; check the OpenCode log |
| Auto commit does not commit | `git status`; `.opencode/autocommit.json`; a secret detected (see the log) |
| Agent stops too early | Use `/autopilot`; confirm that `QUESTIONS.md` has no blockers |
| Agent repeats the same thing | `/desbloquear-pensamento`; if it returns: `/desbloquear-pensamento hard` → `/new` → `/continuar` (§11) |
| Agent asks too much / too little | `/autonomia alta` (or `guiada`) — §12 |
| Agent over/under-thinks | `/pensamento alto` (or `baixo`) — §10 |
| New command does not appear | File in `.opencode/commands/<name>.md` with `description:` in the frontmatter; restart OpenCode; `/comandos` lists what was found |

---

# Parte 2 — Controlo da IA: pensamento, desbloqueio, autonomia e auto commit

> Esta parte está em português (PT-PT) porque é o guia de utilização no dia a dia. As instruções internas que o agente lê (skills e comandos) continuam em inglês, como o resto do template. Os nomes dos comandos novos estão em português.

**Resumo em 10 segundos**

| Quero… | Escrevo… |
|--------|----------|
| que a IA pense pouco / normal / muito | `/pensamento baixo`, `/pensamento medio`, `/pensamento alto` |
| tirar a IA de um loop | `/desbloquear-pensamento` (e, se voltar, `/desbloquear-pensamento hard` → `/new` → `/continuar`) |
| que ela decida mais sozinha | `/autonomia alta` |
| que ela faça um objetivo todo sozinha | `/auto <objetivo>` |
| que ela trabalhe a noite toda | `/noite 8` |
| saber o que existe | `/comandos` |

## 10. Controlo do pensamento — `/pensamento`

### O que é

Diz à IA **quanto deve ler, planear, comparar e verificar** antes e durante uma tarefa. O nível fica guardado em `.opencode/thinking.level` (ficheiro local, não vai para o git) e vale para as próximas tarefas e sessões até o mudares. Sem nada definido, o nível é **medio**.

### Sintaxe

```text
/pensamento                       → mostra o nível atual (não muda nada)
/pensamento baixo                 → muda o nível para baixo
/pensamento alto refactoriza o módulo de pagamentos
                                  → muda para alto E faz já essa tarefa
/pensamento auto                  → a IA escolhe o nível tarefa a tarefa
```

Aceita variantes: `baixo`/`low`/`1`/`b` · `medio`/`médio`/`medium`/`2`/`m` · `alto`/`high`/`3`/`a` · `auto`. Maiúsculas e acentos não importam. Se escreveres outra coisa, mostra as opções e não faz nada.

### O que cada nível muda

| | **baixo** (rápido) | **medio** (por defeito) | **alto** (a fundo) |
|---|---|---|---|
| Serve para | gralhas, renomear, textos, config, correções óbvias de 1 linha | funcionalidades normais, bugs com causa clara, refactors pequenos | arquitetura nova, segurança, migrações de dados, mudanças arriscadas, bugs teimosos, API pública |
| Lê | só o ficheiro que toca | ficheiro + quem o usa + testes + `docs/MODULES.md` | a área toda + `DECISIONS.md` + `ARCHITECTURE.md` + histórico git |
| Planeia | não | 3–6 passos | plano escrito com critérios de aceitação em `TODO.md` **antes** de codar |
| Decide | olha ao precedente | 3 ângulos | os **5 ângulos** + pre-mortem, registado em `DECISIONS.md` |
| Pesquisa | nunca | se a API for desconhecida | sempre, para tudo o que é externo |
| Casos limite | ignora | os 2–3 mais prováveis | lista explícita |
| Testes | só se algo partir | lógica não trivial | teste primeiro; teste de regressão por bug |
| Verifica | o check mais barato | `scripts/check.sh` | `check.sh` + cada critério + ler o próprio diff + `/review` |

**`auto`** — a IA escolhe por tarefa: sobe para *alto* se mexer em autenticação, pagamentos, apagar/migrar dados, concorrência, API pública, pipeline de build, se for tamanho L ou se o mesmo erro sobreviveu a 2 tentativas; desce para *baixo* em texto/config/renomeações verificáveis; senão *medio*.

### Regras que não mudam com o nível

- **Baixo não é descuidado:** segredos, comandos destrutivos e `check.sh` antes de fazer commit de código continuam obrigatórios.
- **Alto não é lento:** pensa uma vez, a fundo, e depois age. Não volta a deduzir o que já está em `DECISIONS.md`.
- Se uma tarefa *baixo* falhar uma vez de forma inesperada, a IA sobe um nível nessa tarefa.
- Se disseres na própria mensagem "faz isto rápido" ou "pensa a fundo", isso ganha ao nível guardado **só para essa tarefa**.
- O `/autopilot`, o `/auto` e o `/noite` repetem o nível guardado em cada iteração (o plugin passa-o no prompt).

### Limite importante (para não esperares o que isto não faz)

É um **protocolo de trabalho** (instruções que a IA segue), não um botão que muda o orçamento interno de raciocínio do modelo. Se o teu modelo/versão do OpenCode tiver uma "variante" com mais raciocínio, usa-a **também**; os dois efeitos somam-se. Scripts: `bash scripts/thinking.sh get|set <nivel>|reset`. Skill: `thinking-levels`.

## 11. Desbloquear a IA — `/desbloquear-pensamento` e `/continuar`

### O problema

Às vezes a IA entra em loop: repete a mesma frase, o mesmo comando, o mesmo "fix" que dá o mesmo erro, ou começa a escrever fragmentos aleatórios repetidos. Quanto mais repetição já está no chat, mais provável é a próxima repetição — o chat fica "contaminado".

### A solução em dois níveis

```text
/desbloquear-pensamento           → reset SUAVE (na mesma sessão)
/desbloquear-pensamento hard      → reset DURO (guarda tudo e pede sessão nova)
/continuar                        → retoma a partir dos ficheiros (use depois do /new)
```

**Suave** (por defeito), em 7 passos:

1. A IA **pára** o que estava a fazer (não acaba a frase nem a chamada).
2. Corre `scripts/unstick.sh`: grava `.opencode/RECOVERY.md` (estado do git, `TODO › Now`, `PROGRESS › Current state`, autopilot, níveis) e **pausa o autopilot** para o plugin não a acordar de volta para o loop.
3. Preenche no `RECOVERY.md` o **diagnóstico** (o que repetia · provável causa · o que não voltar a tentar) e o **próximo passo concreto**.
4. **Reconstrói o estado só a partir dos ficheiros** (`session-start.sh`, `PROGRESS.md`, `QUESTIONS.md`, `TODO.md`), sem reler o chat antigo.
5. Escolhe uma **estratégia diferente** (outra hipótese, problema mais pequeno, decidir a ambiguidade com os 5 ângulos, ou saltar a tarefa).
6. Faz **um** passo pequeno e verifica.
7. Retoma o autopilot (`scripts/autopilot.sh resume`) e diz-te em 4 linhas o que aconteceu.

**Duro** (`hard`): faz só os passos 1–3, garante que o que está estável fica em commit e diz-te para abrires uma **sessão nova** (`/new`) e correres `/continuar`.

### Porque é que existe o "hard" (a parte honesta)

Um comando não consegue apagar a memória (contexto) do modelo dentro da mesma conversa. O reset suave **muda a estratégia e reconstrói o estado a partir dos ficheiros**, mas a repetição antiga continua no histórico do chat. Se o loop voltar, a única limpeza real é uma conversa nova — por isso o reset duro guarda o estado em ficheiro e o `/continuar` retoma em segundos. Evita o `/compact` nesta situação: o resumo pode levar o loop com ele.

### Deteção automática

O `AGENTS.md` (§4.9) manda a IA fazer isto **sozinha** quando repete a mesma saída ou chamada 3 vezes, quando o mesmo erro sobrevive a 2 "correções" diferentes, ou quando passam 15+ chamadas de ferramentas sem facto novo nem edição. Em modo autopilot, cada mensagem de continuação lembra-lhe esta regra.

### `/continuar`

Retoma o trabalho **a partir dos ficheiros**: lê `.opencode/RECOVERY.md` (se existir) e segue o seu *próximo passo concreto*, faz o ritual de arranque, corre `check.sh` para saber o estado real e começa a próxima tarefa, sem resumos do passado. Serve também depois de um crash ou de o contexto ser compactado.

Ficheiros: `.opencode/RECOVERY.md` (local, ignorado pelo git; o `session-start.sh` avisa se existir). Scripts: `scripts/unstick.sh [soft|hard]`, `scripts/autopilot.sh pause|resume`. Skill: `loop-recovery`.

## 12. Autonomia e automação — `/autonomia`, `/auto`, `/noite`, `/autopilot`, `/checkpoint`

### `/autonomia` — quanto decide sozinha

```text
/autonomia            → mostra o nível atual
/autonomia alta       → muda
```

| Nível | Comportamento |
|-------|---------------|
| `guiada` | Antes de escolhas de design não triviais (dependência nova, mudar estrutura, API pública) ou tarefas de tamanho M ou maior, mostra um plano curto e pergunta no chat. |
| `normal` (por defeito) | Decide sozinha; só pergunta nos bloqueios reais (em lote, no `QUESTIONS.md`). |
| `alta` | Um bloqueio real **não pára** o trabalho: regista a pergunta com a recomendação por defeito, aplica-a como `Provisional` (se for reversível) e continua. Só salta o que exige credenciais, dinheiro ou ações irreversíveis. |
| `total` | Não pergunta nada durante a sessão. Ambiguidades decide-as com o melhor critério (registadas em `DECISIONS.md`); salta e regista o que exige credenciais, dinheiro ou irreversibilidade. |

Alias aceites: `baixa`, `media`, `maxima`, `sem-perguntas`, `1`–`4`. Os **limites de segurança não mudam com o nível**: nada de `push --force`, segredos no repositório, ações fora do repositório ou publicar/enviar coisas.

### `/auto <objetivo> [--min N]` — um objetivo, de ponta a ponta

```text
/auto adicionar login com email e palavra-passe
/auto migrar a base de dados para SQLite --min 180
/auto                      → trabalha a fila do TODO.md/ROADMAP.md (120 min)
```

O pipeline (skill `automation-pipeline`): **preparar** (ritual de arranque; `project-bootstrap` se faltar; garante repositório git e auto commit) → **planear** (tarefas com critérios de aceitação no `TODO.md`) → **ligar o autopilot** → **ciclo de trabalho** (implementar → `check.sh` → registar → commit) → **fechar** (`/review`, `/structure` se houve código, handoff, `autopilot stop`). Por defeito 120 minutos; `--horas H` também funciona.

### `/noite [horas]` — sessão longa sem supervisão

Por defeito 8 h (máx. 12). Põe a autonomia em `alta`, liga o autopilot com limite de 250 iterações e acrescenta travões: commit muito frequente, `/review` a cada ~90 min, 3 `check.sh` vermelhos seguidos → volta ao último verde numa branch `wip/noite-<data>` e passa a outra tarefa, nunca começa nada destrutivo/pago/com credenciais. Sem repositório git, faz `git init` e o primeiro commit antes de arrancar.

### `/autopilot [min]` e `/autopilot-stop`

O mecanismo por baixo do `/auto` e do `/noite` (secção 5): quando a IA fica parada, o plugin volta a acordá-la até acabar o orçamento. Agora aceita também um limite de iterações (`bash scripts/autopilot.sh start 120 80`) e `pause`/`resume`. Para tudo de imediato: criar um ficheiro `STOP` na raiz, ou `/autopilot-stop`.

### `/checkpoint`

Guardar a meio, **sem fechar a sessão**: `check.sh`, atualiza `TODO.md` e `PROGRESS.md › Current state` (com o próximo passo concreto), commit lógico se estiver verde, e mostra o tempo que falta. Menos pesado que `/handoff`.

### Combinações úteis

| Situação | Comandos |
|----------|----------|
| Tarefa pequena e rápida | `/pensamento baixo` → pede a tarefa |
| Funcionalidade média, sem te chatear | `/autonomia alta` + `/auto <objetivo>` |
| Mudança arriscada, quero que pense bem | `/pensamento alto` + `/autonomia guiada` |
| Vou dormir | `/pensamento medio` + `/noite 8` |
| A IA entrou em loop a meio da noite | (o plugin já a avisa) → de manhã: `/continuar` |

Scripts: `scripts/autonomy.sh get|set|reset`, `scripts/autopilot.sh start|stop|pause|resume|status`, `scripts/clock.sh`. Skills: `automation-pipeline`, `autonomous-workflow`, `decide-without-asking`.

## 13. Auto commit por defeito — `/auto-commit`

### Regra

Se na pasta onde estás a trabalhar existe um **repositório git**, o auto commit está **ligado por defeito**. Se não existe, fica parado e começa sozinho assim que houver um (por exemplo, depois de `git init`). Configuração: `"enabled": "auto"` em `.opencode/autocommit.json`.

- O que faz: quando a sessão fica parada e há alterações, faz `chore(wip): checkpoint (N files)`.
- O que **nunca** faz: `push` (a não ser que ligues), commitar `.env`/chaves/certificados, ou commitar um diff com padrões de segredos (cancela e avisa).
- Os commits "a sério", com boa mensagem, continuam a ser feitos pela IA com `scripts/commit.sh` (skill `auto-commit`). O checkpoint é só a rede de segurança.
- O `AGENTS.md` (§6) diz à IA para **não desligar** o auto commit por iniciativa própria e para **não fazer `git init` sozinha** (exceto em `/auto` e `/noite`, onde pediste automação total).
- A primeira linha do `scripts/session-start.sh` mostra se está ativo; a IA vê isso no arranque.

### Comandos

```text
/auto-commit               → estado (ativo / parado por falta de repo / desligado)
/auto-commit auto          → o comportamento por defeito (liga se houver repo)
/auto-commit on | off      → forçar ligado / desligado
/auto-commit push-on|push-off → fazer (ou não) push depois de cada checkpoint
```

Num terminal, `AUTOCOMMIT=off opencode` desliga só nessa sessão (e `AUTOCOMMIT=on` força). Opções do `autocommit.json`: `enabled` (`"auto"`/`true`/`false`), `push`, `minIntervalSeconds`, `blockSecrets`, `skipBranches` (ex.: `["main"]` para nunca fazer checkpoints nessa branch) e `message`.

### Em qualquer pasta, mesmo sem o template

```bash
bash scripts/install-global.sh            # instala o plugin em ~/.config/opencode/plugins/
bash scripts/install-global.sh --skills   # + copia as skills para ~/.config/opencode/skills/
bash scripts/install-global.sh --uninstall
```

Reinicia o OpenCode depois. Só o plugin é instalado globalmente; os comandos (`/pensamento`, `/auto`…) não, porque chamam `scripts/*.sh` do próprio projeto. Se um projeto tiver também a cópia do template, só uma das duas age (há uma guarda no plugin).

### Cuidados

- O checkpoint faz commit de **tudo** o que não é sensível, incluindo alterações que já estavam por commitar antes da sessão. Num repositório com trabalho a meio de outra pessoa (ou teu), vê `git status` primeiro, ou usa `skipBranches`/`/auto-commit off`.
- Não faz push, por isso o histórico fica local até decidires.

## 14. Referência rápida

### Todos os comandos

`/comandos` mostra a lista **gerada a partir dos ficheiros** (nunca fica desatualizada). Resumo:

| Grupo | Comandos |
|-------|----------|
| Começar e planear | `/bootstrap` · `/start` · `/continuar` · `/plan` · `/status` |
| Autonomia e automação | `/auto` · `/noite` · `/autopilot` · `/autopilot-stop` · `/autonomia` |
| Controlo da IA | `/pensamento` · `/desbloquear-pensamento` |
| Código e qualidade | `/module` · `/structure` · `/review` · `/decide` |
| Git e sessão | `/commit` · `/auto-commit` · `/checkpoint` · `/handoff` |

### Skills novas

| Skill | Para que serve |
|-------|----------------|
| `thinking-levels` | Define o que baixo/medio/alto/auto significam em leitura, planeamento, decisões, testes e verificação |
| `loop-recovery` | Deteta loops, faz reset suave/duro e reconstrói o estado a partir dos ficheiros |
| `automation-pipeline` | O pipeline à volta do ciclo de trabalho: preparar, planear, autopilot, fechar, e os travões para correr sem supervisão |

### Scripts novos

| Script | Função |
|--------|--------|
| `scripts/thinking.sh` | `get` / `set <nivel>` / `reset` do nível de pensamento |
| `scripts/autonomy.sh` | `get` / `set <nivel>` / `reset` do nível de autonomia |
| `scripts/autocommit.sh` | `status` / `auto` / `on` / `off` / `push-on` / `push-off` |
| `scripts/unstick.sh` | Snapshot de recuperação + pausa do autopilot (`soft`/`hard`) |
| `scripts/commands.sh` | Lista os comandos (usado pelo `/comandos`) |
| `scripts/install-global.sh` | Instala o auto commit globalmente (plugin, e opcionalmente skills) |

### Estado local (não vai para o git)

`.opencode/thinking.level` · `.opencode/autonomy.level` · `.opencode/RECOVERY.md` · `.opencode/autopilot.state` · `.opencode/.session-start`. Para "limpar tudo": apaga estes ficheiros (voltam aos valores por defeito: pensamento `medio`, autonomia `normal`).

### Adicionar mais comandos ou skills

- **Comando:** cria `.opencode/commands/<nome>.md` com `description:` no frontmatter e o prompt no corpo (`$ARGUMENTS` = tudo o que escreveste a seguir ao comando, `$1`, `$2`… = argumentos separados). O nome do ficheiro é o nome do comando. Reinicia o OpenCode. Aparece logo no `/comandos`.
- **Skill:** cria `.opencode/skills/<nome>/SKILL.md` (o `name:` tem de ser igual ao nome da pasta; a `description:` deve dizer claramente **quando** usar). Acrescenta uma linha à tabela da §10 do `AGENTS.md`.
