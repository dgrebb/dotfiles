#!/bin/bash
PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')
GROUP=$(if [ ${PLATFORM} == "linux" ]; then echo "${USER}"; else echo "staff"; fi)

# Set nvm
install -d -m 0755 -o "${USER}" -g "${GROUP}" "${HOME}/.nvm"

# Install Node
source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" && nvm install --lts && nvm use --lts
