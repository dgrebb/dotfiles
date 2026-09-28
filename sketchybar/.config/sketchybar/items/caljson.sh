caljson_config=(
  drawing=off
  script="$PLUGIN_DIR/caljson.sh"
  update_freq=14400
)

sketchybar --add item caljson right \
  --set caljson "${caljson_config[@]}"
