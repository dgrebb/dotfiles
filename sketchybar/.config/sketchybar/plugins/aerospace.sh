#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

focused_workspace=$(aerospace list-workspaces --focused)
sketchybar --set $NAME label="$focused_workspace"
