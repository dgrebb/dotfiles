#!/bin/bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/plugins/volume_common.sh"

detail_on() {
  echo 1 > "$VOLUME_OPEN_FILE"
  echo 1 > "$VOLUME_PIN_FILE"
  volume_bump_generation >/dev/null
  volume_slider_width "$VOLUME_SLIDER_WIDTH"
}

detail_off() {
  rm -f "$VOLUME_OPEN_FILE" "$VOLUME_PIN_FILE"
  volume_bump_generation >/dev/null
  volume_slider_width 0
}

toggle_detail() {
  if [[ -f "$VOLUME_OPEN_FILE" ]]; then
    detail_off
  else
    detail_on
  fi
}

toggle_devices() {
  which SwitchAudioSource >/dev/null || exit 0
  # shellcheck disable=SC1091
  source "$CONFIG_DIR/colors.sh"

  args=(--remove '/volume.device\.*/' --set "$NAME" popup.drawing=toggle)
  COUNTER=0
  CURRENT="$(SwitchAudioSource -t output -c)"
  while IFS= read -r device; do
    COLOR=$GREY
    if [ "${device}" = "$CURRENT" ]; then
      COLOR=$WHITE
    fi
    args+=(--add item volume.device.$COUNTER popup."$NAME" \
           --set volume.device.$COUNTER label="${device}" \
                                        label.color="$COLOR" \
                 click_script="SwitchAudioSource -s \"${device}\" && sketchybar --set /volume.device\.*/ label.color=$GREY --set \$NAME label.color=$WHITE --set $NAME popup.drawing=off")
    COUNTER=$((COUNTER+1))
  done <<< "$(SwitchAudioSource -a -t output)"

  sketchybar -m "${args[@]}" > /dev/null
}

if [ "$BUTTON" = "right" ] || [ "$MODIFIER" = "shift" ]; then
  toggle_devices
else
  toggle_detail
fi
