#!/bin/bash
# Wings layout — wide notch gap, music tucked just left of center,
# GitHub + Actions form the right wing tip.

source "$ITEM_DIR/aerospace.sh"

# Soft separator “feather” before the notch
sketchybar --add item wing.gap.left center \
  --set wing.gap.left \
  icon="⟡" \
  icon.color=$PURPLE \
  icon.font="$FONT:Regular:10.0" \
  label.drawing=off \
  background.drawing=off \
  padding_left=2 \
  padding_right=2

source "$ITEM_DIR/music.sh"

sketchybar --add item wing.gap.right center \
  --set wing.gap.right \
  icon="⟡" \
  icon.color=$BLUE \
  icon.font="$FONT:Regular:10.0" \
  label.drawing=off \
  background.drawing=off

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

# Lavender pulse on the GitHub bell when the theme loads
sketchybar --animate tanh 20 --set github.bell icon.color=$PURPLE icon.color=$BLUE
