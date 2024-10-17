#!/bin/bash

# Run the command and capture its output
link=$(gh pr checks --json "event,completedAt,name,link,description,state" | jq -r '[.[] | select(.state == "FAILURE" and .name != "review-bot")] | sort_by(.completedAt) | .[0].link')

if [ $? -ne 0 ]; then
	exit 0
fi
