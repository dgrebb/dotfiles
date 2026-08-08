#!/bin/bash
# Now-playing — sits in the center so the MacBook notch can "own" the middle.
# Hidden automatically when Music.app is not running / stopped.

# Different workstations have different Music.app API versions
if [[ "${MACHINE:-}" == 'office' ]]; then
  MUSIC_CLICK_SCRIPT="$PLUGIN_DIR/music_click-work.sh"
else
  MUSIC_CLICK_SCRIPT="$PLUGIN_DIR/music_click.sh"
fi

sketchybar --add event song_update com.apple.Music.playerInfo

music_note=(
  drawing=off
  icon=$MUSIC_NOTE
  icon.font="$FONT:Regular:14.0"
  icon.color=$MAGENTA
  icon.padding_left=10
  icon.padding_right=6
  label.drawing=off
  background.drawing=off
)

music_title=(
  drawing=off
  script="$PLUGIN_DIR/music.sh"
  click_script="$MUSIC_CLICK_SCRIPT"
  update_freq=15
  scroll_texts=on
  label.max_chars=22
  label.font="$FONT:Semibold:12.0"
  label.padding_left=0
  label.padding_right=10
  icon.padding_left=0
  icon.padding_right=6
  background.drawing=off
)

music_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

# Center placement keeps the notch clear on laptops and looks balanced on externals
sketchybar --add item music.note center \
  --set music.note "${music_note[@]}" \
  \
  --add item music.title center \
  --set music.title "${music_title[@]}" \
  --subscribe music.title song_update \
  \
  --add bracket music music.note music.title \
  --set music "${music_bracket[@]}"
