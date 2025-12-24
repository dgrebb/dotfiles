#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

ICON_COLOR=$WHITE
GLU_API_KEY=$(pass dg/glu/api-key)

data=$(
  curl -X 'GET' \
    "https://glu.7ub3s.net/api/v1/entries/sgv?count=1&token=${GLU_API_KEY}" \
    -H 'accept: application/json'
)

BG=$(echo $data | jq -r '.[0].sgv')

if [[ $BG -gt "120" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -gt "160" ]]; then
  ICON_COLOR=$RED
elif [[ $BG -gt "300" ]]; then
  ICON_COLOR=$BLACK
elif [[ $BG -lt "100" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -lt "90" ]]; then
  ICON_COLOR=$RED
else
  ICON_COLOR=$GREEN
fi

sketchybar --set nightscout icon=$BG icon.color=$ICON_COLOR
