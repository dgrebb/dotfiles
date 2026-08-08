# SketchyBar themes

Set the active theme:

```bash
echo ember > ~/.config/sketchybar/themes/active
sketchybar --reload
```

| Theme | PR / branch | Vibe |
|---|---|---|
| `ember` | core restore (default) | Charcoal glass, warm orange alerts, notch-aware DevDeck |
| `wings` | style/wings | Catppuccin split-wings around the notch |
| `glass` | style/glass | Ultra-thin translucent minimal |
| `tokyo` | style/tokyo | Tokyo Night dense cockpit + workspace pills |
| `moss` | style/moss | Calm verdant Obsidian/notes focus |

Each theme directory needs:

1. `colors.sh` — palette + `THEME_*` bar geometry exports  
2. `items.sh` — which items to source and in what order
