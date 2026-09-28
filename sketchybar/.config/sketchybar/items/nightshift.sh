#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Requires nightlight: https://github.com/smudge/nightlight

STATUS=$(nightlight status)
if [[ "$STATUS" == *"off"* ]]; then
  ICON=
else
  ICON=
fi

nightshift=(
  click_script="$PLUGIN_DIR/nightshift_click.sh"
  icon.color=$WHITE
  icon=$ICON
  width=27
  associated_display=1
)

sketchybar --add item nightshift right \
  --set nightshift "${nightshift[@]}"
