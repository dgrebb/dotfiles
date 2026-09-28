#!/bin/bash
# Phosphor layout — terminal-tight. Workspace as `[n]`, music as scrolling teletype.

source "$ITEM_DIR/aerospace.sh"
sketchybar --set space.focused icon=">" icon.color=$GREEN label.color=$GREEN   label.font="$FONT:Bold:12.0"   --set front_app icon.color=$GREEN label.color=$WHITE label.font="$FONT:Bold:11.0"   --set system background.border_color=$HIGHLIGHT_BORDER background.corner_radius=4

source "$ITEM_DIR/music.sh"
sketchybar --set music.note icon="♪" icon.color=$GREEN icon.font="$FONT:Bold:12.0"   --set music.title label.font="$FONT:Bold:11.0" label.color=$WHITE   --set music background.corner_radius=4 background.border_color=$BACKGROUND_2

source "$ITEM_DIR/calendar.sh"
sketchybar --set calendar icon.color=$GREEN label.color=$WHITE   --set calendarb background.corner_radius=4

source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/ghmon.sh"
source "$ITEM_DIR/group.github.sh"
sketchybar --set github.bell icon.color=$GREEN   --set ghmon.status icon.color=$GREEN label.color=$YELLOW background.corner_radius=4

source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"

sketchybar --set utils background.corner_radius=4   --animate tanh 10 --set space.focused label.y_offset=2 label.y_offset=0   --animate tanh 14 --set ghmon.status icon.y_offset=2 icon.y_offset=0
