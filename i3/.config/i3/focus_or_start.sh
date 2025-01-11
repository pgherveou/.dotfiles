#!/bin/bash

APP_CLASS=$1
APP_NAME=$2
WORKSPACE_ID=$3

OUTPUT=$(i3-msg "[class=\"$APP_CLASS\"] focus")
if [[ $OUTPUT == *"false"* ]]; then
    i3-msg "workspace $WORKSPACE_ID; exec $APP_NAME"
fi

