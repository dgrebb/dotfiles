#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
IS_VPN=$(scutil --nc list | grep Connected)

if [[ $IS_VPN != "" ]]; then
  COLOR=$CYAN
  ICON=
  LABEL="VPN"
elif [[ $IP_ADDRESS != "" ]]; then
  COLOR=$BLUE
  ICON=
  # LABEL=$IP_ADDRESS
else
  COLOR=$WHITE
  ICON=
  LABEL="Not Connected"
fi

sketchybar --set $NAME \
  icon=$ICON
# label="$LABEL"
