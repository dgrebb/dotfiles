#!/bin/bash

omnifocus=(
  script="$PLUGIN_DIR/omnifocus.sh"
  click_script="$PLUGIN_DIR/omnifocus_click.sh"
  updates=on
  update_freq=30
  background.padding_left=3
  background.padding_right=3
  label.padding_right=0
  icon.padding_right=0
  icon.y_offset=1
  icon.font.size=16
  associated_display=1
)

sketchybar --add item omnifocus right \
  --set omnifocus "${omnifocus[@]}" \
  --subscribe omnifocus system_woke

# icon.y_offset=1 \
