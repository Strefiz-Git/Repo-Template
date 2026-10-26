---
name: skills-library
description: Find and install skills from the central library OpenCode-Skills-Repo (https://github.com/Strefiz-Git/OpenCode-Skills-Repo) when this project lacks a skill for the task. ALWAYS use when the user runs /skills, asks "is there a skill for…", or when the work is domain-specific and none of the skills in .opencode/skills/ covers it — Minecraft/Fabric mods, Android/Kotlin, Godot, Discord bots, Flask/Socket.IO, Prisma/SQLite, Windows desktop or services, C/MinGW, Python tool runners, multi-language parity, API research, release and git flows.
---

# Skills library

This template ships only the general skills. Specific ones live in **OpenCode-Skills-Repo** (100+ skills in categories such as `minecraft`, `mobile`, `godot`, `discord`, `web`, `database`, `devops`, `desktop-windows`, `integrations`, `git-release`). The template works without it; use it when it saves work.

## When to look

- The task is domain-specific and no installed skill in `AGENTS.md` §10 fits.
- You are about to write a long checklist or recipe that probably exists already (setup, port, release, build, packaging).
- The user asks for a skill, a plugin, a command or a template "from the other repo".
- `/bootstrap` just detected a stack (see `project-bootstrap`).

## Steps

1. **Search**: `bash scripts/skills-repo.sh search <keyword>` (or `list [category]`). The full catalog is `CATALOG.md` in the library repo.
2. **Read before installing**: `bash scripts/skills-repo.sh show <name>`. Skills are instructions the agent will follow, so read them like code. Check `scope`: `generic` skills fit any project; `project-specific` ones are worked examples to adapt, not to follow blindly.
3. **Install only what the task needs**: `bash scripts/skills-repo.sh install <name>...`. Avoid installing a whole category by reflex; more skills means more noise in the agent's list.
4. **Register**: add a row for each new skill to the table in `AGENTS.md` §10 and note the choice in `DECISIONS.md`.
5. **Commit** the installed skills with the code that needs them (`chore: add skill <name> from OpenCode-Skills-Repo`).

Besides skills, the library also has `plugins/`, `commands/`, `agents/` and `templates/`. Read them in the library repo and copy by hand what you need.

## Pitfalls

- Offline or private network: the script uses the last cached copy; if there is none, skip it and continue with the installed skills.
- Name clash with an installed skill: the script refuses unless `--force`; compare both versions before overwriting.
- Imported skills may be in Portuguese and some come from an AGPL-3.0 project (the `license` field says which). Check it before copying into a closed-source product.
- Do not copy secrets or project-specific paths from a `project-specific` skill into this repo.

## Done when

- [ ] The needed skill is in `.opencode/skills/<name>/` and listed in `AGENTS.md` §10.
- [ ] `DECISIONS.md` says why it was added.
- [ ] Nothing unnecessary was installed.
