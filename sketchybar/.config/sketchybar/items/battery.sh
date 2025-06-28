#!/bin/bash

battery=(
  background.drawing=off
  alias.color=yellow
  width=33
  alias.scale=0.9
  associated_display=1
)

sketchybar --add alias "iStat Menus Menubar,com.bjango.istatmenus.battery" right \
  --set "iStat Menus Menubar,com.bjango.istatmenus.battery" "${battery[@]}" \
  --subscribe "iStat Menus Menubar,com.bjango.istatmenus.battery" \
  power_source_change system_woke
