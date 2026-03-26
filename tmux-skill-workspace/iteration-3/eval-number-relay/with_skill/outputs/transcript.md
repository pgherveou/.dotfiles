# Tmux Skill Test: Number Relay

**Date:** 2026-03-25
**Result:** PASS

## Phase 1: Setup - Discover Layout

Initial layout:
```
1:nvim pane 1 [195x47] claude (active)
2:servers pane 1 [195x47] python3 (active)
```

Created new pane with `tmux split-window -d -v`. New pane appeared at `:.2` running zsh.
Focus remained on pane 1 (claude) -- confirmed by `(active)` marker staying on pane 1.

Layout after split:
```
1:nvim pane 1 [195x23] claude (active)
1:nvim pane 2 [195x23] zsh
2:servers pane 1 [195x47] python3 (active)
```

## Phase 2: Writer A

Sent to `:.2`:
```
echo "NUM:1001"
echo "NUM:1002"
echo "NUM:1003"
```

Captured after 2s wait. All three numbers confirmed in output:
```
NUM:1001
NUM:1002
NUM:1003
```

## Phase 3: Writer B

Sent to the same pane `:.2`:
```
echo "NUM:2001"
echo "NUM:2002"
echo "NUM:2003"
```

Captured after 2s wait. All six numbers confirmed in output:
```
NUM:1001
NUM:1002
NUM:1003
NUM:2001
NUM:2002
NUM:2003
```

## Phase 4: Reader - Full Verification

Ran `tmux capture-pane -t :.2 -p -S -100` and extracted all `NUM:` lines.

**Expected:** 1001, 1002, 1003, 2001, 2002, 2003
**Found:**   1001, 1002, 1003, 2001, 2002, 2003

All 6 of 6 numbers present.

Extracted lines (output values only, excluding the echo command lines):
```
NUM:1001
NUM:1002
NUM:1003
NUM:2001
NUM:2002
NUM:2003
```

## Phase 5: Cleanup

Sent `exit` to `:.2`. Pane closed successfully.

Final layout matches original:
```
1:nvim pane 1 [195x47] claude (active)
2:servers pane 1 [195x47] python3 (active)
```

## Summary

| Check                          | Result |
|-------------------------------|--------|
| Pane created without stealing focus | Yes |
| Writer A: 1001, 1002, 1003   | Found  |
| Writer B: 2001, 2002, 2003   | Found  |
| All 6 numbers in final capture | Yes   |
| Pane cleaned up               | Yes    |
| Layout restored to original   | Yes    |

**PASS** - All checks passed.
