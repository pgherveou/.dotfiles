#!/bin/bash

MATCH_CRITERIA=$1
APP_NAME=$2
WORKSPACE_ID=$3

# If criteria contains '=', use it as-is, otherwise assume it's a class match
if [[ $MATCH_CRITERIA == *"="* ]]; then
    CRITERIA="[$MATCH_CRITERIA]"
else
    CRITERIA="[class=\"$MATCH_CRITERIA\"]"
fi

OUTPUT=$(i3-msg "$CRITERIA focus")
if [[ $OUTPUT == *"false"* ]]; then
    i3-msg "workspace $WORKSPACE_ID; exec $APP_NAME"
fi

