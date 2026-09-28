#!/bin/bash

# Requires `curl`, `jq`, and `wget`

source "$HOME/.config/.secrets"

RW_DIR="${SKETCHYBAR_RW_DIR:-$HOME/.config/.sketchyrw}"
QUERY_FILE="$RW_DIR/wallpaper_query"
DEFAULT_QUERY="dark"
ORIENTATION="landscape"
WALLPAPER_PATH="$HOME/Pictures/wallpaper"

mkdir -p "$RW_DIR" "$WALLPAPER_PATH"

load_query() {
  if [[ -s "$QUERY_FILE" ]]; then
    QUERY=$(<"$QUERY_FILE")
  else
    QUERY="$DEFAULT_QUERY"
  fi
}

save_query() {
  local new_query="$1"
  [[ -z "$new_query" ]] && return 1
  printf '%s' "$new_query" >"$QUERY_FILE"
}

prompt_for_query() {
  local current_query="$1"
  /usr/bin/osascript <<EOF
set response to display dialog "Wallpaper query:" default answer "$current_query" buttons {"Cancel", "Save"} default button "Save" cancel button "Cancel"
return text returned of response
EOF
}

request_wallpaper() {
  local timestamp wallpaper url
  timestamp=$(echo '('$(date +"%s.%N") ' * 10)/1' | bc)

  echo "Fetching wallpaper from Unsplash (query: $QUERY)..."
  url=$(
    curl -sG --location https://api.unsplash.com/photos/random \
      --data-urlencode "query=${QUERY}" \
      --data-urlencode "orientation=${ORIENTATION}" \
      --header "Authorization: Client-ID ${ACCESS_KEY}" | jq -r '.urls.full'
  )

  if [[ -z "$url" || "$url" == "null" ]]; then
    echo "ERROR: Failed to get URL from Unsplash API"
    exit 1
  fi

  wallpaper="${WALLPAPER_PATH}/wallpaper_${timestamp}.jpg"
  if ! wget -q --show-progress "$url" -O "$wallpaper"; then
    echo "ERROR: wget failed to download the image"
    exit 1
  fi

  if [[ -f "$wallpaper" && -s "$wallpaper" ]]; then
    /opt/homebrew/bin/wallpaper set "$wallpaper"
  else
    echo "FAILED: Wallpaper file is empty or missing"
    exit 1
  fi
}

load_query

case "$BUTTON" in
  right)
    new_query="$(prompt_for_query "$QUERY")" || exit 0
    save_query "$new_query" || exit 0
    QUERY="$new_query"
    request_wallpaper
    ;;
  left|"")
    request_wallpaper
    ;;
  *)
    # Ignore other button events.
    ;;
esac

# Remove old methods that don't work on Sequoia
# osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WALLPAPER\""
# sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$WALLPAPER'"
# killall Dock
# osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\" as POSIX file"
