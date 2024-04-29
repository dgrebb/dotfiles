#!/bin/bash

calendar=(
  icon=cal
  icon.font="$FONT:Black:12.0"
  icon.padding_right=3
  icon.padding_left=3
  label.padding_right=3
  label.padding_left=3
  label.align=right
  update_freq=15
  script="$PLUGIN_DIR/calendar.sh"
  associated_display=1
  background.padding_left=0
  background.padding_right=0
)

calendar_bracket=(
  background.color=0x9c1c1c1c
  background.border_color=$BACKGROUND_2
)

sketchybar --add alias "iStat Menus Status,com.bjango.istatmenus.weather" right \
  --set "iStat Menus Status,com.bjango.istatmenus.weather" \
  background.padding_left=0 \
  background.padding_right=0 \
  background.drawing=off \
  background.shadow.drawing=off \
  icon.padding_right=0 \
  label.padding_right=0 \
  position=right \
  alias.scale=0.88 \
  background.padding_left=0 \
  background.padding_right=0 \
  click_script="$PLUGIN_DIR/zen.sh"

sketchybar --add alias "WorkingHours,Item-0" right \
  --set "WorkingHours,Item-0" "${alias[@]}" \
  label.padding_right=0 \
  icon.padding_right=0 \
  label.padding_left=0 \
  icon.padding_left=0 \
  alias.scale=0.3 \
  associated_display=1

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" \
  --subscribe calendar system_woke

source "$ITEM_DIR/focus.sh"

source "$ITEM_DIR/nightscout.sh"

sketchybar --add item spacer_calendar_left right \
  --set spacer_calendar_left \
  width=5

sketchybar --add bracket calendarb battery focus "WorkingHours,Item-0" calendar "Glucose Graph,Item-0" "iStat Menus Status,com.bjango.istatmenus.weather" \
  --set calendarb "${calendar_bracket[@]}"
