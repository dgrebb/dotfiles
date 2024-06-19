#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors
source "$HOME/.config/machine.sh"
dboard_music_json="$HOME/Projects/dboard/build/client/music.json"
dev_dboard_music_json="$HOME/Projects/dboard/static/music.json"
prev_dboard_music_json="$HOME/Projects/dboard/.svelte-kit/output/client/music.json"

# FIXME: Running an osascript on an application target opens that app
# This sleep is needed to try and ensure that theres enough time to
# quit the app before the next osascript command is called. I assume
# com.apple.iTunes.playerInfo fires off an event when the player quits
# so it imediately runs before the process is killed
sleep 1

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then
  sketchybar -m --set music drawing=off
  exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE == "stopped" ]]; then
  sketchybar --set music drawing=off
  exit 0
fi

TITLE=$(osascript -e 'tell application "Music" to get name of current track')
ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')
ALBUM=$(osascript -e 'tell application "Music" to get album of current track')
if [[ "$MACHINE" == 'office' ]]; then
  LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")
else
  LOVED=$(osascript -l JavaScript -e "Application('Music').currentTrack().favorited()")
fi

COLOR=$WHITE

if [[ "$LOVED" = 'true' ]]; then
  icon=""
  COLOR=$RED
fi

if [[ $PLAYER_STATE == "paused" ]]; then
  icon=""
fi

if [[ $PLAYER_STATE == "playing" ]] && [[ "$LOVED" = 'false' ]]; then
  icon=""
fi

if [[ ${#TITLE} -gt 25 ]]; then
  TITLE=$(printf "$(echo $TITLE)")
fi

if [[ ${#ARTIST} -gt 25 ]]; then
  ARTIST=$(printf "$(echo $ARTIST | cut -c 1-25)…")
fi

if [[ ${#ALBUM} -gt 25 ]]; then
  ALBUM=$(printf "$(echo $ALBUM | cut -c 1-12)…")
fi

if [[ "$main_display" != "$HOME_MACBOOK_UUID" ]] && [[ "$main_display" != "$WORK_MACBOOK_UUID" ]]; then
  DRAWING=on
else
  DRAWING=on
fi

sketchybar -m --set music.title icon="$icon" \
  icon.color="${COLOR}" \
  label="${TITLE}" \
  drawing=$DRAWING

sketchybar -m --set music.artist \
  label.color="${WHITE}" \
  label="${ARTIST} »" \
  drawing=$DRAWING

sketchybar -m --set music.album \
  label="« ${ALBUM}" \
  drawing=$DRAWING

echo "{\"artist\": \"${ARTIST}\", \"album\": \"${ALBUM}\", \"title\": \"${TITLE}\", \"loved\": \"${LOVED}\"}" >$dboard_music_json
echo "{\"artist\": \"${ARTIST}\", \"album\": \"${ALBUM}\", \"title\": \"${TITLE}\", \"loved\": \"${LOVED}\"}" >$dev_dboard_music_json
echo "{\"artist\": \"${ARTIST}\", \"album\": \"${ALBUM}\", \"title\": \"${TITLE}\", \"loved\": \"${LOVED}\"}" >$prev_dboard_music_json
