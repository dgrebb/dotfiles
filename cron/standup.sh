#!/bin/bash

# Check if gh CLI is installed
if ! command -v gh &>/dev/null; then
  echo "Error: GitHub CLI (gh) is not installed."
  echo "Install it with: brew install gh"
  exit 1
fi

# Check if gh is authenticated
if ! gh auth status &>/dev/null; then
  echo "Error: GitHub CLI is not authenticated."
  echo "Run: gh auth login"
  exit 1
fi

# Get yesterday's date in ISO format (YYYY-MM-DD)
if [[ $(uname) == "Darwin" ]]; then
  # macOS
  YESTERDAY=$(date -v-1d "+%Y-%m-%d")
else
  # Linux
  YESTERDAY=$(date -d "yesterday" "+%Y-%m-%d")
fi

# Get the authenticated user
USERNAME=$(gh api user -q .login)

if [ -z "$USERNAME" ]; then
  echo "Error: Could not determine GitHub username"
  exit 1
fi

echo "# Standup - Yesterday (${YESTERDAY})"
echo ""
echo "## What I worked on yesterday"
echo ""

# Use GitHub Search API to find commits by author and date
# URL encode the query
SEARCH_QUERY="author:${USERNAME} author-date:${YESTERDAY}"
ENCODED_QUERY=$(printf '%s' "$SEARCH_QUERY" | jq -sRr @uri)

# Get commits using search API
SEARCH_RESULTS=$(gh api "search/commits?q=${ENCODED_QUERY}&per_page=100" 2>/dev/null)

TOTAL_COUNT=$(echo "$SEARCH_RESULTS" | jq -r '.total_count // 0')

if [ -z "$SEARCH_RESULTS" ] || [ "$TOTAL_COUNT" = "0" ]; then
  echo "- No commits found for ${YESTERDAY}"
  echo ""
else
  # Group commits by repository and format output
  echo "$SEARCH_RESULTS" | jq -r '
    .items | 
    group_by(.repository.full_name) | 
    .[] | 
    "### \(.[0].repository.full_name) (\(length) commit\(if length != 1 then "s" else "" end))\n" + 
    (.[] | "- \(.commit.message | split("\n")[0])") + "\n"
  '
  
  echo "**Total commits:** ${TOTAL_COUNT}"
  echo ""
fi

# Get repository list summary
echo "## Repositories worked on"
if [ "$TOTAL_COUNT" != "0" ] && [ -n "$TOTAL_COUNT" ]; then
  echo "$SEARCH_RESULTS" | jq -r '.items[].repository.full_name' | sort -u | while read -r repo; do
    echo "- ${repo}"
  done
else
  echo "- No repository activity found"
fi
