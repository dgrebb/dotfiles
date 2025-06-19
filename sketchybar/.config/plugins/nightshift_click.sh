#!/bin/bash

# Requires nightlight: https://github.com/smudge/nightlight
source "$CONFIG_DIR/colors.sh"

STATUS=$(nightlight status)
if [[ "$STATUS" == *"off"* ]]; then
  ICON=
else
  ICON=
fi

sketchybar -m --set nightshift icon=$ICON

nightlight toggle
