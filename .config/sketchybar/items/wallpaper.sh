#!/bin/bash

ICON=

wallpaper=(
  update_freq=900
  # script="$PLUGIN_DIR/wallpaper.sh"
  click_script="$PLUGIN_DIR/wallpaper.sh"
  background.padding_left=3
  background.padding_right=3
  icon=$ICON
  width=18
  icon.color=$WHITE
  icon.padding_left=3
  icon.padding_right=5
  label.drawing=off
  associated_display=1
)

sketchybar --add item wallpaper right \
  --set wallpaper "${wallpaper[@]}"
