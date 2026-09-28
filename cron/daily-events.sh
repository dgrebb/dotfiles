#!/bin/bash

if ! command -v icalBuddy &>/dev/null; then
  echo "icalBuddy could not be found"
  if ! command -v brew &>/dev/null; then
    echo "Install ical-buddy first"
    open "https://hasseg.org/icalBuddy/"
    exit 1
  else
    echo "Installing now..."
    brew install ical-buddy
    echo "icalBuddy installed!"
  fi
fi

# Settings
# OBSIDIAN_VAULT="/Users/dgrebb200/Library/Mobile Documents/iCloud"~md~obsidian/Documents/Office
# TEMPLATE_PATH="$OBSIDIAN_VAULT"/_Logs/_Templates

# ln -sf "${TEMPLATE_PATH}" ./templates

# # Set Template
# TEMPLATE="obsidian/_Daily.md"

# CONTENT=cat "${TEMPLATE}"

# # Get tomorrow's date in YY.MM.DD format (cross-platform)
# if [[ $(uname) == "Darwin" ]]; then
#   # macOS
#   TOMORROW_DATE=$(date -j -v+1d "+%y.%m.%d")
# else
#   # Linux and other Unix-like systems
#   TOMORROW_DATE=$(date -d "tomorrow" "+%y.%m.%d")
# fi

if [ "$1" == "today" ]; then

  # Get Tomorrow's Activities from Apple Calendar
  TEXT=$(icalBuddy -ic "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders" -n -sc -ss "\n" -b "- " -ab "- ‼️ " -iep title,datetime -ps "| ➡ |" -po "title,datetime" -tf "%H:%M" -nrd -df "" eventsFrom:"today" to:"today")

  OBSIDIAN_DATES="$(echo "$TEXT" | sed -E 's/➡ ([0-9]{2}:[0-9]{2}) - ([0-9]{2}:[0-9]{2})/\[startTime:: \1\]  [endTime:: \2]/g')"

  CLIPBOARD="$(echo "$OBSIDIAN_DATES" | sed -E 's/^(Life|Calendar|Appointments):/## \1/')"

  echo "$CLIPBOARD"

else

  # Get Tomorrow's Activities from Apple Calendar
  TEXT=$(icalBuddy -ic "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders" -n -sc -ss "\n" -b "- " -ab "- ‼️ " -iep title,datetime -ps "| ➡ |" -po "title,datetime" -tf "%H:%M" -nrd -df "" eventsFrom:"tomorrow" to:"tomorrow")

  OBSIDIAN_DATES="$(echo "$TEXT" | sed -E 's/➡ ([0-9]{2}:[0-9]{2}) - ([0-9]{2}:[0-9]{2})/\[startTime:: \1\]  [endTime:: \2]/g')"

  CLIPBOARD="$(echo "$OBSIDIAN_DATES" | sed -E 's/^(Life|Calendar|Appointments):/## \1/')"

  echo "$CLIPBOARD"

fi
