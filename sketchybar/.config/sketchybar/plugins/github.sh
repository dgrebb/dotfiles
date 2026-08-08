#!/usr/bin/env bash
# GitHub notification bell — requires `gh auth login` and `jq`.

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

update() {
  source "$CONFIG_DIR/colors.sh"
  source "$CONFIG_DIR/icons.sh"

  if ! command -v gh >/dev/null 2>&1; then
    sketchybar --set "$NAME" drawing=on icon="$BELL" label="?" icon.color="$GREY"
    return
  fi

  local NOTIFICATIONS COUNT
  NOTIFICATIONS="$(gh api notifications 2>/dev/null || echo '[]')"
  if ! printf '%s' "$NOTIFICATIONS" | jq -e . >/dev/null 2>&1; then
    NOTIFICATIONS='[]'
  fi
  COUNT="$(printf '%s' "$NOTIFICATIONS" | jq 'length')"

  local args=()
  if [[ "$COUNT" -eq 0 ]]; then
    args+=(--set "$NAME" drawing=on icon="$BELL" label="0")
  else
    args+=(--set "$NAME" drawing=on icon="$BELL_DOT" label="$COUNT")
  fi

  local PREV_COUNT
  PREV_COUNT="$(sketchybar --query github.bell 2>/dev/null | jq -r '.label.value // 0')"

  args+=(--remove '/github.notification\.*/')

  local COUNTER=0
  local COLOR=$BLUE
  args+=(--set github.bell icon.color="$COLOR")

  while IFS=$'\t' read -r repo url type title; do
    COUNTER=$((COUNTER + 1))
    local IMPORTANT COLOR_ITEM ICON PADDING
    IMPORTANT="$(printf '%s' "$title" | grep -Ei '(deprecat|break|broke)' || true)"
    COLOR_ITEM=$BLUE
    PADDING=0
    ICON="$GIT_COMMIT"
    local LINK="https://github.com/notifications"

    if [[ -z "$repo" && -z "$title" ]]; then
      repo="Note"
      title="No new notifications"
    fi

    case "$type" in
    Issue)
      COLOR_ITEM=$GREEN
      ICON=$GIT_ISSUE
      if [[ -n "$url" && "$url" != "null" ]]; then
        LINK="$(gh api "$url" --jq .html_url 2>/dev/null || echo "$LINK")"
      fi
      ;;
    Discussion)
      COLOR_ITEM=$WHITE
      ICON=$GIT_DISCUSSION
      ;;
    PullRequest)
      COLOR_ITEM=$MAGENTA
      ICON=$GIT_PULL_REQUEST
      if [[ -n "$url" && "$url" != "null" ]]; then
        LINK="$(gh api "$url" --jq .html_url 2>/dev/null || echo "$LINK")"
      fi
      ;;
    Commit)
      COLOR_ITEM=$WHITE
      ICON=$GIT_COMMIT
      if [[ -n "$url" && "$url" != "null" ]]; then
        LINK="$(gh api "$url" --jq .html_url 2>/dev/null || echo "$LINK")"
      fi
      ;;
    esac

    if [[ -n "$IMPORTANT" ]]; then
      COLOR_ITEM=$RED
      ICON=$GIT_ALERT
      args+=(--set github.bell icon.color="$COLOR_ITEM")
    fi

    local notification=(
      label="$title"
      icon="$ICON ${repo}:"
      icon.padding_left="$PADDING"
      label.padding_right="$PADDING"
      icon.color="$COLOR_ITEM"
      position=popup.github.bell
      icon.background.color="$COLOR_ITEM"
      drawing=on
      click_script="open \"$LINK\"; sketchybar --set github.bell popup.drawing=off; sleep 5; sketchybar --trigger github.update"
    )

    args+=(--clone "github.notification.$COUNTER" github.template
      --set "github.notification.$COUNTER" "${notification[@]}")
  done < <(printf '%s' "$NOTIFICATIONS" | jq -r '.[] | [.repository.name, (.subject.latest_comment_url // .subject.url // ""), .subject.type, .subject.title] | @tsv')

  # Empty-state row so the popup isn't blank
  if [[ "$COUNT" -eq 0 ]]; then
    args+=(--clone github.notification.0 github.template
      --set github.notification.0 \
      label="You're all caught up" \
      icon="$BELL Clear:" \
      icon.color="$BLUE" \
      position=popup.github.bell \
      drawing=on \
      click_script="open https://github.com/notifications; sketchybar --set github.bell popup.drawing=off")
  fi

  sketchybar -m "${args[@]}" >/dev/null

  if { [[ "$COUNT" -gt "$PREV_COUNT" ]] 2>/dev/null; } || [[ "$SENDER" == "forced" ]]; then
    sketchybar --animate tanh 15 --set github.bell label.y_offset=5 label.y_offset=0
  fi
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced" | "github.update")
  update
  ;;
"system_woke")
  sleep 10 && update
  ;;
"mouse.entered")
  popup on
  ;;
"mouse.exited" | "mouse.exited.global")
  popup off
  ;;
"mouse.clicked")
  popup toggle
  ;;
esac
