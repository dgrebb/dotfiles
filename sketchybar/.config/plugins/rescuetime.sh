#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

RUNNING=$(lsappinfo info "RescueTime")
ICON="󰨫"
DRAWING=on
echo "$RUNNING is it running"
if [[ $RUNNING ]]; then
  DRAWING=on
else
  DRAWING=off
fi

sketchybar --set $NAME icon="${ICON}" drawing=$DRAWING
