#!/bin/bash

wallpaper=(
  icon=󰸉
  icon.color=$BLUE
  label="wall"
  script="$PLUGIN_DIR/wallpaper.sh"
  click_script="$PLUGIN_DIR/wallpaper.sh"
  background.padding_left=3
  background.padding_right=3
  width=18
  label.width=0
  icon.color=$WHITE
  icon.padding_left=3
  icon.padding_right=0
  label.drawing=off
  associated_display=1
)

sketchybar --add item wallpaper right \
  --set wallpaper "${wallpaper[@]}"
