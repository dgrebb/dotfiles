#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

ICON_COLOR=$WHITE

data=$(
  curl -X 'GET' \
    'https://glu.7ub3s.net/api/v1/entries/sgv?count=1' \
    -H 'accept: application/json'
)

BG=$(echo $data | jq -r '.[0].sgv')

if [[ $BG -gt "233" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -gt "233" ]]; then
  ICON_COLOR=$RED
elif [[ $BG -gt "300" ]]; then
  ICON_COLOR=$BLACK
elif [[ $BG -lt "80" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -lt "75" ]]; then
  ICON_COLOR=$BLACK
fi

sketchybar --set nightscout icon=$BG icon.color=$ICON_COLOR
