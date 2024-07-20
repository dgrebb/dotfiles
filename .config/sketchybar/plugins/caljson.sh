#!/bin/bash

todays=(
  "$HOME/Projects/dboard/build/client/today.json"
  "$HOME/Projects/dboard/static/today.json"
  "$HOME/Projects/dboard/.svelte-kit/output/client/today.json"
)
tomorrows=(
  "$HOME/Projects/dboard/build/client/tomorrow.json"
  "$HOME/Projects/dboard/static/tomorrow.json"
  "$HOME/Projects/dboard/.svelte-kit/output/client/tomorrow.json"
)

# Capture the output of the command once
today=$($HOME/.config/sketchybar/plugins/calendumper.sh -n -c "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders")
tomorrow=$($HOME/.config/sketchybar/plugins/calendumper.sh -t -c "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders")

echo $today 'is today'
echo $tomorrow 'is tomorrow'

# Iterate over the files array and write the output to each file
for file in "${todays[@]}"; do
  echo "$today" >"$file"
done

for file in "${tomorrows[@]}"; do
  echo "$tomorrow" >"$file"
done
