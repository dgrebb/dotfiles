#!/usr/bin/env bash
# Show the focused Aerospace workspace id/name.

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

FOCUSED="${FOCUSED_WORKSPACE:-}"
if [[ -z "$FOCUSED" ]]; then
  FOCUSED="$(aerospace list-workspaces --focused 2>/dev/null || true)"
fi

if [[ -z "$FOCUSED" ]]; then
  FOCUSED="—"
fi

sketchybar --set "$NAME" label="$FOCUSED" \
  --animate tanh 12 --set "$NAME" label.y_offset=4 label.y_offset=0
