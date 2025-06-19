#!/bin/bash

# Get the path of the currently playing album art in Music.app

# Exit if not running
APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then
    sketchybar -m --set music drawing=off
    exit 0
fi

# Specify the temporary directory and file name with a .png extension
temp_dir="$HOME/.config/.sketchyrw"
temp_file="$HOME/Pictures/album_art.png"
dboard_file="$HOME/Projects/dboard/build/client/album_art.png"
dev_dboard_file="$HOME/Projects/dboard/static/album_art.png"
prev_dboard_file="$HOME/Projects/dboard/.svelte-kit/output/client/album_art.png"

# Ensure the temporary directory exists
mkdir -p "$temp_dir"

# Run AppleScript to get the album art path
album_art_path=$(osascript -e '
tell application "Music"
    try
        set fileName to POSIX file "'"$temp_file"'"
        set fileNumber to open for access fileName with write permission
        if player state is playing then
            set currentTrack to current track
            set artworkData to raw data of artwork 1 of currentTrack
            if artworkData is not {} then
                write artworkData to fileNumber
                close access fileNumber
                close access fileName
                return fileName
            else
                return "No album art"
            end if
        else
            return "No music playing"
        end if
    on error
        try
            close access fileNumber
            close access fileName
        end try
    end try
end tell
')

# Also copy the image to dboard
cp $temp_file $dev_dboard_file
cp $temp_file $prev_dboard_file
cp $temp_file $dboard_file
