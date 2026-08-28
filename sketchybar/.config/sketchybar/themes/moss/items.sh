#!/bin/bash
# Moss layout — breathing room around the notch; Music + notes-friendly right edge.

source "$ITEM_DIR/aerospace.sh"
sketchybar --set space.focused icon=󰌪 icon.color=$GREEN   --set front_app icon.color=$HIGHLIGHT   --set system background.border_color=$HIGHLIGHT_BORDER

source "$ITEM_DIR/music.sh"
sketchybar --set music.note icon.color=$GREEN   --set music.title label.font="$FONT:Semibold:12.0"   --set music background.border_color=$BACKGROUND_2

source "$ITEM_DIR/calendar.sh"
# source "$ITEM_DIR/github.sh"
# source "$ITEM_DIR/ghmon.sh"
sketchybar --set github.bell icon.color=$GREEN   --set ghmon.status icon.color=$BLUE

source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"

# Slow calm bloom
sketchybar --animate tanh 28 --set system background.border_color=$GREEN background.border_color=$HIGHLIGHT_BORDER
