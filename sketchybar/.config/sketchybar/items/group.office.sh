#!/bin/bash

source "$HOME/.config/machine.sh"
# source "$HOME/.config/yabai/_displays.sh"

office_items=()

office_spacer=(
  background.drawing=off
  # width=0
  icon.padding_left=0
  icon.padding_right=0
  label.padding_left=0
  label.padding_right=0
  background.padding_left=0
  background.padding_right=0
  padding_left=0
  padding_right=3
)

sketchybar --add item spacer1 right \
  --set spacer1 "${office_spacer[@]}"

if [[ "$MACHINE" == 'home' ]]; then
  if [[ "$main_display" == "$HOME_MACBOOK_UUID" ]]; then
    # source "$ITEM_DIR/github.sh"
    # source "$ITEM_DIR/ghmon.sh"
    # office_items+="github ghmon.status"
    # source "$ITEM_DIR/omnifocus.sh"
    # office_items+="omnifocus"
  else
    source "$ITEM_DIR/omnifocus.sh"
    office_items+="omnifocus mail"
    source "$ITEM_DIR/mail.sh"
    # source "$ITEM_DIR/github.sh"
    # source "$ITEM_DIR/ghmon.sh"
  fi
  DISPLAYS=1,2,3
else
  source "$ITEM_DIR/omnifocus.sh"
  source "$ITEM_DIR/teams.sh"
  source "$ITEM_DIR/rescuetime.sh"
  office_items+="rescuetime teams omnifocus \"WorkingHours,Item-0\""
  DISPLAYS=1
fi

office_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item spacer20 right \
  --set spacer20 "${office_spacer[@]}"

sketchybar --add bracket office spacer1 $office_items spacer20 \
  --set office "${office_bracket[@]}"
