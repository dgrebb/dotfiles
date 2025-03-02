#!/bin/bash

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -f | --focus)
    if [ "$2" = "prev" ]; then
      pos=-1
    else
      pos=1
    fi
    shift
    ;;
  esac
  shift
done

# Default to next window if not specified
pos=${pos:-1}

# Get the focused window's app and ID
focused_window=$(yabai -m query --windows --window)
focused_app=$(echo "$focused_window" | jq -r '.app')
focused_id=$(echo "$focused_window" | jq -r '.id')
focused_space=$(echo "$focused_window" | jq -r '.space')

# Debug output
echo "Focused app: $focused_app"
echo "Focused ID: $focused_id"
echo "Focused space: $focused_space"

# Get the current space's layout
space_layout=$(yabai -m query --spaces --space | jq -r '.type')
echo "Space layout: $space_layout"

# Get all windows of the same app in the current space
all_windows=$(yabai -m query --windows | jq -c --arg app "$focused_app" --arg space "$focused_space" \
  '[.[] | select(.app==$app and .space==($space|tonumber) and (."is-hidden" | not) and (."is-minimized" | not))]')
window_count=$(echo "$all_windows" | jq 'length')

echo "Found $window_count windows for $focused_app in space $focused_space"

# If there are multiple windows, find the next one to focus
if [ "$window_count" -gt 1 ]; then
  # Sort windows based on layout type
  if [ "$space_layout" = "stack" ]; then
    # For stack layout, use stack-index for sorting
    sorted_windows=$(echo "$all_windows" | jq 'sort_by(."stack-index")')
  else
    # For other layouts, sort by position
    sorted_windows=$(echo "$all_windows" | jq 'sort_by(.frame.x, .frame.y)')
  fi

  # Get the index of the current window in the sorted list
  current_index=$(echo "$sorted_windows" | jq --arg id "$focused_id" 'map(.id | tostring) | index($id)')

  # Calculate the next index with wraparound
  next_index=$(((current_index + pos) % window_count))
  # Handle negative indices
  if [ "$next_index" -lt 0 ]; then
    next_index=$((window_count + next_index))
  fi

  # Get the ID of the next window
  next_window_id=$(echo "$sorted_windows" | jq -r --argjson idx "$next_index" '.[$idx].id')

  echo "Current index: $current_index, Next index: $next_index, Next window ID: $next_window_id"

  # Focus the next window
  yabai -m window --focus "$next_window_id"
else
  # Notify if no other windows found
  osascript -e 'display notification "No other windows of this application found" with title "Window Cycling"'
fi
