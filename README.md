# dotfiles

My personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for clean, organized configuration management.

## 🚀 Quick Start

### Prerequisites
- macOS (tested on macOS Sonoma)
- [Homebrew](https://brew.sh/) installed
- [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/dgrebb/dotfiles.git ~/Projects/dotfiles
   cd ~/Projects/dotfiles
   ```

2. **Run the setup script:**
   ```bash
   ./_setup.sh
   ```

3. **Install individual packages:**
   ```bash
   stow -t ~ zsh          # Shell configuration
   stow -t ~ git          # Git configuration
   stow -t ~ yabai        # Window management
   stow -t ~ sketchybar   # Status bar
   # ... add more as needed
   ```

3.1 ** Or Re`stow` packages after changes**
   ```bash
   stow -R -t ~ sketchybar   # -r (Restow); -t ~ (Target directory)
   ```

## 📦 Package Structure

Each package is organized to mirror the target filesystem structure:

```
dotfiles/
├── zsh/                    # Shell configuration
│   ├── .zshrc             # → ~/.zshrc
│   └── .zsh-plugins/      # Custom plugins
├── git/                    # Git configuration
│   ├── .gitconfig         # → ~/.gitconfig
│   └── .gitignore_global  # → ~/.gitignore_global
├── yabai/                  # Window management
│   └── .config/
│       └── yabai/         # → ~/.config/yabai/
├── sketchybar/             # Status bar
│   └── .config/
│       └── sketchybar/    # → ~/.config/sketchybar/
└── utils/                  # Shared utilities
    ├── .aliases           # → ~/.aliases
    └── .functions         # → ~/.functions
```

## 🛠️ Available Packages

### Core System
- **`zsh`** - Shell configuration with custom plugins and aliases
- **`git`** - Git configuration with helpful aliases and settings
- **`utils`** - Shared aliases and functions

### macOS Tools
- **`yabai`** - Window management and tiling
- **`sketchybar`** - Status bar replacement with swappable themes — see [`sketchybar/README.md`](sketchybar/README.md)
- **`spaceship`** - Shell prompt (Starship)
- **`ghostty`** - Terminal emulator configuration

### Development
- **`tmux`** - Terminal multiplexer
- **`wakatime`** - Time tracking
- **`commitizen`** - Git commit standardization

## 🔧 Usage

### Installing Packages
```bash
# Install a single package
stow -t ~ package-name

# Install multiple packages
stow -t ~ zsh git utils

# Install all packages (if you have a script)
./install-all.sh
```

### Removing Packages
```bash
# Remove a package (unlinks but keeps files)
stow -D -t ~ package-name

# Restow a package (remove + reinstall)
stow -R -t ~ package-name
```

### Managing ~/.config Directories
For packages that need to live in `~/.config`, use the `--no-folding` flag:
```bash
stow --no-folding -t ~ yabai
```

## 🎯 Key Features

### Shell Configuration
- **Custom git plugin** - Enhanced git aliases and functions
- **Flexible aliases** - `lsa` function that works with paths
- **Starship prompt** - Fast, customizable shell prompt
- **fnm integration** - Fast Node.js version management

### Git Workflow
- **Helpful aliases** - `g`, `gco`, `gp`, `gl`, etc.
- **Branch management** - `gbclean`, `gbcs` for cleanup
- **PR automation** - `openpr` and `gopr` functions
- **GPG signing** - Automatic commit signing

### Development Tools
- **Homebrew management** - `Brewfile` for reproducible setup
- **Node.js tools** - fnm, pnpm, npm configurations
- **Python tools** - pyenv integration
- **Terraform** - Custom terravision path

## 🔄 Maintenance

### Adding New Packages
1. Create a new directory in the root
2. Mirror the target filesystem structure
3. Add to this README
4. Test with `stow --simulate -t ~ package-name`

### Updating Existing Packages
```bash
# Update from remote
git pull origin main

# Restow affected packages
stow -R -t ~ updated-package
```

### Backup Before Changes
```bash
# Create backup of current configs
mkdir ~/.config-backup
cp -r ~/.config/* ~/.config-backup/
```

## 📝 Files

### Brewfile
[Homebrew](https://brew.sh/) package management. Generate with `brew bundle dump` and install with `brew bundle install`.

Big shoutout to @cliss for covering this in an [excellent post on caseyliss.com](https://www.caseyliss.com/2019/10/8/brew-bundle).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `stow --simulate`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [GNU Stow](https://www.gnu.org/software/stow/) for elegant symlink management
- [Oh My Zsh](https://ohmyz.sh/) for the git plugin inspiration
- [Starship](https://starship.rs/) for the fast shell prompt
- [Homebrew](https://brew.sh/) for macOS package management
