---
description: "Interact with tmux panes to monitor logs, debug issues, restart services, and work across multiple terminals like an engineer would. Use this skill whenever the user asks to check what's running in a pane, read logs or output from another terminal, send commands to a tmux pane, restart a server, monitor a process, or debug across terminals. Also trigger when you need to observe the effect of code changes in a running service, or when the user references something happening in another pane or window. Even if the user doesn't say 'tmux' explicitly, use this when they say things like 'check the logs', 'restart the server', 'what's that error in the other terminal', or 'run this in the shell below'."
allowed-tools: Bash(tmux:*)
---

# Tmux Pane Interaction

Think of yourself as an engineer with multiple terminals open. You can see what's running, read output, send commands, and react to what you observe, just like sitting at the workstation yourself.

All tmux commands are pre-approved. Execute them without asking for confirmation.

## Scope: current session only

Always work within the current tmux session. The user is watching this session, so any interaction in other sessions is invisible to them and potentially disruptive. Never target panes in other sessions unless the user explicitly names one.

Use bare targets like `:.+`, `:.1`, `:servers.0` (no session prefix) so they resolve to the current session.

## Report what you see, don't invent

After discovering the layout, work with what actually exists. If the user asks to restart a server but there's no server running, tell them. If they ask to check logs but there's no log pane, say so. Don't create fake services, start random processes, or improvise work that wasn't asked for. The user knows their setup, just tell them what you found and ask what to do.

## 1. Discover the layout

Before interacting, understand what's available in this session:

```bash
# List all panes across all windows in the current session
tmux list-panes -s -F '#{window_index}:#{window_name} pane #{pane_index} [#{pane_width}x#{pane_height}] #{pane_current_command} #{?pane_active,(active),}'
```

Pane target shortcuts:
- `:.+` = next pane in current window
- `:.1` = pane 1 in current window
- `:servers.0` = pane 0 in the "servers" window
- `:2.1` = pane 1 in window index 2

## 2. Find a usable shell pane

When you need to run a command, identify a pane running a shell (`zsh`, `bash`, `sh`). Only send commands to shell panes.

**Do not send shell commands to panes running editors (nvim, vim, emacs) or other interactive programs (claude, python REPL, etc.).** Keystrokes sent to an editor will be interpreted as editor commands, not shell commands, causing unpredictable damage.

If the user asked you to run something but no shell pane exists, create one without stealing focus:

```bash
# Split current window, create shell pane, but keep focus on the current pane
tmux split-window -d -v
```

The `-d` flag is important: it creates the pane without switching focus to it. The user controls which pane has focus. Never use `select-pane`, `select-window`, or omit `-d` when creating panes.

After creating, the new pane is targetable as `:.+` or by its index. When done, you can close it:

```bash
tmux send-keys -t :.+ "exit" Enter
```

If the user asked about an existing process (restart server, check logs) and it's not there, just tell them. Don't create a pane and start something new.

## 3. Read pane content

Capture output from any pane (editors, logs, shells) to understand state:

```bash
# Last 100 lines (good default for checking recent output)
tmux capture-pane -t :.+ -p -S -100

# Last 500 lines (for digging deeper into logs)
tmux capture-pane -t :.+ -p -S -500

# Just what's visible on screen right now
tmux capture-pane -t :.+ -p
```

Reading is always safe regardless of what's running in the pane. Look for:
- Error messages, stack traces, panics
- Status indicators (listening on port X, connected, ready)
- Log levels (ERROR, WARN) that signal problems

## 4. Send commands to a shell pane

Once you've identified a shell pane:

```bash
# Interrupt whatever's running (Ctrl-C)
tmux send-keys -t :.+ C-c

# Clear and run a command
tmux send-keys -t :.+ "clear" Enter
tmux send-keys -t :.+ "cargo test" Enter
```

When sending commands:
- Always interrupt first (`C-c`) if something might be running
- Clear the terminal before running so you get clean output to read back
- Wait after sending, then capture the pane to read results

## 5. Workflows

### Run a command and check the result
```bash
tmux send-keys -t :.+ C-c
tmux send-keys -t :.+ "clear" Enter
tmux send-keys -t :.+ "cargo test" Enter
```
Wait a few seconds, then capture:
```bash
tmux capture-pane -t :.+ -p -S -50
```

### Restart a service
```bash
tmux send-keys -t :servers.0 C-c
sleep 1
tmux send-keys -t :servers.0 "npm run dev" Enter
```
Wait for it to start, then verify:
```bash
sleep 3
tmux capture-pane -t :servers.0 -p -S -20
```

### Monitor logs while making changes
1. Read the current error from the log pane
2. Fix the code
3. If the service has hot-reload, wait and re-read the pane
4. If not, restart the service, then re-read

### Debug a failing process
1. Discover layout to find the relevant pane
2. Capture its output to understand the error
3. Fix the root cause in code
4. Restart or re-run in that pane
5. Capture output again to confirm the fix

## 6. Tips

- Use `sleep` between sending a command and capturing output. Build commands need more time (5-10s), simple commands less (1-2s).
- Start with `-S -50` and only go deeper if needed.
- When the user says "check the logs" or "what's that error", discover panes first, then capture the most likely one.
- You can send arrow keys (`Up`), tab completion (`Tab`), and other special keys via `send-keys`.
