#!/bin/bash

LABEL=

nightscout=(
  associated_display=1
  background.padding_left=9
  background.padding_right=0
  background.drawing=off
  click_script="open https://glu.7ub3s.net/"
  drawing=on
  icon=0
  icon.font="$FONT:Black:14.0"
  icon.padding_right=7
  icon.y_offset=-1
  label.y_offset=1
  label=$LABEL
  label.font="Hack Nerd Font:Regular:12.0"
  label.color=$DARK_RED
  label.padding_right=0
  label.padding_left=0
  script="$PLUGIN_DIR/nightscout.sh"
  update_freq=60
)

# Tahoe/Sketchybar don't support unnamed menubar items
# sketchybar --add alias "Glucose Graph,Item-0" right \
#   --set "Glucose Graph,Item-0" "${nightscout[@]}" \
#   click_script="open https://glu.7ub3s.net/" \
#   alias.color=0xffff9341 \
#   y_offset=-1

sketchybar --add item nightscout right \
  --set nightscout "${nightscout[@]}"
