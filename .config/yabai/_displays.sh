#!/bin/bash

# Get list of displays
# yabai -m query --displays

# A list of displays and their properties
HOME_EX_MAIN_UUID="B63E3652-FEA6-43EE-8D06-66978CE762DC"
HOME_EX_LEFT_UUID="202E0F9C-C03B-4D59-A355-0FFFA8D84CF6"
HOME_EX_RIGHT_UUID="CF935F30-821B-4065-987C-3EB99DB94CCD"
HOME_MACBOOK_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"
NORMAL_BAR=32
NOTCH_BAR=0
HOME_AIR_UUID=""
WORK_MAIN_UUID=""
WORK_LEFT_UUID=""
WORK_MACBOOK_UUID="37D8832A-2D66-02CA-B9F7-8F30A301B230"
WORK_MACBOOK_UUID_17="9CB63E1D-C8F1-608A-73F8-E86AF9C67B0F"

# Display utilities

# Return number of displays
displayCount() {
  yabai -m query --displays | jq -r '. | length'
}

# Returns main display's UUID
getMainDisplayUUID() {
  yabai -m query --displays | jq -r '.[0].uuid'
}
