#!/bin/sh

status=$(defaults read com.apple.controlcenter "NSStatusItem Visible FocusModes")

if [ "$status" = "1" ]; then
  sketchybar -m --set focus icon.color=0xFFFFFFFF
else
  sketchybar -m --set focus icon.color=0xFF999999
fi
