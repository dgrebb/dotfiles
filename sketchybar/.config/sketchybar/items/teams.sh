#!/bin/bash

teams=(
  script="$PLUGIN_DIR/teams.sh"
  click_script="$PLUGIN_DIR/teams_click.sh"
  updates=on
  update_freq=30
  label.y_offset=-1
  icon.y_offset=1
  icon.font.size=18
  icon.padding_left=3
  icon.padding_right=0
  label.padding_left=3
  label.padding_right=3
  associated_display=1
)

sketchybar --add item teams right \
  --set teams "${teams[@]}" \
  --subscribe teams system_woke
