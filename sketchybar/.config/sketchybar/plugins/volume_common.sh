#!/bin/bash
# Shared slider state for the volume item, plugin, and click script.
# OPEN/PIN live in files so overlapping volume events don't restart or
# fight the width animation (querying the slider mid-animation is racy).

VOLUME_SLIDER_WIDTH=100
VOLUME_STATE_DIR="${TMPDIR:-/tmp}/sketchybar-volume"
mkdir -p "$VOLUME_STATE_DIR"
VOLUME_GEN_FILE="$VOLUME_STATE_DIR/generation"
VOLUME_PIN_FILE="$VOLUME_STATE_DIR/pinned"
VOLUME_OPEN_FILE="$VOLUME_STATE_DIR/open"

volume_glyph() {
  # shellcheck disable=SC1091
  source "$CONFIG_DIR/icons.sh"
  case "$1" in
    [6-9][0-9]|100) printf '%s' "$VOLUME_100" ;;
    [3-5][0-9]) printf '%s' "$VOLUME_66" ;;
    [1-2][0-9]) printf '%s' "$VOLUME_33" ;;
    [1-9]) printf '%s' "$VOLUME_10" ;;
    0) printf '%s' "$VOLUME_0" ;;
    *) printf '%s' "$VOLUME_100" ;;
  esac
}

volume_bump_generation() {
  local gen=0
  if [[ -f "$VOLUME_GEN_FILE" ]]; then
    gen=$(cat "$VOLUME_GEN_FILE" 2>/dev/null || echo 0)
  fi
  [[ "$gen" =~ ^[0-9]+$ ]] || gen=0
  gen=$((gen + 1))
  echo "$gen" > "$VOLUME_GEN_FILE"
  printf '%s' "$gen"
}

volume_generation() {
  local gen=0
  if [[ -f "$VOLUME_GEN_FILE" ]]; then
    gen=$(cat "$VOLUME_GEN_FILE" 2>/dev/null || echo 0)
  fi
  [[ "$gen" =~ ^[0-9]+$ ]] || gen=0
  printf '%s' "$gen"
}

volume_slider_width() {
  sketchybar --animate tanh 18 --set volume slider.width="$1"
}
