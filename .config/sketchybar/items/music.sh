# Add event
sketchybar -m --add event song_update com.apple.Music.playerInfo

# Different workstations have different Music.app API versions
if [[ "$MACHINE" == 'office' ]]; then
  MUSIC_CLICK_SCRIPT="$PLUGIN_DIR/music_click-work.sh"
else
  MUSIC_CLICK_SCRIPT="$PLUGIN_DIR/music_click.sh"
fi

if [ "$main_display" == "$HOME_MACBOOK_UUID" ] || [ "$main_display" == "$WORK_MACBOOK_UUID" ]; then
  ARTIST_POS=e
  ARTIST_PAD=9
  ALBUM_DRAWING=off
  TITLE_POS=q
  TITLE_PAD=9
  TITLE_FONT="SF Compact Display:Regular:14"
else
  ARTIST_POS=center
  ALBUM_DRAWING=on
  TITLE_POS=center
  ARTIST_PAD=9
  TITLE_PAD=0
  TITLE_FONT="SF Compact Display:Bold:14"
fi

# Add Music Item
sketchybar -m --add item music.artist $ARTIST_POS \
  --set music.artist drawing=off \
  click_script="$PLUGIN_DIR/music.artist_click.sh" \
  script="$PLUGIN_DIR/music.art.sh" \
  icon.y_offset=1 \
  label.font="SF Compact Display:Regular:14" \
  background.padding_right=0 \
  background.padding_left=0 \
  associated_display=1 \
  label.padding_right=$ARTIST_PAD \
  label.padding_left=0 \
  icon.padding_left=0 \
  icon.padding_right=$ARTIST_PAD \
  --subscribe music.artist song_update

# Add Music Item
sketchybar -m --add item music.title $TITLE_POS \
  --set music.title script="$PLUGIN_DIR/music.sh" \
  click_script="$MUSIC_CLICK_SCRIPT" \
  icon.padding_left=$TITLE_PAD \
  update_freq=15 \
  scroll_texts=on \
  label.max_chars=20 \
  label.padding_right=$TITLE_PAD \
  label.padding_left=$TITLE_PAD \
  background.padding_right=0 \
  background.padding_left=0 \
  label.font="$TITLE_FONT" \
  drawing=off \
  associated_display=1 \
  --subscribe music.title song_update

# Add Music Item
sketchybar -m --add item music.album center \
  --set music.album drawing=$ALBUM_DRAWING \
  icon.y_offset=1 \
  background.padding_right=0 \
  background.padding_left=0 \
  associated_display=1 \
  label.font="SF Compact Display:Regular:14" \
  label.padding_right=15 \
  label.padding_left=5 \
  icon.padding_left=0 \
  --subscribe music.album song_update

music_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

if [ "$main_display" == "$HOME_MACBOOK_UUID" ] || [ "$main_display" == "$WORK_MACBOOK_UUID" ]; then
  sketchybar --add bracket music_l music.artist \
    --set music_l "${music_bracket[@]}"
  sketchybar --add bracket music_r music.title \
    --set music_r "${music_bracket[@]}"
else
  sketchybar --add bracket music music.title music.artist music.album \
    --set music "${music_bracket[@]}"
fi
