#!/bin/bash

sketchybar --add item utils_spacer_right right \
  --set utils_spacer_right \
  width=5

sketchybar --add item ip_address right \
  --set ip_address script="~/.config/sketchybar/plugins/ip_address.sh" \
  click_script="$PLUGIN_DIR/network_click.sh" \
  update_freq=30 \
  padding_left=1 \
  padding_right=1 \
  background.height=24 \
  icon.highlight=off \
  label.highlight=off \
  associated_display=1 \
  --subscribe ip_address wifi_change

sketchybar --add item network.up right \
  --set network.up script="~/.config/sketchybar/plugins/network.sh" \
  drawing=off \
  update_freq=10 \
  padding_left=2 \
  padding_right=10 \
  background.height=24 \
  icon=⇡ \
  icon.color=$YELLOW \
  label.color=$YELLOW \
  associated_display=1

sketchybar --add item network.down right \
  --set network.down script="~/.config/sketchybar/plugins/network.sh" \
  drawing=off \
  update_freq=10 \
  padding_left=0 \
  padding_right=2 \
  background.border_width=0 \
  background.height=24 \
  icon=⇣ \
  icon.color=$GREEN \
  label.color=$GREEN \
  associated_display=1
