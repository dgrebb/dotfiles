#!/bin/bash

mkdir ~/.config/sketchybar
cp ../config/sketchybar/sketchybarrc ~/.config/sketchybar/sketchybarrc
mkdir ~/.config/sketchybar/plugins
cp -r ../config/sketchybar/plugins/ ~/.config/sketchybar/plugins/
chmod +x ~/.config/sketchybar/plugins/*

# Install Nerd Font Hack
brew install --cask font-hack-nerd-font

# uncomment if starting sketchybar at login
# brew services start sketchybar

echo 'SketchyBar installed and configured!'
