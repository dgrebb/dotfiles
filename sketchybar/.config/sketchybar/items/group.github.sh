#!/bin/bash
# Shared pill around GitHub notifications + Actions monitor (matches calendarb / system / utils).

github_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add bracket ghstack github.bell ghmon.status \
  --set ghstack "${github_bracket[@]}"
