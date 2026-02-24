#!/bin/bash
# Save Claude's response to ~/notes/<date>/<topic>.md

INPUT=$(cat)

STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // empty')
[ -z "$MESSAGE" ] && exit 0

TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Extract the last user prompt from transcript for the filename
TOPIC=""
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  TOPIC=$(tac "$TRANSCRIPT" \
    | jq -r 'select(.type == "human") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null \
    | head -1)
fi

# Fallback: first line of assistant message
[ -z "$TOPIC" ] && TOPIC=$(echo "$MESSAGE" | head -1)

# Sanitize into a filename: lowercase, keep alnum/spaces, collapse, truncate
FILENAME=$(echo "$TOPIC" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9 ]/ /g' \
  | xargs \
  | tr ' ' '-' \
  | cut -c1-80)

[ -z "$FILENAME" ] && FILENAME="response"

DATE=$(date +%Y-%m-%d)
DIR="$HOME/notes/claude/$DATE"
mkdir -p "$DIR"

# Deduplicate: append a counter if file exists
TARGET="$DIR/$FILENAME.md"
if [ -f "$TARGET" ]; then
  i=2
  while [ -f "$DIR/$FILENAME-$i.md" ]; do
    ((i++))
  done
  TARGET="$DIR/$FILENAME-$i.md"
fi

cat > "$TARGET" <<EOF
$MESSAGE
EOF

exit 0
