#!/bin/bash

# Find aliases by running
# sketchybar --query default_menu_items
#
# Alias recapture is alias.update_freq (item update_freq does not control it).
# Default is 1, counted on the animator clock. Each capture copies pixels via
# CGDataProviderCopyData; on macOS 26 those copies are not released, so live
# iStat graphs grow RSS by ~2–3GB/day. 0 disables recapture (SketchyBar source).
alias=(
  background.padding_left=0
  background.padding_right=0
  associated_display=1
  alias.update_freq=0
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
  width=2 \
  alias.scale=0.8 \
  associated_display=1

source "$ITEM_DIR/timemachine.sh"
