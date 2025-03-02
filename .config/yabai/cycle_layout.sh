#!/bin/bash

# Array of layouts to cycle through
layouts=("bsp" "stack" "float")

# Get current layout
current_layout=$(yabai -m query --spaces --space | jq -r '.type')

# Find the index of the current layout in our array
current_index=-1
for i in "${!layouts[@]}"; do
    if [[ "${layouts[$i]}" = "${current_layout}" ]]; then
        current_index=$i
        break
    fi
done

# Calculate the next index (cycling back to 0 if needed)
next_index=$(( (current_index + 1) % ${#layouts[@]} ))
next_layout="${layouts[$next_index]}"

# Apply the new layout
yabai -m space --layout "${next_layout}"

# Display notification
message="Space set to ${next_layout}"
osascript -e "display notification \"$message\" with title \"Yabai Layout\""
