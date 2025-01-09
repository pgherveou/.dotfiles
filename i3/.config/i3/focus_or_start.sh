#!/bin/bash

APP_NAME=$1
WORKSPACE_ID=$2

if pgrep -x "$APP_NAME" > /dev/null
then
    i3-msg "[class=\"$APP_NAME\"] focus"
else
    i3-msg "workspace $WORKSPACE_ID; exec $APP_NAME"
fi
