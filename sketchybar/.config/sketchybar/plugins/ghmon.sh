#!/bin/bash

# Set a safer PATH that includes common locations
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Dynamically add Homebrew Python to PATH - try multiple possible locations
BREW_PREFIX=$(brew --prefix 2>/dev/null)
if [[ -n "$BREW_PREFIX" ]]; then
  # Try various possible Python paths in Homebrew
  if [[ -d "$BREW_PREFIX/opt/python/libexec/bin" ]]; then
    PATH="$BREW_PREFIX/opt/python/libexec/bin:$PATH"
  elif [[ -d "$BREW_PREFIX/opt/python@3/libexec/bin" ]]; then
    PATH="$BREW_PREFIX/opt/python@3/libexec/bin:$PATH"
  elif [[ -d "$BREW_PREFIX/bin" ]]; then
    PATH="$BREW_PREFIX/bin:$PATH"
  fi
fi

# Check if dateutil module is available, if not use a simpler date formatting approach
PYTHON_CMD=""
if python3 -c "import dateutil" 2>/dev/null; then
  PYTHON_CMD="python3"
elif python -c "import dateutil" 2>/dev/null; then
  PYTHON_CMD="python"
fi

# Monitor GitHub Workflow by ID
update() {
  # Settings
  source "$CONFIG_DIR/colors.sh"
  REPOSITORY="dgrebb/dgrebb.com" # The repository to monitor
  WORKFLOW_ID=67874244           # The workflow to monitor
  LIST_LIMIT=5                   # How many runs you want in the popup
  TIMEZONE="America/New_York"    # Replace with your desired timezone

  STATUS=$(gh run list --repo $REPOSITORY --workflow $WORKFLOW_ID --limit 1 --json status --jq '.[0].status')
  CONCLUSION=$(gh run list --repo $REPOSITORY --workflow $WORKFLOW_ID --limit 1 --json conclusion --jq '.[0].conclusion')
  LIST=$(gh run list --repo $REPOSITORY --workflow $WORKFLOW_ID --limit $LIST_LIMIT --json status,conclusion,startedAt,updatedAt,displayTitle,headBranch,url)

  # Nerd Font icons for icon/label states
  HOURGLASS_ICON=
  OCTOCAT_ICON=
  QUEUED_ICON=󱖒
  PROGRESS_ICON=󰔚
  ROCKET_ICON=󱓞
  SKULL_ICON=󰯆
  SUCCESS_ICON=✓
  CANCELLED_ICON=⚠
  FAILURE_ICON=󰜺

  # dark colors
  DARK_RED=0xff870000
  DARK_YELLOW=0xff606800

  # initial loading state
  ICON=$OCTOCAT_ICON
  COLOR=$BLUE
  LABEL=$HOURGLASS_ICON
  LCOLOR=$BLUE
  COUNTER=0

  # queued, in_progress, completed states
  case "${STATUS}" in
  "queued")
    COLOR=$WHITE
    LABEL=$QUEUED_ICON
    LCOLOR=$GREY
    BACKGROUND_1=$BLUE
    BACKGROUND_2=$GREY
    ;;
  "in_progress")
    COLOR=$WHITE
    LABEL=$ROCKET_ICON
    LCOLOR=$YELLOW
    BACKGROUND_1=$DARK_YELLOW
    BACKGROUND_2=$YELLOW
    ;;
  "waiting")
    COLOR=$RED
    LABEL=$SKULL_ICON
    LCOLOR=$WHITE
    BACKGROUND_1=$DARK_RED
    BACKGROUND_2=$RED
    ;;
  "completed")
    COLOR=$WHITE
    # Labels for completed state are set by `conclusion`, below
    ;;
  *)
    COLOR=$BLUE
    ;;
  esac

  # Workflow Conclusion State
  case "${CONCLUSION}" in
  "success")
    LCOLOR=$GREEN
    LABEL=$SUCCESS_ICON
    ;;
  "cancelled")
    LCOLOR=$GREY
    LABEL=$CANCELLED_ICON
    ;;
  "failure")
    LCOLOR=$RED
    LABEL=$FAILURE_ICON
    ;;
  esac

  args+=(--remove '/ghmon.run\.*/' --remove gh.spacer_bottom)
  while read -r url status conclusion start end branch title; do
    TITLE="$(echo "$title" | sed -e "s/^'//" -e "s/'$//")"
    URL="$(echo -e "${url}")"
    COUNTER=$((COUNTER + 1))
    RUN_ICON=$PROGRESS_ICON
    RUN_COLOR=$YELLOW

    # Format date based on Python availability
    if [[ -n "$PYTHON_CMD" ]]; then
      # Use Python with dateutil if available
      RUN_END_TIME=$(TZ="$TIMEZONE" $PYTHON_CMD -c "from dateutil import tz, parser; import sys; dt = parser.parse($end); local_dt = dt.astimezone(tz.tzlocal()); sys.stdout.write(local_dt.strftime('%y.%m.%d - %H:%M:%S'))")
    else
      # Fallback to a simpler date format using date command
      # Convert ISO 8601 date to timestamp, then format with date
      ISO_DATE=$(echo $end | tr -d "'")
      # Simple formatting with date (may not handle timezone properly)
      RUN_END_TIME=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$(echo $ISO_DATE | sed 's/\.[0-9]*Z$/Z/')" "+%y.%m.%d - %H:%M:%S" 2>/dev/null || echo "Date unavailable")
    fi

    case "${conclusion}" in
    "'success'")
      RUN_COLOR=$GREEN
      RUN_ICON=$SUCCESS_ICON
      ;;
    "'cancelled'")
      RUN_COLOR=$GREY
      RUN_ICON=$CANCELLED_ICON
      ;;
    "'failure'")
      RUN_COLOR=$RED
      RUN_ICON=$FAILURE_ICON
      ;;
    esac

    run=(
      label="$TITLE | $RUN_END_TIME"
      icon=$RUN_ICON
      icon.color="$RUN_COLOR"
      position=popup.ghmon.status
      drawing=on
      click_script="open $URL; sketchybar --set ghmon.status popup.drawing=off"
    )

    args+=(--clone ghmon.run.$COUNTER ghmon.template
      --set ghmon.run.$COUNTER "${run[@]}")

  done <<<"$(echo $LIST | jq -r '.[] | [.url, .status, .conclusion, .startedAt, .updatedAt, .headBranch, .displayTitle] | @sh')"

  args+=(--add item gh.spacer_bottom popup.ghmon.status
    --set gh.spacer_bottom "${gh_spacer[@]}" background.height=5)

  sketchybar -m "${args[@]}" >/dev/null

  sketchybar --set ghmon.status icon="$ICON" icon.color="$COLOR" label="$LABEL" label.color="$LCOLOR" \
    --set ghmon.status background.color=$BACKGROUND_1 background.border_color=$BACKGROUND_2
}

popup() {
  sketchybar --set $NAME popup.drawing=$1
}

case "$SENDER" in
"routine" | "forced")
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
