#!/bin/bash

# shellcheck disable=SC1091
source "$CONFIG_DIR/plugins/volume_common.sh"

# Drop stale peek scripts and click-pin state from the previous config load.
# pkill -f is a regex; escape the path so it cannot match unrelated processes.
VOLUME_PLUGIN_PATTERN=$(printf '%s\n' "$PLUGIN_DIR/volume.sh" | sed 's/[.[\*^$()+?{|]/\\&/g')
pkill -f "$VOLUME_PLUGIN_PATTERN" 2>/dev/null || true
rm -f "$VOLUME_PIN_FILE" "$VOLUME_OPEN_FILE"
echo 0 > "$VOLUME_GEN_FILE"

CURRENT_VOLUME=$(osascript <<'EOF'
set s to get volume settings
if output muted of s then
  return 0
else
  return output volume of s
end if
EOF
)
[[ "$CURRENT_VOLUME" =~ ^[0-9]+$ ]] || CURRENT_VOLUME=0
VOLUME_GLYPH=$(volume_glyph "$CURRENT_VOLUME")

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  padding_left=4
  padding_right=0
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$BACKGROUND_2
  slider.knob.drawing=off
  slider.width=0
  slider.percentage=$CURRENT_VOLUME
  associated_display=1
)

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  padding_left=10
  padding_right=0
  icon=$VOLUME_GLYPH
  icon.width=0
  icon.align=left
  icon.color=$GREY
  icon.font="$FONT:Regular:14.0"
  label=$VOLUME_GLYPH
  label.width=25
  label.align=left
  label.font="$FONT:Regular:14.0"
  associated_display=1
)

sketchybar --add event volume_sync \
  --add slider volume right \
  --set volume "${volume_slider[@]}" \
  --subscribe volume volume_sync \
  mouse.clicked \
  \
  --add item volume_icon right \
  --set volume_icon "${volume_icon[@]}"

sketchybar --add item volume_gap right \
  --set volume_gap background.drawing=off \
  width=5

# SketchyBar's volume_change event is not delivered for this output device,
# so a small CoreAudio watcher triggers volume_sync instead.
WATCH_BIN="$HOME/.cache/sketchybar/volume_watch"
WATCH_PID="$HOME/.cache/sketchybar/volume_watch.pid"
mkdir -p "$HOME/.cache/sketchybar"
if [[ ! -x "$WATCH_BIN" || "$PLUGIN_DIR/volume_watch.c" -nt "$WATCH_BIN" ]]; then
  clang -framework CoreAudio -O2 -o "$WATCH_BIN" "$PLUGIN_DIR/volume_watch.c" || true
fi
if [[ -x "$WATCH_BIN" ]]; then
  if [[ -f "$WATCH_PID" ]]; then
    kill "$(cat "$WATCH_PID")" 2>/dev/null || true
  fi
  WATCH_PATTERN=$(printf '%s\n' "$WATCH_BIN" | sed 's/[.[\*^$()+?{|]/\\&/g')
  pkill -f "$WATCH_PATTERN" 2>/dev/null || true
  "$WATCH_BIN" >/dev/null 2>&1 &
  echo $! > "$WATCH_PID"
  disown 2>/dev/null || true
fi
