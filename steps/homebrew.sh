#!/bin/bash

# Install Homebrew
if ! command -v brew &>/dev/null; then
	echo "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH="/opt/homebrew/bin:$PATH"
	(
		echo
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
	) >>/Users/$(whoami)/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
	echo "✓ Homebrew installed!"
else
	echo "✓ Homebrew already installed! Moving on..."
fi
brew analytics off
brew update
brew upgrade

# Homebrew Bundle
echo "Installing bundle from Brewfile ➡ $cwd/Brewfile"
brew bundle --file="$cwd/Brewfile"
echo "✓ Homebrew bundle installed!"
