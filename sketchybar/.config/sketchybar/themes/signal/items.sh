#!/bin/bash
# Signal layout — Aerospace + app left; meeting pill near notch; GitHub right.

source "$ITEM_DIR/aerospace.sh"
sketchybar --set front_app icon.color=$BLUE \
  --set space.focused icon=󰌳 icon.color=$ORANGE

source "$ITEM_DIR/meeting.sh"
source "$ITEM_DIR/music.sh"
sketchybar --set music.title label.max_chars=16 \
  --set music.note icon.color=$BLUE

source "$ITEM_DIR/calendar.sh"
source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/ghmon.sh"
source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"

sketchybar --animate tanh 18 --set meeting icon.y_offset=4 icon.y_offset=0
