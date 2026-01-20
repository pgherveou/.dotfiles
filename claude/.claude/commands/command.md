---
description: Create a new custom slash command
argument-hint: <name>
---

Create a new custom slash command named `$ARGUMENTS`.

Ask the user:
1. Should this be a **project** command (`.claude/commands/$ARGUMENTS.md`) or **personal** command (`~/.claude/commands/$ARGUMENTS.md`)?
2. What should the command do? (description)
3. Does it need arguments? If so, what format?
4. What prompt/instructions should the command contain?

Then create the markdown file with appropriate frontmatter (description, argument-hint if needed) and the prompt content.
