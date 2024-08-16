#!/bin/bash

# Requires `curl`, `jq`, and `wget`
# TODO List
# 1. Set up a `.secrets` file in `$HOME/.config`.
#   Use the `.secrets.example` as a template.
# 2. Set up Unsplash API Access/Account
#   "Applications" page — https://unsplash.com/oauth/applications
#   (register one here: https://unsplash.com/oauth/applications/new)
#   it's free but limited to 50 requests / hour
# 3. Add `ACCESS_KEY` with the "Access Key" from the Unsplash API
# 4. Set up writeable directory to store saved images
# 5. Change `WALLPAPER_PATH` below to Step 4's path

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/.secrets"

# Update
QUERY="wallpaper"
ORIENTATION="landscape"
TIMESTAMP=$(echo '('$(date +"%s.%N") ' * 10)/1' | bc)
WALLPAPER_PATH="$HOME/Pictures/wallpaper"

# TODO: Create popup with multiple options to choose from, search again, or change query via macos dialog

URL=$(
  curl -G --location https://api.unsplash.com/photos/random \
    --data-urlencode "query=${QUERY}" --data-urlencode "orientation=${ORIENTATION}" \
    --header "Authorization: Client-ID ${ACCESS_KEY}" | jq -r '.urls.full'
)
# Note: change the `jq` query to `.urls.raw` for larger displays

wget -q $URL -O "${WALLPAPER_PATH}/wallpaper_${TIMESTAMP}.jpg"
WALLPAPER="${WALLPAPER_PATH}/wallpaper_${TIMESTAMP}.jpg"

# TODO: Set wallpaper on all spaces via yet-to be determined Mission Control API
osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\" as POSIX file"
# osascript -e "tell application \"System Events\" to set desktop picture of to \"$WALLPAPER\" as POSIX file"
