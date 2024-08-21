#!/bin/bash

if [ "$(sketchybar --query "Glucose Graph,Item-0" | jq -r ".geometry.drawing")" = "on" ]; then
  sketchybar --set "Glucose Graph,Item-0" drawing=off
else
  sketchybar --set "Glucose Graph,Item-0" drawing=on
fi
