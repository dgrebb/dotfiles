#!/bin/bash

ICON=

nightscout=(
  drawing=on
  update_freq=60
  click_script="open https://glu.7ub3s.net/"
  background.padding_left=0
  background.padding_right=0
  label.padding_right=0
  background.drawing=off
  label.padding_right=0
  icon.padding_right=0
  icon.padding_left=0
  label.padding_left=0
  associated_display=1
)

sketchybar --add alias "Glucose Graph,Item-0" right \
  --set "Glucose Graph,Item-0" "${nightscout[@]}" \
  click_script="open https://glu.7ub3s.net/" \
  alias.color=0xffff9341 \
  y_offset=-1
