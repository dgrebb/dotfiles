#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Microsoft Teams")
ICON="󰊻"
ICON_COLOR="$WHITE"
DRAWING=on
LABEL_DRAWING=off
WIDTH=0
PADDING=0
if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
  LABEL="${BASH_REMATCH[1]}"

  if [[ $LABEL == "" ]]; then
    ICON_COLOR="$WHITE"
    LABEL="0"
  elif [[ $LABEL == "•" ]]; then
    ICON_COLOR=$RED
  elif [[ $LABEL =~ ^[0-9]+$ ]]; then
    ICON_COLOR="$BLUE"
  else
    ICON_COLOR=$GREY
    DRAWING=on
    exit 0
  fi
else
  ICON_COLOR=$GREY
  LABEL_COLOR=$GREY
  LABEL_DRAWING=off
fi

sketchybar --set $NAME icon="${ICON}" label="${LABEL}" label.color="${LABEL_COLOR}" label.drawing="${LABEL_DRAWING=off}" icon.color="${ICON_COLOR}" drawing=$DRAWING
