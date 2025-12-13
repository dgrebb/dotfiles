#!/bin/bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item space.focused left \
    --subscribe space.focused aerospace_workspace_change \
    --set space.focused \
    background.color=$BACKGROUND_1 \
    background.border_color=$BACKGROUND_2 \
    background.drawing=on \
    label.padding_right=12 \
    label="0" \
    click_script="aerospace workspace \$(aerospace list-workspaces --focused)" \
    script="$PLUGIN_DIR/aerospace.sh"
