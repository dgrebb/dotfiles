#!/bin/bash

calendar=(
  icon.font="$FONT:Black:14.0"
  icon.padding_left=3
  label.font="$FONT:Black:14.0"
  label.padding_left=0
  label.align=right
  y_offset=-1
  update_freq=15
  script="$PLUGIN_DIR/calendar.sh"
  associated_display=1
  background.padding_left=0
  background.padding_right=11
)

calendar_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  associated_display=1
)

# NOTE: Hide focus for now
# source "$ITEM_DIR/focus.sh"

# sketchybar --add alias "WorkingHours,Item-0" right \
#   --set "WorkingHours,Item-0" "${alias[@]}" \
#   label.padding_right=0 \
#   icon.padding_right=0 \
#   label.padding_left=0 \
#   icon.padding_left=0 \
#   alias.scale=0.3 \
#   associated_display=1

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" \
  --subscribe calendar system_woke

sketchybar --add alias "Control Center,com.bjango.istatmenus.weather" right \
  --set "Control Center,com.bjango.istatmenus.weather" \
  background.drawing=off \
  background.shadow.drawing=off \
  background.padding_left=0 \
  icon.padding_left=0 \
  label.padding_right=0 \
  position=right \
  alias.scale=0.88 \
  click_script="$PLUGIN_DIR/zen.sh"

source "$ITEM_DIR/nightscout.sh"

sketchybar --add bracket calendarb nightscout calendar "Control Center,com.bjango.istatmenus.weather" \
  --set calendarb "${calendar_bracket[@]}"
