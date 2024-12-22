#!/bin/bash

# battery=(
#   script="$PLUGIN_DIR/battery.sh"
#   icon.font="$FONT:Regular:19.0"
#   padding_right=5
#   padding_left=0
#   label.drawing=off
#   update_freq=120
#   updates=on
# )

sketchybar --add alias "iStat Menus Menubar,com.bjango.istatmenus.battery" right \
  --set "iStat Menus Menubar,com.bjango.istatmenus.memory" "${alias[@]}" \
  background.drawing=off \
  alias.color=yellow \
  alias.width=0 \
  alias.scale=0.3 \
  icon.padding_right=0 \
  icon.padding_left=0 \
  label.padding_right=0 \
  label.padding_left=0 \
  background.padding_left=0 \
  background.padding_right=0 \
  padding_left=0 \
  associated_display=1 \
  --subscribe "iStat Menus Menubar,com.bjango.istatmenus.battery" \
  power_source_change system_woke
