#!/bin/bash

datetime=(
  click_script="$CONFIG_DIR/plugins/datetime_click.sh"
  icon="$(date '+%a %d')"
  label=" | $(date '+%H:%M')"
)

sketchybar --set $NAME "${datetime[@]}"
