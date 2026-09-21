---
description: Add a task/note to the current weekly log
argument-hint: <summary of what was done>
---

Add an entry to the weekly work log in the team repo at `/home/pg/team/worklog/`.

Steps:
1. Determine today's date and the Monday of the current week using: `date -d "$(date +%Y-%m-%d) -$(( $(date +%u) - 1 )) days" +%Y-%m-%d`
2. The weekly file is at `/home/pg/team/worklog/<YYYY-MM-DD>.md` where the date is that Monday.
3. If the file doesn't exist, create it with the header:
   ```
   # Week of <Month Day, Year>

   ## Done

   ```
4. Append a new bullet under `## Done`:
   ```
   - [YYYY-MM-DD] <summary>
   ```
   where `YYYY-MM-DD` is **today's date** (not the Monday).
5. The summary is: `$ARGUMENTS`

Use the Edit tool to append the line. Do not reformat or change existing content.

Notes:
- Always write to `/home/pg/team/worklog/`, whatever the current working directory is. Never write the weekly log anywhere else, and never under `~/github/notes/`.
- This is a personal work log. It is separate from the generated team briefings under `/home/pg/team/briefings/weekly/`.
