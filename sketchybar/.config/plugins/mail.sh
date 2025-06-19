#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

STATUS_LABEL=$(lsappinfo info -only StatusLabel "Canary Mail")
ICON="󰇮"
DRAWING=off
LABEL_PADDING=3
if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
  LABEL="${BASH_REMATCH[1]}"

  if [[ $LABEL == "" ]]; then
    ICON="󰪱"
    ICON_COLOR="$GREY"
    LABEL_PADDING=0
    DRAWING=off
  elif [[ $LABEL == "•" ]]; then
    ICON_COLOR="0xffeed49f"
  elif [[ $LABEL =~ ^[0-9]+$ ]]; then
    DRAWING=on
    ICON="󰇮"
    ICON_COLOR="$BLUE"
  else
    DRAWING=off
  fi
fi

sketchybar --set mail icon=$ICON label="${LABEL}" icon.color=${ICON_COLOR} \
  icon.padding_right="$LABEL_PADDING" icon.padding_left="$LABEL_PADDING" \
  label.padding_left="$LABEL_PADDING" label.padding_right="$LABEL_PADDING" \
  drawing=$DRAWING
