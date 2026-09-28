# SketchyBar setup

Stow the package, then install deps and reload.

```bash
cd ~/Projects/dotfiles
stow -R -t ~ sketchybar
```

## Required tools

```bash
brew install jq gh felixkratz/formulae/sketchybar
brew install --cask font-hack-nerd-font font-sketchybar-app-font
gh auth login   # notifications + workflow monitor
```

Optional (already used by this config when present):

- [Aerospace](https://nikitabobko.github.io/AeroSpace/) — workspace item
- Music.app — center now-playing
- iStat Menus — CPU/memory/weather aliases
- OmniFocus / Teams / RescueTime — office bracket

## Theme switcher

```bash
echo ember > ~/.config/sketchybar/themes/active   # default restored layout
# echo wings|glass|tokyo|moss > ~/.config/sketchybar/themes/active
sketchybar --reload
```

Each theme folder provides:

- `colors.sh` — palette + bar geometry (`THEME_NOTCH_WIDTH`, etc.)
- `items.sh` — left / center / right composition

## GitHub plugins

| Item | Script | Needs |
|---|---|---|
| `github.bell` | `plugins/github.sh` | `gh api notifications`, `jq` |
| `ghmon.status` | `plugins/ghmon.sh` | `gh run list`, `jq` |

`ghmon` is **bash + jq only** (no Python / python-dateutil). Override targets:

```bash
export SKETCHYBAR_GHMON_REPO="owner/repo"
export SKETCHYBAR_GHMON_WORKFLOW="12345678"   # workflow id
export SKETCHYBAR_GHMON_LIMIT=5
```

Put exports in `~/.config/machine.sh` or a small env file you source from `sketchybarrc`.

## Notch notes

Themes set `notch_width` (~200–240) and keep the middle free for music / breathing room.
Left = Aerospace + front app; right = calendar, GitHub, system utils.

## Reload / debug

```bash
brew services restart sketchybar
# or
sketchybar --reload

tail -f /opt/homebrew/var/log/sketchybar/sketchybar.out.log
tail -f /opt/homebrew/var/log/sketchybar/sketchybar.err.log
```
