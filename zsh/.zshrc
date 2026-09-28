#!/bin/zsh

# Aliases and functions
source $HOME/.config/utils/.aliases
source $HOME/.config/utils/.functions

# History — persist commands; up/down search what you've typed so far (not full history cycle)
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY      # write timestamps to history file
setopt INC_APPEND_HISTORY    # append after each command (multi-terminal friendly)
setopt HIST_IGNORE_DUPS      # skip consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # drop older duplicate entries
setopt HIST_FIND_NO_DUPS     # when searching, show each command once
setopt HIST_REDUCE_BLANKS    # trim extra whitespace before saving

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # ↑
bindkey "^[[B" down-line-or-beginning-search # ↓

# Plugins (path relative to this file so it works with or without OMZ, regardless of symlink layout)
ZSH_RC_DIR="${${(%):-%x}:A:h}"
[[ -f "$ZSH_RC_DIR/.config/zsh/.zsh-plugins/git/git.plugin.zsh" ]] && source "$ZSH_RC_DIR/.config/zsh/.zsh-plugins/git/git.plugin.zsh"
unset ZSH_RC_DIR

# wakatime project detection
ZSH_WAKATIME_PROJECT_DETECTION=true

# usr commands
PATH="/usr/local/bin:$PATH"

# homebrew
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

# npm
export DISABLE_OPENCOLLECTIVE=1
export ADBLOCK=1

# Initialize fnm (Fast Node Manager)
if command -v fnm 1>/dev/null 2>&1; then
    eval "$(fnm env --use-on-cd)"
fi
# Remind to use fnm instead of nvm
alias nvm='echo "🚀 Use fnm instead! Try: fnm install <version> or fnm use <version>"'

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Terraform
export PATH="$HOME/Projects/terravision:$PATH"

# GPG
export GPG_TTY=$(tty)

# postgresql tools
export PATH="$HOMEBREW_PREFIX/Cellar/postgresql@15/*/bin:$PATH"

# Initialize pyenv if available
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Created by `pipx` on 2025-03-22 21:46:06
export PATH="$PATH:/Users/dgrebb/.local/bin"

# Added by Windsurf
export PATH="/Users/dgrebb/.codeium/windsurf/bin:$PATH"

# n8n configuration
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# bun completions
[ -s "/Users/dgrebb/.bun/_bun" ] && source "/Users/dgrebb/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/dgrebb/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Shut down docker marketing garbage
export DOCKER_CLI_HINTS=0

# Starship initialization
eval "$(starship init zsh)"
