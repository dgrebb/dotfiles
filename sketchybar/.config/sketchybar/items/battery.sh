#!/bin/bash

battery=(
  background.drawing=off
  alias.color=yellow
  width=33
  alias.scale=0.9
  associated_display=1
)

sketchybar --add alias "Control Center,com.bjango.istatmenus.battery" right \
  --set "Control Center,com.bjango.istatmenus.battery" "${battery[@]}" \
  --subscribe "Control Center,com.bjango.istatmenus.battery" \
  power_source_change system_woke
