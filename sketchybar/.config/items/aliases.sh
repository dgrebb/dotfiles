#!/bin/bash

# Find aliases by running
# sketchybar --query default_menu_items

alias=(
  background.padding_left=0
  background.padding_right=0
  associated_display=1
)

sketchybar --add alias "iStat Menus Menubar,com.bjango.istatmenus.cpu" right \
  --set "iStat Menus Menubar,com.bjango.istatmenus.cpu" "${alias[@]}" \
  alias.color=#RED \
  width=10 \
  label.padding_right=0 \
  icon.padding_right=0 \
  alias.scale=0.8 \
  associated_display=1

sketchybar --add alias "iStat Menus Menubar,com.bjango.istatmenus.memory" right \
  --set "iStat Menus Menubar,com.bjango.istatmenus.memory" "${alias[@]}" \
  alias.color=yellow \
  alias.width=2 \
  alias.scale=0.8 \
  associated_display=1

source "$ITEM_DIR/timemachine.sh"
