#!/bin/bash

if [ "$(sketchybar --query nightscout | jq -r ".geometry.drawing")" = "on" ]; then
  sketchybar --set nightscout drawing=off
else
  sketchybar --set nightscout drawing=on
fi
