#!/bin/bash
# Ember layout — notch-aware developer bar.
#
# LEFT ………… aerospace workspace + front app (icon + name)
# CENTER …… music (sits in the notch gap on external displays; left-of-notch on laptops)
# RIGHT ……… calendar · github · office (omnifocus + ghmon) · volume/utils

# Left: aerospace consolidates workspace + front_app (+ optional apple popup stays in apple.sh)
source "$ITEM_DIR/aerospace.sh"

# Center: now-playing (hidden when Music.app is idle)
source "$ITEM_DIR/music.sh"

# Right stack
source "$ITEM_DIR/calendar.sh"
source "$ITEM_DIR/github.sh"
source "$ITEM_DIR/network.sh"
source "$ITEM_DIR/aliases.sh"
source "$ITEM_DIR/wallpaper.sh"
source "$ITEM_DIR/nightshift.sh"
source "$ITEM_DIR/volume.sh"
source "$ITEM_DIR/utils.sh"
source "$ITEM_DIR/group.office.sh"
