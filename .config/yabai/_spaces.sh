#!/bin/bash

source "$HOME/.config/machine.sh"
source "$HOME/.config/yabai/_displays.sh"

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

  yabai -m space "$idx" --label "$name"
  if [[ "$idx" -gt "3" && "$idx" -lt "7" ]]; then
    yabai -m space "$idx" --display 2
  elif [ "$idx" -lt "4" ]; then
    yabai -m space "$idx" --display 1
  else
    yabai -m space "$idx" --display 3
  fi
}

# Setup or destroy spaces as needed to match 9
for _ in $(yabai -m query --spaces | jq '.[].index | select(. > 9)'); do
  yabai -m space --destroy 10
done

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

main_display_padding=(
  top_padding 133
  bottom_padding 133
  left_padding 233
  right_padding 233
)

# If Home Clamshell Open
main_display=$(getMainDisplayUUID)
if [ "$main_display" == "$HOME_MACBOOK_UUID" ] || [ "$MACHINE" == 'office' ]; then
  yabai -m config layout float
else
  # Set space padding
  yabai -m config --space 1 "${main_display_padding[@]}"
  yabai -m config --space 2 "${main_display_padding[@]}"
  yabai -m config --space 3 "${main_display_padding[@]}"

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
fi

#####################################################################################
# Assign apps to spaces -------------------------------------------------------------

# Set Apps to Spaces for Office and Home
main_display=$(getMainDisplayUUID)

if [ "$main_display" == "$HOME_EX_MAIN_UUID" ]; then

  yabai -m rule --add app="^Music$" space=1
  yabai -m rule --add app="^(Firefox)$" space=^2
  yabai -m rule --add app="^Obsidian$" space=^9
  yabai -m rule --add app="^(Notion|Photoshop|Lightroom|Pym|Slack|Discord)$" space=3
  yabai -m rule --add app="^(iTerm2)$" space=^6
  yabai -m rule --add app="^(OmniFocus|Mail|eM Client|Calendar)$" space=5
  yabai -m rule --add app="^Code$" space=7
  yabai -m rule --add app="^dg project$" space=9

elif [[ "$MACHINE" == 'office' ]]; then

  echo "Work Stuff happens here."

  # TODO: When yabai can manage windows without script-addition and SIP disabled

  yabai -m rule --add app="^(Music|Microsoft Outlook$)$" space=1
  yabai -m rule --add app="^Firefox$" space=^2
  yabai -m rule --add app="^Obsidian$" space=^4
  yabai -m rule --add app="^Code$" space=5
  yabai -m rule --add app="^Microsoft Teams \(work or school\)$" space=7
  yabai -m rule --add app="^(OmniFocus|Calendar)$" space=8
  yabai -m rule --add app="^iTerm2$" space=^9

  if [ "$main_display" == "$WORK_MACBOOK_UUID" ]; then

    yabai -m config layout float
    yabai -m config focus_follows_mouse off

  else

    yabai -m config --space 2 layout bsp
    yabai -m config --space 4 layout bsp
    yabai -m config --space 5 layout bsp
    yabai -m config --space 6 layout bsp
    yabai -m config --space 7 layout bsp
    yabai -m config --space 8 layout bsp

  fi

fi

yabai -m rule --apply
