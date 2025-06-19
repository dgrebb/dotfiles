#!/bin/bash
export cwd=$(pwd)
green="32"
red="31"
yellow="33"
BOLDRED="\e[1;${red}m"
BOLDGREEN="\e[1;${green}m"
BOLDYELLOW="\e[1;${yellow}m"

NC="\033[0m" # No Color

# Set permissions on shell scripts
echo "Setting permissions on shell scripts"
chmod +x $cwd/**/*.sh

# Run Everything
$cwd/steps/all.sh

# Done
printf "${BOLDGREEN}System ready.${NC}\n\n"
read -p $'\e[33mReboot now? \n\n  > ' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo reboot now
fi
