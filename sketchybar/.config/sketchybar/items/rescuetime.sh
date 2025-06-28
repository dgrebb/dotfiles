#!/usr/bin/env sh

sketchybar --add item rescuetime right \
  --set rescuetime \
  script="$PLUGIN_DIR/rescuetime.sh" \
  click_script="$PLUGIN_DIR/rescuetime_click.sh" \
  update_freq=180 \
  icon.color=$LIGHT_BLUE \
  icon.padding_left=3 \
  icon.padding_right=3 \
  label.drawing=off \
  associated_display=1

sketchybar --subscribe rescuetime system_woke
