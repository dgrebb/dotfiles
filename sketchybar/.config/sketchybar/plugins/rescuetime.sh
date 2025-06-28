#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

RUNNING=$(lsappinfo info "RescueTime")
ICON="󰨫"
DRAWING=on
if [[ $RUNNING ]]; then
  DRAWING=on
else
  DRAWING=off
fi

sketchybar --set $NAME icon="${ICON}" drawing=$DRAWING
