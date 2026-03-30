#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Only one run at a time — if `pass` blocks on GPG, sketchybar still fires every
# update_freq and would otherwise spawn dozens of concurrent `pass` processes.
LOCK_DIR="${SKETCHYBAR_RW_DIR:-$HOME/.config/.sketchyrw}"
mkdir -p "$LOCK_DIR"
exec 9>"$LOCK_DIR/nightscout.lock"
flock -n 9 || exit 0

# Cache decrypted token on disk (600) so we don't invoke GPG/pass every 60s.
# Invalidate after rotation: rm this file. TTL: 1 hour.
CACHE_FILE="$LOCK_DIR/nightscout_glu_token"
CACHE_MAX_AGE_MIN=60

_run_pass() {
  if command -v timeout >/dev/null 2>&1; then
    timeout 5 pass dg/glu/api-key 2>/dev/null
  elif command -v gtimeout >/dev/null 2>&1; then
    gtimeout 5 pass dg/glu/api-key 2>/dev/null
  else
    pass dg/glu/api-key 2>/dev/null
  fi
}

if [[ -f "$CACHE_FILE" ]] && find "$CACHE_FILE" -mmin "-$CACHE_MAX_AGE_MIN" 2>/dev/null | grep -q .; then
  GLU_API_KEY=$(cat "$CACHE_FILE")
else
  GLU_API_KEY=$(_run_pass)
  [[ -z "$GLU_API_KEY" ]] && exit 0
  umask 077
  printf '%s' "$GLU_API_KEY" >"$CACHE_FILE"
fi

ICON_COLOR=$WHITE

data=$(
  curl -s -m 15 -X 'GET' \
    "https://glu.7ub3s.net/api/v1/entries/sgv?count=1&token=${GLU_API_KEY}" \
    -H 'accept: application/json'
)

BG=$(echo "$data" | jq -r '.[0].sgv // empty')
[[ -z "$BG" || "$BG" == "null" ]] && exit 0

if [[ $BG -gt "120" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -gt "160" ]]; then
  ICON_COLOR=$RED
elif [[ $BG -gt "300" ]]; then
  ICON_COLOR=$BLACK
elif [[ $BG -lt "100" ]]; then
  ICON_COLOR=$YELLOW
elif [[ $BG -lt "90" ]]; then
  ICON_COLOR=$RED
else
  ICON_COLOR=$GREEN
fi

sketchybar --set nightscout icon=$BG icon.color=$ICON_COLOR
