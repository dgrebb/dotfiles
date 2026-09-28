#!/bin/bash

# Disable SIP
# https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection

# Upgrade
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#updating-to-the-latest-release

YABAI=$(which yabai)
USER=$(whoami)
HASH=$(shasum -a 256 $YABAI)

echo "Configuring yabai"
sudo touch /private/etc/sudoers.d/yabai
sudo echo "$USER ALL=(root) NOPASSWD: sha256:$HASH $YABAI --load-sa" >/private/etc/sudoers.d/yabai
