# SketchyBar themes

Set the active theme:

```bash
echo ember > ~/.config/sketchybar/themes/active
sketchybar --reload
```

| Theme | Branch / PR | Vibe |
|---|---|---|
| `ember` | `slop/sketchybar-core-restore-697a` | Charcoal glass, warm orange alerts, notch-aware DevDeck (default) |
| `wings` | `slop/sketchybar-style-wings-697a` | Catppuccin Macchiato split-wings around the notch |
| `glass` | `slop/sketchybar-style-glass-697a` | Ultra-thin translucent minimal |
| `tokyo` | `slop/sketchybar-style-tokyo-697a` | Tokyo Night cockpit + Aerospace workspace pills |
| `moss` | `slop/sketchybar-style-moss-697a` | Calm verdant Obsidian/notes focus |
| `phosphor` | `slop/sketchybar-style-phosphor-697a` | CRT green-on-black terminal chrome |
| `signal` | `slop/sketchybar-style-signal-697a` | Meeting-day steel + live call pill |

Each theme directory needs:

1. `colors.sh` — palette + `THEME_*` bar geometry exports
2. `items.sh` — which items to source and in what order

Shared plugins (GitHub, ghmon, music, front_app icons) live outside `themes/` so every skin stays checkoutable once the core restore lands.
