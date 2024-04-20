sketchybar --add item focus right \
  --set focus \
  icon= \
  update_freq=15 \
  width=24 \
  icon.padding_right=0 \
  label.width=0 \
  label.padding_right=0 \
  script="$PLUGIN_DIR/focus.sh" \
  click_script="shortcuts run \"Toggle Focus\"" \
  --add event focus_on "_NSDoNotDisturbEnabledNotification" \
  --add event focus_off "_NSDoNotDisturbDisabledNotification" \
  --subscribe focus focus_on focus_off
