#!/bin/bash

source "$HOME/.config/machine.sh"
source "$HOME/.config/yabai/_displays.sh"

echo "Main Current Display : $MAIN_DISPLAY"
echo "Workstation Display : $HOME_EX_MAIN_UUID"

# Space Mapper
setup_space() {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")

  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  if [ "$MAIN_DISPLAY" == "$HOME_EX_MAIN_UUID" ]; then

    echo "You've got big display plans."

    # NOTE: Home Workspace Configuration
    yabai -m space "$idx" --label "$name"
    if [ "$idx" -lt "4" ]; then
      yabai -m space "$idx" --display 1
    elif [ "$idx" -gt "3" ] && [ $idx -lt "7" ]; then
      yabai -m space "$idx" --display 2
    else
      yabai -m space "$idx" --display 3
    fi

  # NOTE: Alternative configurations -------------------------------------

  # Two Displays; external above laptop
  # yabai -m space "$idx" --label "$name"
  # if [[ "$idx" -lt "4" ]]; then
  #   yabai -m space "$idx" --display 1
  # else
  #   yabai -m space "$idx" --display 2
  # fi

  fi
}

# -------------------------------------------------------------------------

# Set Up Spaces
setup_space 1 music
setup_space 2 web
setup_space 3 work
setup_space 4 maincode
setup_space 5 code
setup_space 6 project
setup_space 7 plan
setup_space 8 office
setup_space 9 terminal

# Clean up any extra spaces
for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 9)'); do
  yabai -m space --destroy 10
done

main_display_padding=(
  top_padding 133
  bottom_padding 133
  left_padding 233
  right_padding 233
)

music_space_padding=(
  top_padding 233
  bottom_padding 233
  left_padding 333
  right_padding 333
)

# If Home Clamshell Open
if [ "$MAIN_DISPLAY" == "$HOME_MACBOOK_UUID" ] || [ "$MAIN_DISPLAY" == "$WORK_MACBOOK_UUID" ]; then

  main_display_padding=(
    top_padding 33
    bottom_padding 33
    left_padding 67
    right_padding 67
  )

  music_space_padding=(
    top_padding 233
    bottom_padding 233
    left_padding 333
    right_padding 333
  )

  # Set stacked spaces
  yabai -m config --space 1 layout bsp
  yabai -m config --space 2 layout stack "${main_display_padding[@]}"
  yabai -m config --space 3 layout bsp "${main_display_padding[@]}"
  yabai -m config --space 4 layout stack "${main_display_padding[@]}"
  yabai -m config --space 5 layout stack "${main_display_padding[@]}"
  yabai -m config --space 6 layout stack "${main_display_padding[@]}"
  yabai -m config --space 7 layout stack "${main_display_padding[@]}"
  yabai -m config --space 8 layout stack "${main_display_padding[@]}"
  yabai -m config --space 9 layout stack "${main_display_padding[@]}"

else

  # Set space padding
  yabai -m config --space 1 "${music_space_padding[@]}"
  yabai -m config --space 2 "${main_display_padding[@]}"
  yabai -m config --space 3 "${main_display_padding[@]}"

  if [[ "$MACHINE" == 'home' ]]; then

    # Set floating spaces
    yabai -m config --space 1 layout float
    yabai -m config --space 2 layout bsp
    yabai -m config --space 3 layout float
    yabai -m config --space 4 layout bsp
    yabai -m config --space 5 layout bsp
    yabai -m config --space 6 layout bsp
    yabai -m config --space 7 layout bsp
    yabai -m config --space 8 layout bsp
    yabai -m config --space 9 layout bsp

  else

    yabai -m config --space 1 layout float
    yabai -m config --space 2 layout bsp
    yabai -m config --space 3 layout float
    yabai -m config --space 4 layout bsp
    yabai -m config --space 5 layout bsp
    yabai -m config --space 6 layout bsp
    yabai -m config --space 7 layout bsp
    yabai -m config --space 8 layout bsp
    yabai -m config --space 9 layout bsp

  fi

fi

# yabai rule function to immediately add and apply rules
# https://github.com/koekeishiya/yabai/issues/2199#issuecomment-2527245468
function yabai_rule {
  yabai -m rule --add "$@"
  yabai -m rule --apply "$@"
}

#####################################################################################
# Assign apps to spaces -------------------------------------------------------------

if [[ "$MACHINE" == 'home' ]]; then

  yabai_rule app="^Music$" space=9
  yabai_rule app="^(Firefox|Zen Browser|Google Chrome|Safari)$" space=^2
  yabai_rule app="^(Notion|Photoshop|Lightroom|Adobe Lightroom Classic|Pym|Slack|Discord|Logic Pro|Reason 13|Reason Companion|Home|Controller|Zoom|zoom.us|ChatGPT)$" space=3
  yabai_rule app="^(Mail|Canary Mail|eM Client|Calendar)$" space=4
  yabai_rule app="^(OmniFocus)$" space=5
  yabai_rule app="^(iTerm2|Ghostty|Min|TauriApp|tauri-app|launchpad|LaunchPad)$" space=6
  yabai_rule app="^(Code|Cursor)$" space=7
  yabai_rule app="^dg project$" space=8
  yabai_rule app="^Obsidian$" space=^9

else

  # TODO: When yabai can manage windows without script-addition and SIP disabled

  yabai_rule app="^(Music|Microsoft Outlook)$" space=1
  yabai_rule app="^(Google Chrome|Firefox|Safari)$" space=2
  yabai_rule app="^Microsoft Excel$" space=3
  yabai_rule app="^(Code|Cursor)$" space=^5
  yabai_rule app="^Obsidian$" space=^6
  yabai_rule app="^(iTerm2|Ghostty)$" space=^7
  yabai_rule app="^(OmniFocus|Calendar)$" space=8
  yabai_rule app="^(Microsoft Teams|Teams \(Safari\))$" space=9

fi
