---
description: Sessão longa sem supervisão (por defeito 8 h) com mais iterações e travões de segurança. /noite [horas]
---
Use the skills `automation-pipeline` and `autonomous-workflow`.

Hours (optional): `$ARGUMENTS` (default **8**; accept decimals like `4.5`; maximum 12). Minutes = hours × 60.

1. Set conservative-but-autonomous settings: `bash scripts/autonomy.sh set alta` and, unless the user already chose a level today, `bash scripts/thinking.sh set medio`.
2. Confirm that there is a git repository and that auto-commit is active: `bash scripts/autocommit.sh status`. **Without a git repository, do not start**: run `git init`, make the first commit and continue.
3. Start the autopilot with a high iteration limit: `bash scripts/autopilot.sh start <minutes> 250`.
4. Work with `/auto`'s pipeline, plus these overnight safeguards:
   - checkpoint `PROGRESS.md` every ~25 min and **commit often** (a crash must lose at most one task);
   - `/review` of what was built roughly every 90 minutes;
   - if `bash scripts/check.sh` fails 3 times in a row on different attempts, revert to the last green commit on a branch `wip/noite-<date>`, record it in `BUGS.md` and move to another task;
   - never start a task that is destructive, costs money or needs credentials — leave it in `QUESTIONS.md` with a default recommendation;
   - repeating yourself = skill `loop-recovery`.
5. At the end: handoff, `bash scripts/autopilot.sh stop "done"`, and a summary of the night (≤ 10 lines, with a short list of commits).
