#!/bin/bash

timemachine=(
  script="$PLUGIN_DIR/timemachine.sh"
  updates=on
  update_freq=120
  width=30
  label.padding_right=0
  icon.padding_right=0
  alias.scale=0.8
  associated_display=1
  drawing=off
)

sketchybar --add alias "SystemUIServer,TimeMachine.TMMenuExtraHost" right \
  --set "SystemUIServer,TimeMachine.TMMenuExtraHost" "${timemachine[@]}"
