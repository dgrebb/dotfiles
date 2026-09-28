#!/usr/bin/env bash
# Highlight a single Aerospace workspace pill.
# Usage: aerospace_space.sh <workspace-id>

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

source "$CONFIG_DIR/colors.sh"

SID="${1:-}"
if [[ -z "$SID" ]]; then
  exit 0
fi

FOCUSED="${FOCUSED_WORKSPACE:-}"
if [[ -z "$FOCUSED" ]]; then
  FOCUSED="$(aerospace list-workspaces --focused 2>/dev/null || true)"
fi

if [[ "$FOCUSED" == "$SID" ]]; then
  sketchybar --animate tanh 12 --set "$NAME" \
    icon.color="$BLUE" \
    background.drawing=on \
    background.color="$BACKGROUND_ACTIVE" \
    background.border_color="$HIGHLIGHT_BORDER"
else
  sketchybar --set "$NAME" \
    icon.color="$GREY" \
    background.drawing=off
fi
