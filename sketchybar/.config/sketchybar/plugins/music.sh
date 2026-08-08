#!/usr/bin/env bash
# Music.app now-playing plugin. Optional dboard JSON mirrors if those paths exist.

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
[[ -f "$HOME/.config/machine.sh" ]] && source "$HOME/.config/machine.sh"

# Music.app sometimes needs a beat after playerInfo fires during quit
sleep 0.4

if ! pgrep -x Music >/dev/null 2>&1; then
  sketchybar --set music.note drawing=off \
    --set music.title drawing=off \
    --set music drawing=off 2>/dev/null
  exit 0
fi

PLAYER_STATE="$(osascript -e 'tell application "Music" to player state as text' 2>/dev/null || echo stopped)"
if [[ "$PLAYER_STATE" == "stopped" ]]; then
  sketchybar --set music.note drawing=off \
    --set music.title drawing=off
  exit 0
fi

OGTITLE="$(osascript -e 'tell application "Music" to get name of current track' 2>/dev/null)"
OGARTIST="$(osascript -e 'tell application "Music" to get artist of current track' 2>/dev/null)"

LOVED="false"
if [[ "${MACHINE:-}" == 'office' ]]; then
  LOVED="$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()" 2>/dev/null || echo false)"
else
  LOVED="$(osascript -l JavaScript -e "Application('Music').currentTrack().favorited()" 2>/dev/null || echo false)"
fi

COLOR=$WHITE
icon=$PAUSE

if [[ "$LOVED" == "true" ]]; then
  icon=$LOVED
  COLOR=$RED
fi

if [[ "$PLAYER_STATE" == "paused" ]]; then
  icon=$PLAY
fi

if [[ "$PLAYER_STATE" == "playing" && "$LOVED" != "true" ]]; then
  icon=$PAUSE
fi

TITLE="$OGTITLE"
LABEL="$OGARTIST"
if [[ -n "$TITLE" && -n "$LABEL" ]]; then
  LABEL="$OGARTIST  ·  $TITLE"
elif [[ -n "$TITLE" ]]; then
  LABEL="$TITLE"
fi

sketchybar --set music.note drawing=on \
  --set music.title \
  icon="$icon" \
  icon.color="$COLOR" \
  label="$LABEL" \
  drawing=on

# Optional mirrors for a local dboard project — never fail the plugin
for dest in \
  "$HOME/Projects/dboard/build/client/music.json" \
  "$HOME/Projects/dboard/static/music.json"; do
  dir="$(dirname "$dest")"
  [[ -d "$dir" ]] || continue
  printf '{"artist":"%s","title":"%s","loved":%s}\n' \
    "${OGARTIST//\"/\\\"}" "${OGTITLE//\"/\\\"}" "$LOVED" >"$dest" 2>/dev/null || true
done
