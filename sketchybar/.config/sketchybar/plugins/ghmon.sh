#!/usr/bin/env bash
# Monitor a GitHub Actions workflow — portable bash + gh + jq (no Python).
#
# Requires: gh (authenticated), jq, date (BSD on macOS / GNU elsewhere)
# Configure REPOSITORY / WORKFLOW_ID below or via env:
#   SKETCHYBAR_GHMON_REPO, SKETCHYBAR_GHMON_WORKFLOW

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Format an ISO-8601 UTC timestamp from `gh` into a short local stamp.
# Prefers macOS `date -j`, falls back to GNU `date -d`.
format_run_time() {
  local iso="$1"
  iso="${iso//\'/}"
  iso="${iso%%.*}Z"
  iso="${iso//Z/}Z"
  # Normalize: 2024-01-02T03:04:05Z
  iso="$(printf '%s' "$iso" | sed -E 's/([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}).*/\1Z/')"

  if date -j -f "%Y-%m-%dT%H:%M:%SZ" "$iso" "+%y.%m.%d · %H:%M" 2>/dev/null; then
    return 0
  fi
  if date -u -d "$iso" "+%y.%m.%d · %H:%M" 2>/dev/null; then
    return 0
  fi
  printf '%s' "${iso:0:16}"
}

update() {
  source "$CONFIG_DIR/colors.sh"

  local REPOSITORY="${SKETCHYBAR_GHMON_REPO:-dgrebb/dgrebb.com}"
  local WORKFLOW_ID="${SKETCHYBAR_GHMON_WORKFLOW:-67874244}"
  local LIST_LIMIT="${SKETCHYBAR_GHMON_LIMIT:-5}"

  if ! command -v gh >/dev/null 2>&1; then
    sketchybar --set ghmon.status icon="" label="?" label.color="$GREY"
    return
  fi

  local LIST
  LIST="$(gh run list --repo "$REPOSITORY" --workflow "$WORKFLOW_ID" --limit "$LIST_LIMIT" \
    --json status,conclusion,updatedAt,displayTitle,url 2>/dev/null)" || LIST="[]"

  if [[ -z "$LIST" || "$LIST" == "null" ]]; then
    LIST="[]"
  fi

  local STATUS CONCLUSION
  STATUS="$(printf '%s' "$LIST" | jq -r '.[0].status // empty')"
  CONCLUSION="$(printf '%s' "$LIST" | jq -r '.[0].conclusion // empty')"

  local HOURGLASS_ICON=
  local OCTOCAT_ICON=
  local QUEUED_ICON=󱖒
  local ROCKET_ICON=󱓞
  local SKULL_ICON=󰯆
  local SUCCESS_ICON=✓
  local CANCELLED_ICON=⚠
  local FAILURE_ICON=󰜺

  local ICON=$OCTOCAT_ICON
  local COLOR=$BLUE
  local LABEL=$HOURGLASS_ICON
  local LCOLOR=$BLUE
  local BG1=$BACKGROUND_1
  local BG2=$BACKGROUND_2

  case "$STATUS" in
  queued)
    COLOR=$WHITE
    LABEL=$QUEUED_ICON
    LCOLOR=$GREY
    BG1=$BLUE
    BG2=$GREY
    ;;
  in_progress)
    COLOR=$WHITE
    LABEL=$ROCKET_ICON
    LCOLOR=$YELLOW
    BG1=$DARK_YELLOW
    BG2=$YELLOW
    ;;
  waiting)
    COLOR=$RED
    LABEL=$SKULL_ICON
    LCOLOR=$WHITE
    BG1=$DARK_RED
    BG2=$RED
    ;;
  completed) COLOR=$WHITE ;;
  *) COLOR=$BLUE ;;
  esac

  case "$CONCLUSION" in
  success)
    LCOLOR=$GREEN
    LABEL=$SUCCESS_ICON
    ;;
  cancelled)
    LCOLOR=$GREY
    LABEL=$CANCELLED_ICON
    ;;
  failure)
    LCOLOR=$RED
    LABEL=$FAILURE_ICON
    ;;
  esac

  local args=(--remove '/ghmon.run\.*/' --remove gh.spacer_bottom)
  local COUNTER=0

  while IFS=$'\t' read -r url conclusion updated title; do
    [[ -z "$title" ]] && continue
    COUNTER=$((COUNTER + 1))

    local RUN_ICON=$ROCKET_ICON
    local RUN_COLOR=$YELLOW
    case "$conclusion" in
    success)
      RUN_COLOR=$GREEN
      RUN_ICON=$SUCCESS_ICON
      ;;
    cancelled)
      RUN_COLOR=$GREY
      RUN_ICON=$CANCELLED_ICON
      ;;
    failure)
      RUN_COLOR=$RED
      RUN_ICON=$FAILURE_ICON
      ;;
    esac

    local RUN_END_TIME
    RUN_END_TIME="$(format_run_time "$updated")"

    local run=(
      label="$title | $RUN_END_TIME"
      icon="$RUN_ICON"
      icon.color="$RUN_COLOR"
      position=popup.ghmon.status
      drawing=on
      click_script="open \"$url\"; sketchybar --set ghmon.status popup.drawing=off"
    )

    args+=(--clone "ghmon.run.$COUNTER" ghmon.template
      --set "ghmon.run.$COUNTER" "${run[@]}")
  done < <(printf '%s' "$LIST" | jq -r '.[] | [.url, (.conclusion // ""), .updatedAt, .displayTitle] | @tsv')

  args+=(--add item gh.spacer_bottom popup.ghmon.status
    --set gh.spacer_bottom icon.drawing=off label.drawing=off background.drawing=off background.height=5 width=10)

  sketchybar -m "${args[@]}" >/dev/null

  sketchybar --set ghmon.status \
    icon="$ICON" icon.color="$COLOR" \
    label="$LABEL" label.color="$LCOLOR" \
    background.color="$BG1" background.border_color="$BG2"
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced" | "")
  update
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
