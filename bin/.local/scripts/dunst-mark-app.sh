#!/usr/bin/env bash
MARKER_DIR="/tmp/dunst-app-markers"
mkdir -p "$MARKER_DIR"
for pattern in app.element.io discord.com web.whatsapp.com; do
	if [[ "$DUNST_BODY" == *"$pattern"* ]]; then
		touch "$MARKER_DIR/$DUNST_ID.$pattern"
		break
	fi
done
