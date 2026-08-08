#!/bin/bash
# Tokyo layout — Aerospace pills hug the left edge; music rides center;
# GitHub + Actions sit as the "avionics" cluster on the right.

source "$ITEM_DIR/aerospace_spaces.sh"
source "$ITEM_DIR/music.sh"

sketchybar --set music.note icon.color=$BLUE   --set music.title label.font="$FONT:Bold:11.0"

source "$ITEM_DIR/calendar.sh"
source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/ghmon.sh"

# Avionics bracket around GitHub stack
sketchybar --add bracket avionics github.bell ghmon.status   --set avionics background.color=$BACKGROUND_1 background.border_color=$HIGHLIGHT_BORDER

source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"

# Neon tick on load
sketchybar --animate tanh 16 --set github.bell icon.y_offset=4 icon.y_offset=0   --animate tanh 16 --set ghmon.status label.y_offset=3 label.y_offset=0
