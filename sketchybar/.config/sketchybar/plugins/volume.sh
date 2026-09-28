#!/bin/bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/plugins/volume_common.sh"

apply_level() {
  local vol="$1" glyph
  glyph=$(volume_glyph "$vol")
  sketchybar --set volume_icon label="$glyph" \
             --set volume slider.percentage="$vol"
}

# Briefly reveal the slider, then collapse it if nothing newer happened
# and the user has not pinned it open with a click.
peek_slider() {
  local gen
  gen=$(volume_bump_generation)

  if [[ ! -f "$VOLUME_OPEN_FILE" ]]; then
    echo 1 > "$VOLUME_OPEN_FILE"
    volume_slider_width "$VOLUME_SLIDER_WIDTH"
  fi

  sleep 1.4

  if [[ "$(volume_generation)" == "$gen" && ! -f "$VOLUME_PIN_FILE" ]]; then
    rm -f "$VOLUME_OPEN_FILE"
    volume_slider_width 0
  fi
}

volume_change() {
  local vol="${INFO%%.*}"
  [[ "$vol" =~ ^[0-9]+$ ]] || return 0
  if (( vol > 100 )); then
    vol=100
  fi

  apply_level "$vol"

  # Startup sync should match the icon without playing the reveal.
  [[ "${VOLUME_QUIET:-0}" == "1" ]] && return 0
  # A click pins the slider open; later volume changes only move the level.
  [[ -f "$VOLUME_PIN_FILE" ]] && return 0

  peek_slider
}

mouse_clicked() {
  [[ "${PERCENTAGE:-}" =~ ^[0-9]+$ ]] || return 0
  osascript -e "set volume output volume $PERCENTAGE"
}

case "$SENDER" in
  volume_sync|volume_change) volume_change ;;
  mouse.clicked) mouse_clicked ;;
esac
