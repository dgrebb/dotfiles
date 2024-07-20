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
s15s=(
  "$HOME/Projects/dboard/build/client/rolling15.json"
  "$HOME/Projects/dboard/static/rolling15.json"
  "$HOME/Projects/dboard/.svelte-kit/output/client/rolling15.json"
)

# Capture the output of the command once
today=$($HOME/.config/sketchybar/plugins/calendumper.sh -n -c "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders")
tomorrow=$($HOME/.config/sketchybar/plugins/calendumper.sh -t -c "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders")
s15=$($HOME/.config/sketchybar/plugins/calendumper.sh -s15 -c "Calendar,Vacation,Dan Grebb,Personal,Business,Appointments,Reminders")

# Iterate over the files array and write the output to each file
for file in "${todays[@]}"; do
  echo "$today" >"$file"
done

for file in "${tomorrows[@]}"; do
  echo "$tomorrow" >"$file"
done

for file in "${s15s[@]}"; do
  echo "$s15" >"$file"
done
