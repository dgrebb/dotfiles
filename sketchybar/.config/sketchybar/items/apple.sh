#!/bin/bash

POPUP_OFF='sketchybar --set apple.logo popup.drawing=off'
POPUP_CLICK_SCRIPT='sketchybar --set $NAME popup.drawing=toggle'
FRONT_APP_SCRIPT='[ "$SENDER" = "front_app_switched" ] && sketchybar --set $NAME label="$INFO"'

front_app=(
  icon.drawing=off
  label.font="$FONT:Black:12.0"
  padding_right=10
  y_offset=0
  associated_display=active
  script="$FRONT_APP_SCRIPT"
)
apple_logo=(
  icon=$APPLE
  icon.font="$FONT:Black:16.0"
  icon.color=$HIGHLIGHT
  padding_right=12
  padding_left=10
  label.drawing=off
  click_script="$POPUP_CLICK_SCRIPT"
  popup.height=35
)

apple_prefs=(
  icon=$PREFERENCES
  label="Preferences"
  click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
  icon=$ACTIVITY
  label="Activity"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon=$LOCK
  label="Lock Screen"
  click_script="pmset displaysleepnow; $POPUP_OFF"
)

apple_reboot=(
  icon=$REBOOT
  label="Reboot"
  click_script="reboot; $POPUP_OFF"
)

apple_reboot_now=(
  icon=$REBOOT_NOW
  label="Reboot Now"
  click_script="reboot now; $POPUP_OFF"
)

sketchybar --add item apple.logo left \
  --set apple.logo "${apple_logo[@]}" \
  \
  --add item apple.prefs popup.apple.logo \
  --set apple.prefs "${apple_prefs[@]}" \
  \
  --add item apple.activity popup.apple.logo \
  --set apple.activity "${apple_activity[@]}" \
  \
  --add item apple.lock popup.apple.logo \
  --set apple.lock "${apple_lock[@]}" \
  \
  --add item apple.reboot popup.apple.logo \
  --set apple.reboot "${apple_reboot[@]}" \
  \
  --add item apple.reboot_now popup.apple.logo \
  --set apple.reboot_now "${apple_reboot_now[@]}"

sketchybar --add item front_app left \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched

system_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item spacer0 left \
  --set spacer0 background.drawing=off \
  width=3

sketchybar --add bracket system front_app apple.logo \
  --set system "${system_bracket[@]}"
