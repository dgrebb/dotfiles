#!/bin/bash
source "$HOME/.config/machine.sh"

if [[ "$MACHINE" == 'home' ]]; then
  SPACE_ICONS=("󰟅" "🚜" "󱁐" "" "" "" "" "" "◌")
else
  SPACE_ICONS=("󰟅" "🚜" "󱁐" "" "" "◌" "" "" "")
fi

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  space=(
    associated_space=$sid
    # icon="${SPACE_ICONS[i]}"
    # icon.padding_left=10
    # icon.padding_right=5
    icon.drawing=off
    padding_left=2
    padding_right=2
    label.padding_right=20
    icon.highlight_color=$WHITE
    label.color=$GREY
    label.highlight_color=$WHITE
    label.font="sketchybar-app-font:Regular:14.0"
    label.y_offset=-1
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left \
    --set space.$sid "${space[@]}" \
    --subscribe space.$sid mouse.clicked
done

separator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color=$WHITE
)

space_creator=(
  icon=􀆊
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=8
  label.drawing=off
  display=active
  click_script='yabai -m space --create'
  script="$PLUGIN_DIR/space_windows.sh"
  icon.color=$WHITE
)

sketchybar --add item space_creator left \
  --set space_creator "${space_creator[@]}" \
  --subscribe space_creator space_windows_change

###############################################################################
# Custom icon sizes and offsets                                               #
###############################################################################

# adjust tractor
# sketchybar --set space.2 icon.y_offset=2

# set code space icons larger
# for id in 4 5; do
#   sketchybar --set space.$id icon.font.size=21.0
# done

# for id in 6; do
#   sketchybar --set space.$id icon.y_offset=-1
# done
