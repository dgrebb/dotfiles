#!/usr/bin/env bash
# Lightweight "in a call?" signal using running meeting apps.

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
source "$CONFIG_DIR/colors.sh"

MEETING_APPS=("Microsoft Teams" "Microsoft Teams (work or school)" "zoom.us" "FaceTime" "Webex")

running=()
for app in "${MEETING_APPS[@]}"; do
  if pgrep -if "$app" >/dev/null 2>&1; then
    running+=("$app")
  fi
done

front="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || true)"

in_call=false
label="idle"
color="$GREY"
icon="󰍡"

for app in "${running[@]}"; do
  short="${app%% *}"
  [[ "$app" == "zoom.us" ]] && short="Zoom"
  [[ "$app" == "Microsoft Teams (work or school)" ]] && short="Teams"
  label="$short"
  color="$ORANGE"
  icon="󰕂"
  if [[ "$front" == "$app" ]]; then
    in_call=true
    color="$RED"
    icon="󰕥"
    label="$short · live"
    break
  fi
done

if ((${#running[@]} == 0)); then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

sketchybar --set "$NAME" drawing=on icon="$icon" icon.color="$color" label="$label" label.color="$color"
if [[ "$in_call" == true ]]; then
  sketchybar --animate tanh 12 --set "$NAME" background.border_color="$RED" \
    --animate tanh 12 --set "$NAME" icon.y_offset=3 icon.y_offset=0
fi
