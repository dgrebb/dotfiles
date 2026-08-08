# SketchyBar

Notch-aware status bar configs with swappable themes.

After stowing (`stow -R -t ~ sketchybar`), the live config is:

```
~/.config/sketchybar/
```

## Docs (start here)

| Doc | What it covers |
|---|---|
| [`.config/sketchybar/docs/SETUP.md`](.config/sketchybar/docs/SETUP.md) | Brew deps, `gh auth`, reload / debug |
| [`.config/sketchybar/docs/APP_ICONS.md`](.config/sketchybar/docs/APP_ICONS.md) | sketchybar-app-font map (Cursor, Zen, Proton, Devin, …) |
| [`.config/sketchybar/themes/README.md`](.config/sketchybar/themes/README.md) | Theme catalog + how to switch |

## Quick start

```bash
stow -R -t ~ sketchybar
brew install jq gh felixkratz/formulae/sketchybar
brew install --cask font-hack-nerd-font font-sketchybar-app-font
gh auth login
brew services restart sketchybar
```

## Themes

```bash
echo ember > ~/.config/sketchybar/themes/active      # default DevDeck
# wings | glass | tokyo | moss | phosphor | signal
sketchybar --reload
```

| Theme | Notes |
|---|---|
| `ember` | Default charcoal / warm accent restore |
| `wings` | Catppuccin Macchiato, wide notch gap |
| `glass` | Thin translucent minimal |
| `tokyo` | Night Storm + Aerospace workspace pills |
| `moss` | Calm verdant writing focus |
| `phosphor` | CRT green-on-black |
| `signal` | Meeting-day steel + live call pill |

## Layout (ember default)

- **Left** — Aerospace workspace + front-app icon/name (`items/aerospace.sh`)
- **Center** — Music (hidden when idle)
- **Right** — Calendar · GitHub stack (`ghstack` bracket) · utils / office

Apple logo popup logic remains in `items/apple.sh` but is commented out of `sketchybarrc`.
