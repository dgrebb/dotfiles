#!/bin/bash

zen_on() {
  sketchybar \
    --set apple.logo drawing=off \
    --set '/cpu.*/' drawing=off \
    --set calendar icon.drawing=off \
    --set front_app drawing=off \
    --set volume_icon drawing=off \
    --set utils drawing=off \
    --set omnifocus updates=off \
    --set mail updates=off \
    --set mail drawing=off \
    --set office drawing=off \
    --set omnifocus drawing=off \
    --set ghmon.status drawing=off \
    --set "iStat Menus Menubar,com.bjango.istatmenus.cpu" drawing=off \
    --set "iStat Menus Menubar,com.bjango.istatmenus.memory" drawing=off \
    --set "SystemUIServer,TimeMachine.TMMenuExtraHost" drawing=off \
    --set nightshift drawing=off \
    --set network.up drawing=off \
    --set network.down drawing=off \
    --set ip_address drawing=off \
    --set wallpaper drawing=off \
    --set rescuetime drawing=off \
    --set teams drawing=off updates=off
}

zen_off() {
  sketchybar \
    --set apple.logo drawing=on \
    --set '/cpu.*/' drawing=on \
    --set calendar icon.drawing=on \
    --set front_app drawing=on \
    --set volume_icon drawing=on \
    --set utils drawing=on \
    --set omnifocus updates=on \
    --set mail updates=on \
    --set office drawing=on \
    --set omnifocus drawing=on \
    --set ghmon.status drawing=on \
    --set "iStat Menus Menubar,com.bjango.istatmenus.cpu" drawing=on \
    --set "iStat Menus Menubar,com.bjango.istatmenus.memory" drawing=on \
    --set "SystemUIServer,TimeMachine.TMMenuExtraHost" drawing=on \
    --set nightshift drawing=on \
    --set network.up drawing=off \
    --set network.down drawing=off \
    --set ip_address drawing=on \
    --set wallpaper drawing=on \
    --set rescuetime drawing=on \
    --set teams drawing=on updates=on
}
