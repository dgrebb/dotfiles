#!/bin/bash
# Aerospace workspace + front app live together in one left bracket.
# Apple logo popup logic remains in items/apple.sh (commented out in sketchybarrc).

sketchybar --add event aerospace_workspace_change

space_focused=(
  background.drawing=off
  icon=󰍹
  icon.font="$FONT:Bold:13.0"
  icon.color=$BLUE
  icon.padding_left=10
  icon.padding_right=4
  label="—"
  label.font="$FONT:Black:12.0"
  label.padding_right=8
  script="$PLUGIN_DIR/aerospace.sh"
  update_freq=5
)

front_app=(
  icon="$APPLE"
  icon.font="$FONT:Black:15.0"
  icon.color=$HIGHLIGHT
  icon.padding_left=4
  icon.padding_right=6
  label.font="$FONT:Black:12.0"
  label.padding_right=12
  padding_right=4
  associated_display=active
  script="$PLUGIN_DIR/front_app.sh"
)

system_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item space.focused left \
  --subscribe space.focused aerospace_workspace_change front_app_switched \
  --set space.focused "${space_focused[@]}"

sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched

sketchybar --add bracket system space.focused front_app \
  --set system "${system_bracket[@]}"

# Kick an initial render (aerospace + front app)
sketchybar --trigger aerospace_workspace_change
