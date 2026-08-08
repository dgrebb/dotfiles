# SketchyBar themes

Switch skins without touching plugins:

```bash
echo ember > ~/.config/sketchybar/themes/active
sketchybar --reload
```

| Theme | Vibe |
|---|---|
| `ember` | Charcoal glass, warm orange alerts, notch-aware DevDeck (**default**) |
| `wings` | Catppuccin Macchiato split-wings around the notch |
| `glass` | Ultra-thin translucent minimal |
| `tokyo` | Tokyo Night cockpit + Aerospace workspace pills |
| `moss` | Calm verdant Obsidian / notes focus |
| `phosphor` | CRT green-on-black terminal chrome |
| `signal` | Meeting-day steel + live call pill |

Each theme directory provides:

1. `colors.sh` — palette + `THEME_*` bar geometry (`notch_width`, blur, height, …)
2. `items.sh` — left / center / right composition

Shared plugins (GitHub, ghmon, music, front_app icons, meeting) live outside `themes/` so every skin reuses the same restored stack. GitHub bell + Actions share the `ghstack` bracket from `items/group.github.sh`.

See also:

- [`../docs/SETUP.md`](../docs/SETUP.md)
- [`../docs/APP_ICONS.md`](../docs/APP_ICONS.md)
- [`../../../README.md`](../../../README.md) (package overview)
