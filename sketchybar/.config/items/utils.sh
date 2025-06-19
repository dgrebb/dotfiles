#!/bin/bash
source "$HOME/.config/machine.sh"
source "$HOME/.config/yabai/_displays.sh"

utils_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  associated_display=1
)

# Set up machine-specific apps
utils=()

if [[ "$MACHINE" == 'office' ]]; then
  utils+='rescuetime '
  utils+='teams '
else
  utils+='nightshift '
fi

sketchybar --add bracket utils \
  volume_icon \
  $utils \
  "iStat Menus Menubar,com.bjango.istatmenus.cpu" \
  "iStat Menus Menubar,com.bjango.istatmenus.memory" \
  wallpaper \
  "SystemUIServer,TimeMachine.TMMenuExtraHost" \
  ip_address \
  network.up \
  network.down \
  --set utils "${utils_bracket[@]}"
