#!/bin/bash

# Link them
ln -sf ~/Projects/dotfiles/.dotfiles/.aliases ~/.aliases
ln -sf ~/Projects/dotfiles/.dotfiles/.functions ~/.functions
ln -sf ~/Projects/dotfiles/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/Projects/dotfiles/.dotfiles/.zshrc ~/.zshrc

# Copy, don't link, the .gitconfig file
rm -rf ~/.gitconfig && cp ~/Projects/dotfiles/.dotfiles/.gitconfig ~/.gitconfig

# Others while we're at it
ln -sf ~/Projects/dotfiles/.config/iTerm2 ~/.config/iTerm2
ln -sf ~/Projects/dotfiles/.config/iTerm2/Scripts ~/Library/Application\ Support/iTerm2/Scripts
ln -sf ~/Projects/dotfiles/.vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -sf ~/Projects/dotfiles/.vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/Projects/dotfiles/.config/sketchybar ~/.config/sketchybar
ln -sf ~/Projects/dotfiles/.config/yabai ~/.config/yabai
ln -sf ~/Projects/dotfiles/.config/machine.sh ~/.config/machine.sh
# ln -s ~/Projects/dotfiles/.dotfiles/ ~/
# ln -s ~/Projects/dotfiles/.dotfiles/ ~/
# ln -s ~/Projects/dotfiles/.dotfiles/ ~/
# ln -s ~/Projects/dotfiles/.dotfiles/ ~/
# ln -s ~/Projects/dotfiles/.dotfiles/ ~/

mkdir ~/.sketchyrw

echo "✓ Done linking dotfiles!"
echo "‼️ Remember to set up the ~/.machine and ~/.secrets files if needed."
