#!/bin/bash

cpu_top=(
  label.font="$FONT:Semibold:7"
  label=CPU
  icon.drawing=off
  width=0
  padding_right=15
  y_offset=6
  associated_display=1
)

cpu_percent=(
  label.font="$FONT:Heavy:12"
  label=CPU
  y_offset=-4
  padding_right=15
  width=55
  icon.drawing=off
  update_freq=4
  mach_helper="$HELPER"
  associated_display=1
)

cpu_sys=(
  width=0
  graph.color=$RED
  graph.fill_color=$RED
  label.drawing=off
  icon.drawing=off
  background.height=27
  background.drawing=on
  background.color=$TRANSPARENT
  associated_display=1
)

cpu_user=(
  graph.color=$BLUE
  label.drawing=off
  icon.drawing=off
  background.height=27
  background.drawing=on
  background.color=$TRANSPARENT
  associated_display=1
)

sketchybar --add item cpu.top right \
  --set cpu.top "${cpu_top[@]}" \
  \
  --add item cpu.percent right \
  --set cpu.percent "${cpu_percent[@]}" \
  \
  --add graph cpu.sys right 75 \
  --set cpu.sys "${cpu_sys[@]}" \
  \
  --add graph cpu.user right 75 \
  --set cpu.user "${cpu_user[@]}"

cpu_bracket=(
  background.color=0x9c1c1c1c
  background.border_color=$BACKGROUND_2
)

sketchybar --add bracket cpubracket cpu.top cpu.percent cpu.sys cpu.user \
  --set cpubracket "${cpu_bracket[@]}"
