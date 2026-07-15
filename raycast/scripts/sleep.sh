#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Sleep
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Sleep the Machine
# @raycast.author dgrebb
# @raycast.authorURL https://raycast.com/dgrebb

osascript -e 'tell application "Finder" to sleep'
