#!/bin/bash

WIDTH=2

detail_on() {
  sketchybar --set network.up drawing=on \
    --set network.down drawing=on
}

detail_off() {
  sketchybar --set network.up drawing=off \
    --set network.down drawing=off
}

toggle_detail() {
  DRAWING=$(sketchybar --query network.up | jq -r ".geometry.drawing")
  if [ "$DRAWING" == "off" ]; then
    detail_on
  else
    detail_off
  fi
}

toggle_detail
