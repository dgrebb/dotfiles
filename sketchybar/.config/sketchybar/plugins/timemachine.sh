#!/bin/bash

running=$(tmutil status | grep "Running = 1;")

if [[ $running ]]; then
  sketchybar --set "SystemUIServer,TimeMachine.TMMenuExtraHost" drawing=on
else
  sketchybar --set "SystemUIServer,TimeMachine.TMMenuExtraHost" drawing=off
fi
