#!/bin/bash

ALERT_IF_IN_NEXT_MINUTES=30
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE=" "
NERD_FONT_MEETING=" "

get_next_meeting() {
	next_meeting=$(icalBuddy \
		--includeEventProps "title,datetime" \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--separateByDate \
		--bullet "" \
		eventsToday)
}

parse_result() {
	array=()
	for line in $1; do
		array+=("$line")
	done
	time="${array[2]}"
	title="${array[*]:5:30}"
}

calculate_times() {
	epoc_meeting=$(date -j -f "%T" "$time:00" +%s)
	epoc_now=$(date +%s)
	epoc_diff=$((epoc_meeting - epoc_now))
	minutes_till_meeting=$((epoc_diff / 60))
}

display_popup() {
	tmux display-popup \
		-S "fg=#eba0ac" \
		-w50% \
		-h50% \
		-d '#{pane_current_path}' \
		-T meeting \
		icalBuddy \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--formatOutput \
		--includeEventProps "title,datetime,notes,url,attendees" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--excludeCals "training" \
		eventsToday
}

print_tmux_status() {
	if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES &&
		$minutes_till_meeting -gt -60 ]]; then
		echo "$NERD_FONT_MEETING $time $title ($minutes_till_meeting minutes)"
	elif [[ $minutes_till_meeting -ge -60 ]]; then
		echo "$NERD_FONT_MEETING $time $title"
	else
		echo "$NERD_FONT_FREE"
	fi

	if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && epoc_diff -lt $ALERT_POPUP_BEFORE_SECONDS+10 ]]; then
		display_popup
	fi
}

main() {
	get_next_meeting
	parse_result "$next_meeting"
	calculate_times
	print_tmux_status
}

main
