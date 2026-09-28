#!/bin/bash
meeting=(
  script="$PLUGIN_DIR/meeting.sh"
  update_freq=20
  drawing=off
  icon.font="$FONT:Bold:13.0"
  label.font="$FONT:Bold:11.0"
  padding_left=8
  padding_right=8
  background.height=22
  background.corner_radius=8
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=1
)

sketchybar --add item meeting center   --set meeting "${meeting[@]}"   --subscribe meeting front_app_switched system_woke
