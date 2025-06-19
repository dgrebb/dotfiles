#!/bin/bash

mail=(
  script="$PLUGIN_DIR/mail.sh"
  click_script="$PLUGIN_DIR/mail_click.sh"
  updates=on
  update_freq=30
  background.padding_left=6
  background.padding_right=3
  icon.y_offset=1
  icon.font.size=16
  associated_display=1
)

sketchybar --add item mail right \
  --set mail "${mail[@]}" \
  --subscribe mail system_woke
# icon.y_offset=1 \
