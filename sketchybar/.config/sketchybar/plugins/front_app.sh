#!/usr/bin/env bash
# Frontmost app label with sketchybar-app-font icon.
# Finder / empty focus → Apple glyph (SF Symbols via Hack Nerd Font).

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
# shellcheck disable=SC1091
source "$CONFIG_DIR/plugins/icon_map.sh"

APP_FONT="sketchybar-app-font"
NERD_FONT="${FONT:-Hack Nerd Font}"

update() {
  local app="${INFO:-}"
  if [[ -z "$app" ]]; then
    app="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || true)"
  fi

  # When nothing useful is focused, fall back to Apple + Finder
  if [[ -z "$app" || "$app" == "Finder" || "$app" == "访达" ]]; then
    sketchybar --set "$NAME" \
      icon="$APPLE" \
      icon.font="$NERD_FONT:Black:15.0" \
      icon.color="${HIGHLIGHT:-0x54ffffff}" \
      label="${app:-Finder}"
    return
  fi

  __icon_map "$app"
  local glyph="${icon_result:-:default:}"

  sketchybar --set "$NAME" \
    icon="$glyph" \
    icon.font="$APP_FONT:Regular:15.0" \
    icon.color="${ICON_COLOR:-0xbaffffff}" \
    label="$app"
}

case "$SENDER" in
"front_app_switched" | "forced" | "")
  update
  ;;
esac
