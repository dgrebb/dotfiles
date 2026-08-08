# SketchyBar app icons

Icons next to the frontmost app name come from
[`kvndrsslr/sketchybar-app-font`](https://github.com/kvndrsslr/sketchybar-app-font)
(Homebrew: `brew install --cask font-sketchybar-app-font`).

`plugins/icon_map.sh` is the upstream mapping script (v2.0.71 at time of update).
`plugins/front_app.sh` sources it and sets:

| Focus state | Icon source | Glyph |
|---|---|---|
| Finder / empty | Hack Nerd Font (SF Symbol) | Apple (`APPLE` in `icons.sh`) |
| Known app | `sketchybar-app-font` ligature | e.g. `:cursor:` |
| Unknown app | `sketchybar-app-font` | `:default:` |

## Icons we rely on (daily driver)

| App | Mapping key(s) | Ligature |
|---|---|---|
| ChatGPT | `ChatGPT`, `ChatGPT Classic` | `:openai:` |
| ChatGPT Atlas | `ChatGPT Atlas` | `:chatgpt_atlas:` |
| Zen Browser | `Zen`, `Zen Browser`, `Twilight` | `:zen_browser:` |
| Proton Mail | `Proton Mail`, `Proton Mail Bridge` | `:proton_mail:` |
| Proton VPN | `Proton VPN`, `ProtonVPN` | `:proton_vpn:` |
| Devin | `Devin` | `:devin:` |
| Cursor | `Cursor` | `:cursor:` |
| OpenChamber | `OpenChamber` | `:openchamber:` |
| OpenCode | `opencode`, `OpenCode` | `:opencode:` |
| Bruno | `Bruno` | `:bruno:` |
| Claude | `Claude` | `:claude:` |
| Obsidian | `Obsidian` | `:obsidian:` |
| Slack | `Slack` | `:slack:` |
| Microsoft Teams | `Microsoft Teams`, `Microsoft Teams (work or school)` | `:microsoft_teams:` |
| iTerm2 | `iTerm`, `iTerm2` | `:iterm:` |
| Ghostty | `Ghostty` | `:ghostty:` |
| Warp | `Warp` | `:warp:` |
| Raycast | `Raycast`, `Raycast Beta` | `:raycast:` |
| GitHub Desktop | *(not in latest map — falls back to `:default:`)* | — |
| Safari / Chrome / Arc / Firefox | present | `:safari:` / `:google_chrome:` / `:arc:` / `:firefox:` |
| VS Code | `Code`, `Code - Insiders` | `:code:` |
| Finder | `Finder` | overridden → Apple glyph |

## Refreshing the map

```bash
curl -sL https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/icon_map.sh \
  -o ~/.config/sketchybar/plugins/icon_map.sh
chmod +x ~/.config/sketchybar/plugins/icon_map.sh
sketchybar --reload
```

If a new app shows `:default:`, either update the font/map or add a case under
`### START-OF-ICON-MAP` in `plugins/icon_map.sh` (and ideally upstream a PR to
sketchybar-app-font).
