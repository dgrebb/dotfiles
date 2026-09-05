#!/bin/bash

[[ -f "$HOME/.config/machine.sh" ]] && source "$HOME/.config/machine.sh"

office_items=()

DISPLAYS=1,2,3

office_spacer=(
  background.drawing=off
  icon.padding_left=0
  icon.padding_right=0
  label.padding_left=0
  label.padding_right=0
  background.padding_left=0
  background.padding_right=0
  padding_left=0
  padding_right=3
)

office_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

source "$ITEM_DIR/omnifocus.sh"
source "$ITEM_DIR/ghmon.sh"
# source "$ITEM_DIR/mail.sh"
office_items+=(omnifocus ghmon.status)

sketchybar --add item spacer1 right \
  --set spacer1 "${office_spacer[@]}"

sketchybar --add item spacer20 right \
  --set spacer20 "${office_spacer[@]}"

# No bracket (and collapse spacers) when there are no office items — otherwise an
# empty pill sits left of volume / utils.
if ((${#office_items[@]})); then
  sketchybar --add bracket office spacer1 "${office_items[@]}" spacer20 \
    --set office "${office_bracket[@]}"
else
  sketchybar --set spacer1 drawing=off width=0 \
    --set spacer20 drawing=off width=0
fi
