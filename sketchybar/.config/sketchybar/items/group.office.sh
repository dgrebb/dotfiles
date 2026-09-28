#!/bin/bash

[[ -f "$HOME/.config/machine.sh" ]] && source "$HOME/.config/machine.sh"

office_items=()

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

sketchybar --add item spacer1 right \
  --set spacer1 "${office_spacer[@]}"

if [[ "${MACHINE:-}" == 'home' ]]; then
  if [[ "${main_display:-}" == "${HOME_MACBOOK_UUID:-}" ]]; then
    # Laptop — github/ghmon are sourced by the theme items.sh already
    :
  else
    source "$ITEM_DIR/omnifocus.sh"
    office_items+="omnifocus mail"
    source "$ITEM_DIR/mail.sh"
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

# No bracket (and collapse spacers) when there are no office items — otherwise an
# empty pill sits left of volume / utils.
if ((${#office_items[@]})); then
  # shellcheck disable=SC2086 # intentional word-split (e.g. one += holds "omnifocus mail")
  sketchybar --add bracket office spacer1 $office_items spacer20 \
    --set office "${office_bracket[@]}"
else
  sketchybar --set spacer1 drawing=off width=0 \
    --set spacer20 drawing=off width=0
fi
