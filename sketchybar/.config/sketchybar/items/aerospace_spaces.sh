#!/bin/bash
# Clickable Aerospace workspace pills + front app (Tokyo / dense layouts).

sketchybar --add event aerospace_workspace_change

# Primary workspaces used in .aerospace.toml persistent list
WORKSPACES=(1 2 3 4 5 6 7 8 9 G H I)

space_item() {
  local sid="$1"
  local item="space.$sid"

  sketchybar --add item "$item" left \
    --subscribe "$item" aerospace_workspace_change \
    --set "$item" \
    icon="$sid" \
    icon.font="$FONT:Bold:11.0" \
    icon.color=$GREY \
    icon.padding_left=6 \
    icon.padding_right=6 \
    label.drawing=off \
    padding_left=1 \
    padding_right=1 \
    background.height=22 \
    background.corner_radius=7 \
    background.drawing=off \
    background.border_width=1 \
    script="$PLUGIN_DIR/aerospace_space.sh $sid" \
    click_script="aerospace workspace $sid"
}

for sid in "${WORKSPACES[@]}"; do
  space_item "$sid"
done

front_app=(
  icon="$APPLE"
  icon.font="$FONT:Black:14.0"
  icon.color=$HIGHLIGHT
  icon.padding_left=8
  icon.padding_right=6
  label.font="$FONT:Bold:11.0"
  label.padding_right=10
  associated_display=active
  script="$PLUGIN_DIR/front_app.sh"
)

spaces_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

# Build bracket member list
members=()
for sid in "${WORKSPACES[@]}"; do
  members+=("space.$sid")
done
members+=(front_app)

sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched

# shellcheck disable=SC2068
sketchybar --add bracket aero_spaces ${members[@]} \
  --set aero_spaces "${spaces_bracket[@]}"

sketchybar --trigger aerospace_workspace_change
