#!/bin/bash

read -r -d '' dialog <<'EOF'
  set answer to button returned of (display dialog "Done with display changes?" buttons {"No", "Yes"} with icon caution)
    return answer
EOF

answer=$(osascript -e "$dialog")

if [[ "$answer" == 'Yes' ]]; then
  yabai --restart-service
  sketchybar --reload
else
  echo "exiting. do it yourself, then."
fi
