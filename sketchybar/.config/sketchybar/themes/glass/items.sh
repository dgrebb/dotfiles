#!/bin/bash
# Glass layout — sparse left + center music + quiet right.
# Hides network throughput; keeps IP/github/ghmon as icon-forward pills.

source "$ITEM_DIR/aerospace.sh"

# Tighten the system bracket for a lighter look
sketchybar --set system background.color=$BACKGROUND_1 background.border_width=0 \
  --set space.focused icon.drawing=off label.font="$FONT:Bold:11.0" \
  --set front_app label.font="$FONT:Medium:11.0" icon.font="sketchybar-app-font:Regular:14.0"

source "$ITEM_DIR/music.sh"
sketchybar --set music background.border_width=0 \
  --set music.title label.font="$FONT:Medium:11.0" label.max_chars=18 \
  --set music.note icon.color=$LIGHT_BLUE

source "$ITEM_DIR/calendar.sh"
sketchybar --set calendarb background.border_width=0 \
  --set calendar label.font="$FONT:Bold:11.0" icon.font="$FONT:Bold:11.0"

source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/ghmon.sh"
source "$ITEM_DIR/group.github.sh"
sketchybar --set github.bell label.drawing=off padding_right=2 \
  --set ghmon.status label.font="$FONT:Bold:11.0" background.border_width=0

source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"

# Quiet the noisier utils
sketchybar --set network.up drawing=off \
  --set network.down drawing=off \
  --set utils background.border_width=0 \
  --animate sin 18 --set front_app icon.y_offset=3 icon.y_offset=0
