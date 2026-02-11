#!/usr/bin/env bash
# Intercepts dunstctl action to focus chromium --app windows
# instead of opening a new browser tab via xdg-open.

MARKER_DIR="/tmp/dunst-app-markers"

# url_pattern | match_criteria | launch_command | workspace
APP_RULES=(
	"app.element.io|instance=\"app.element.io\"|chromium --app=https://app.element.io --profile-directory=\"Default\"|5"
	"discord.com|instance=\"discord.com\"|chromium --app=https://discord.com/app --profile-directory=\"Default\"|5"
	"web.whatsapp.com|instance=\"whatsapp.com\"|chromium --app=https://web.whatsapp.com --profile-directory=\"Default\"|5"
)

for rule in "${APP_RULES[@]}"; do
	IFS='|' read -r pattern criteria cmd ws <<<"$rule"
	markers=("$MARKER_DIR"/*."$pattern")
	if [ -e "${markers[0]}" ]; then
		rm -f "$MARKER_DIR"/*."$pattern"
		dunstctl close
		~/.config/i3/focus_or_start.sh "$criteria" "$cmd" "$ws"
		exit 0
	fi
done

# No marker — could be a history-popped notification that skipped the script rule.
# Close it (goes to history top), then check body to identify it.
dunstctl close
BODY=$(dunstctl history | python3 -c "
import sys,json;d=json.load(sys.stdin);n=d.get('data',[[]])[0]
print(n[0].get('body',{}).get('data','') if n else '')" 2>/dev/null)

for rule in "${APP_RULES[@]}"; do
	IFS='|' read -r pattern criteria cmd ws <<<"$rule"
	if [[ "$BODY" == *"$pattern"* ]]; then
		~/.config/i3/focus_or_start.sh "$criteria" "$cmd" "$ws"
		exit 0
	fi
done

# Not an app notification — restore it and run the default action
dunstctl history-pop
dunstctl action
