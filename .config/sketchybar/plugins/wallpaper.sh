#!/bin/bash

# Requires `curl`, `jq`, and `wget`
# TODO List
# 1. Set up a `.secrets` file in `$HOME/.config`.
#   Use the `.secrets.example` as a template.
# 2. Set up Unsplash API Access/Account
#   "Applications" page — https://unsplash.com/oauth/applications
#   (register one here: https://unsplash.com/oauth/applications/new)
#   it's free but limited to 50 requests / hour
# 3. Add `ACCESS_KEY` with the "Access Key" from the Unsplash API
# 4. Set up writeable directory to store saved images
# 5. Change `WALLPAPER_PATH` below to Step 4's path

# Only execute if this is a direct call (not when sourced by sketchybar)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  source "$HOME/.config/sketchybar/colors.sh"
  source "$HOME/.config/.secrets"

  QUERY="macro"
  ORIENTATION="landscape"
  TIMESTAMP=$(echo '('$(date +"%s.%N") ' * 10)/1' | bc)
  WALLPAPER_PATH="$HOME/Pictures/wallpaper"

  URL=$(
    curl -G --location https://api.unsplash.com/photos/random \
      --data-urlencode "query=${QUERY}" --data-urlencode "orientation=${ORIENTATION}" \
      --header "Authorization: Client-ID ${ACCESS_KEY}" | jq -r '.urls.full'
  )

  wget -q $URL -O "${WALLPAPER_PATH}/wallpaper_${TIMESTAMP}.jpg"
  WALLPAPER="${WALLPAPER_PATH}/wallpaper_${TIMESTAMP}.jpg"

  if [ -f "$WALLPAPER" ]; then
    echo "Wallpaper file exists"
    /opt/homebrew/bin/wallpaper set "$WALLPAPER"
  else
    echo "Wallpaper file does not exist!"
    exit 1
  fi
fi

# Remove old methods that don't work on Sequoia
# osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WALLPAPER\""
# sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$WALLPAPER'"
# killall Dock
# osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\" as POSIX file"
