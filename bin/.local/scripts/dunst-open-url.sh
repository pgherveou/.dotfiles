#!/usr/bin/env bash
# dunst `browser` handler. Focuses a chromium --app window for known app URLs
# instead of opening a new browser tab; falls back to xdg-open otherwise.
#
# Why this exists: a live Chromium notification carries a dbus action that
# Chromium handles natively (focusing its --app window). Once the notification
# goes to history and is recalled (dunstctl history-pop), that action is stale,
# so dunst falls back to opening the body URL via this `browser` command.

URL="$1"

# url_pattern | match_criteria | launch_command | workspace
APP_RULES=(
	"app.element.io|instance=\"app.element.io\"|chromium --app=https://app.element.io --profile-directory=\"Default\"|5"
	"discord.com|instance=\"discord.com\"|chromium --app=https://discord.com/app --profile-directory=\"Default\"|5"
	"web.whatsapp.com|instance=\"whatsapp.com\"|chromium --app=https://web.whatsapp.com --profile-directory=\"Default\"|5"
)

for rule in "${APP_RULES[@]}"; do
	IFS='|' read -r pattern criteria cmd ws <<<"$rule"
	if [[ "$URL" == *"$pattern"* ]]; then
		exec ~/.config/i3/focus_or_start.sh "$criteria" "$cmd" "$ws"
	fi
done

exec xdg-open "$URL"
