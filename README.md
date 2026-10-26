# {{PROJECT_NAME}}

{{DESCRIPTION}}

> **Status:** in progress · **Stack:** {{STACK}} · **Created:** {{DATE}}

## What it does

<!-- 2–4 sentences: the problem it solves and for whom. Fill in with /bootstrap. -->

## Features

- [ ] _to be filled in_

## Getting started

```bash
# 1. Install dependencies
# TODO

# 2. Run
# TODO

# 3. Tests
# TODO
```

## Repository structure

```
.
├── AGENTS.md          # rules for AI agents
├── ROADMAP.md         # vision and milestones
├── TODO.md            # task queue
├── PROGRESS.md        # current state and session log
├── DECISIONS.md       # technical decisions
├── QUESTIONS.md       # questions for the user
├── BUGS.md            # known bugs
├── REVIEW.md          # self-reviews
├── IDEAS.md           # out-of-scope ideas
├── ARCHITECTURE.md    # architecture
├── CHANGELOG.md       # version history
├── docs/              # conventions, testing, design, glossary, module catalog (MODULES.md)
├── scripts/           # utilities (check, commit, autopilot, thinking, autonomy, unstick…)
├── .opencode/         # OpenCode skills, commands, agents and plugins
└── src/               # code (to be created)
```

## Development with OpenCode

```bash
opencode                 # open at the repo root
/bootstrap               # (first time) fill in the docs and the project commands
/pensamento alto         # how deeply the AI thinks: baixo | medio | alto | auto
/autonomia alta          # how much it decides on its own: guiada | normal | alta | total
/auto <goal>             # a whole goal, end to end, unattended (or /autopilot 120, /noite 8)
/desbloquear-pensamento  # the AI is looping? soft reset (add "hard" -> /new -> /continuar)
/skills <keyword>        # need a domain-specific skill? find and install it from the skills library
/comandos                # list every command
```

Auto commit is **on by default whenever a git repository is present** in the working folder.

### More skills

This template only ships the general skills. Specific ones (Minecraft/Fabric mods, Android/Kotlin, Godot, Discord bots, web apps, databases, Windows apps, release flows…), plus extra plugins, commands, agents and templates, are in the central library **[OpenCode-Skills-Repo](https://github.com/Strefiz-Git/OpenCode-Skills-Repo)** ([catalog](https://github.com/Strefiz-Git/OpenCode-Skills-Repo/blob/main/CATALOG.md)).

```bash
bash scripts/skills-repo.sh search fabric             # find
bash scripts/skills-repo.sh install fabric-hud-overlay # copy into .opencode/skills/
```

The agent does this on its own through the `skills-library` skill when the task needs one.

See `docs/TEMPLATE_GUIDE.md` for the full workflow guide.

## Contributing

Commits follow [Conventional Commits](https://www.conventionalcommits.org/). Before submitting: `bash scripts/check.sh`.

## License

_To be defined._
