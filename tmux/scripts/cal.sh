#!/bin/bash

ALERT_IF_IN_NEXT_MINUTES=30
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE=" "
NERD_FONT_MEETING=" "

get_next_meeting() {
    next_meeting=$(
        gcalcli agenda \
            --tsv \
            --nostarted \
            --nodeclined \
            --calendar pgherveou@parity.io \
        | sed 1d \
        | grep -P '^[0-9]{4}-[0-9]{2}-[0-9]{2}\t[0-9]{2}:[0-9]{2}\t[0-9]{4}-[0-9]{2}-[0-9]{2}\t[0-9]{2}:[0-9]{2}\t.+$' \
        | head -n1
    )
}

parse_result() {
    IFS=$'\t' read -r event_date start_time end_date end_time title <<< "$1"
}

calculate_times() {
    epoc_meeting=$(date -d "$event_date $start_time" +%s)
    epoc_now=$(date +%s)
    epoc_diff=$((epoc_meeting - epoc_now))
    minutes_till_meeting=$((epoc_diff / 60))
}

display_popup() {
    tmux display-popup \
        -S "fg=#eba0ac" \
        -w 50% \
        -h 50% \
        -d '#{pane_current_path}' \
        "gcalcli agenda \
            --details all \
            --nostarted \
            --nodeclined \
            --calendar pgherveou@parity.io $start_time $end_time
    "
}

print_tmux_status() {
    today=$(date +%Y-%m-%d)
    event_str="$NERD_FONT_MEETING $start_time $title ($minutes_till_meeting minutes)"
    # Add event_date if not today
    if [[ "$event_date" != "$today" ]]; then
        event_str="$NERD_FONT_MEETING $event_date $start_time $title ($minutes_till_meeting minutes)"
    fi

    if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES && $minutes_till_meeting -gt -60 ]]; then
        echo "$event_str"
    elif [[ $minutes_till_meeting -ge -60 ]]; then
        # Show date if not today
        if [[ "$event_date" != "$today" ]]; then
            weekday=$(date -d "$event_date" +%a)
            echo "$NERD_FONT_MEETING $weekday $start_time $title"
        else
            echo "$NERD_FONT_MEETING $start_time $title"
        fi
    else
        echo "$NERD_FONT_FREE"
    fi

    # If we're within the tiny popup window, fire it off:
    if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && $epoc_diff -lt $((ALERT_POPUP_BEFORE_SECONDS + 10)) ]]; then
        display_popup
    fi
}

main() {
    get_next_meeting
    # If there's no event today, bail out early
    [[ -z "$next_meeting" ]] && { echo "$NERD_FONT_FREE"; exit; }
    parse_result "$next_meeting"
    calculate_times
    print_tmux_status
}

main

