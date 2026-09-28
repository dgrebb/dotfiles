#!/bin/bash
# Loads the active theme palette. Switch themes by editing themes/active
# or: echo wings > ~/.config/sketchybar/themes/active && sketchybar --reload

THEME_FILE="$CONFIG_DIR/themes/active"
THEME="ember"
if [[ -f "$THEME_FILE" ]]; then
  THEME="$(tr -d '[:space:]' <"$THEME_FILE")"
fi

THEME_DIR="$CONFIG_DIR/themes/$THEME"
if [[ ! -f "$THEME_DIR/colors.sh" ]]; then
  echo "sketchybar: unknown theme '$THEME', falling back to ember" >&2
  THEME="ember"
  THEME_DIR="$CONFIG_DIR/themes/$THEME"
fi

export SKETCHYBAR_THEME="$THEME"
# shellcheck disable=SC1091
source "$THEME_DIR/colors.sh"
