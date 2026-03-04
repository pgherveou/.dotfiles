---
description: Tidy claude session logs for a given day
argument-hint: <YYYY-MM-DD or "today" or "yesterday">
---

Process claude session logs from `/home/pg/notes/claude/<date>/` and consolidate useful content into proper notes.

## Steps

1. **Resolve the date** from `$ARGUMENTS` (handle "today", "yesterday", or a literal YYYY-MM-DD).
2. **Read every `.md` file** in `/home/pg/notes/claude/<date>/`.
3. **Classify each file** into one of:
   - **Keep** — contains research, explanations, architecture walkthroughs, technical deep-dives, or educational content that would be useful as a standalone reference note.
   - **Discard** — action logs ("Done. Here's what changed…"), status updates, commit summaries, PR creation confirmations, "all tests pass" reports, configuration change logs, or other ephemeral session output.
4. **Present a summary** to the user showing the classification:
   - For each "Keep" file: a one-line summary and a proposed note title/path
   - Count of files to discard
   Ask the user to confirm before proceeding.
5. **For each "Keep" file**:
   - If there is already a note in `~/notes/` on the same topic, merge the new content into it using the Edit tool.
   - Otherwise, create a new note at `~/notes/<topic>.md` with a clean title and well-structured content. Strip conversational artifacts (e.g., "Good question.", "Here's what I found.") — keep only the substantive technical content.
6. **Delete all processed files** from the day's claude folder (both kept-and-consolidated and discarded). Remove the day directory if it's now empty.
7. **Report** what was created/updated and what was removed.

## Guidelines
- Titles should be short and descriptive (e.g., `bump-allocator.md`, `parachain-validation-data.md`)
- Group related files into a single note when they cover the same topic
- Preserve code blocks, tables, and diagrams exactly
- Do not add fluff or commentary — keep notes concise and factual
