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

# Get yesterday's and today's dates in ISO format (YYYY-MM-DD)
if [[ $(uname) == "Darwin" ]]; then
  # macOS
  YESTERDAY=$(date -v-1d "+%Y-%m-%d")
  TODAY=$(date "+%Y-%m-%d")
else
  # Linux
  YESTERDAY=$(date -d "yesterday" "+%Y-%m-%d")
  TODAY=$(date "+%Y-%m-%d")
fi

# Get the authenticated user
USERNAME=$(gh api user -q .login)

if [ -z "$USERNAME" ]; then
  echo "Error: Could not determine GitHub username"
  exit 1
fi

echo "# Standup - Since Yesterday (${YESTERDAY} through ${TODAY})"
echo ""
echo "## What I worked on"
echo ""

# Use GitHub Search API to find commits by author and date range (from yesterday onwards)
SEARCH_QUERY="author:${USERNAME} author-date:>=${YESTERDAY}"
ENCODED_QUERY=$(printf '%s' "$SEARCH_QUERY" | jq -sRr @uri)

# Get commits using search API
COMMIT_RESULTS=$(gh api "search/commits?q=${ENCODED_QUERY}&per_page=100" 2>/dev/null)
COMMIT_COUNT=$(echo "$COMMIT_RESULTS" | jq -r '.total_count // 0')

if [ -n "$COMMIT_RESULTS" ] && [ "$COMMIT_COUNT" != "0" ]; then
  echo "### Commits"
  # Group commits by repository and format output
  echo "$COMMIT_RESULTS" | jq -r '
    .items | 
    group_by(.repository.full_name) | 
    .[] | 
    "#### \(.[0].repository.full_name) (\(length) commit\(if length != 1 then "s" else "" end))\n" +
    (map("- \(.commit.message | split("\n")[0])") | join("\n")) + "\n"
  '
  echo "**Total commits:** ${COMMIT_COUNT}"
  echo ""
fi

# Get all user events in a single API call (more efficient)
USER_EVENTS=$(gh api "users/${USERNAME}/events/public?per_page=100" 2>/dev/null)

# Get Pull Request Reviews (actual review submissions)
PR_REVIEWS=$(echo "$USER_EVENTS" | jq -r --arg yesterday "$YESTERDAY" --arg today "$TODAY" '
  .[] | 
  select(.type == "PullRequestReviewEvent" and ((.created_at | startswith($yesterday)) or (.created_at | startswith($today)))) |
  "\(.repo.name)|\(.payload.pull_request.title)|\(.payload.pull_request.html_url)|\(.payload.review.state)|\(.payload.review.body // "" | split("\n")[0])"
')

if [ -n "$PR_REVIEWS" ]; then
  PR_REVIEW_COUNT=$(echo "$PR_REVIEWS" | wc -l | tr -d ' ')
  if [ "$PR_REVIEW_COUNT" -gt 0 ]; then
    echo "### Pull Request Reviews"
    echo "$PR_REVIEWS" | while IFS='|' read -r repo title url state body; do
      if [ -n "$repo" ] && [ "$repo" != "null" ]; then
        STATE_EMOJI=""
        case "$state" in
          "APPROVED") STATE_EMOJI="✅" ;;
          "CHANGES_REQUESTED") STATE_EMOJI="🔄" ;;
          "COMMENTED") STATE_EMOJI="💬" ;;
          *) STATE_EMOJI="📝" ;;
        esac
        echo "- ${STATE_EMOJI} ${state} [${title}](${url}) in ${repo}"
        if [ -n "$body" ] && [ "$body" != "null" ] && [ "$body" != "" ]; then
          echo "  > ${body}"
        fi
      fi
    done
    echo ""
    echo "**Total PR reviews:** ${PR_REVIEW_COUNT}"
    echo ""
  fi
fi

# Get Pull Request Comments (comments on PRs)
PR_COMMENTS=$(echo "$USER_EVENTS" | jq -r --arg yesterday "$YESTERDAY" --arg today "$TODAY" '
  .[] | 
  select(.type == "IssueCommentEvent" and ((.created_at | startswith($yesterday)) or (.created_at | startswith($today))) and (.payload.issue.pull_request != null)) |
  "\(.repo.name)|\(.payload.issue.title)|\(.payload.issue.html_url)|\(.payload.comment.body | split("\n")[0])"
')

if [ -n "$PR_COMMENTS" ]; then
  PR_COMMENT_COUNT=$(echo "$PR_COMMENTS" | wc -l | tr -d ' ')
  if [ "$PR_COMMENT_COUNT" -gt 0 ]; then
    echo "### Pull Request Comments"
    echo "$PR_COMMENTS" | while IFS='|' read -r repo title url comment; do
      if [ -n "$repo" ] && [ "$repo" != "null" ]; then
        echo "- Commented on [${title}](${url}) in ${repo}"
        echo "  > ${comment}"
      fi
    done
    echo ""
    echo "**Total PR comments:** ${PR_COMMENT_COUNT}"
    echo ""
  fi
fi

# Get Issue Comments and Activity
ISSUE_COMMENTS=$(echo "$USER_EVENTS" | jq -r --arg yesterday "$YESTERDAY" --arg today "$TODAY" '
  .[] | 
  select(.type == "IssueCommentEvent" and ((.created_at | startswith($yesterday)) or (.created_at | startswith($today))) and (.payload.issue.pull_request == null)) |
  "\(.repo.name)|\(.payload.issue.title)|\(.payload.issue.html_url)|\(.payload.comment.body | split("\n")[0])"
')

if [ -n "$ISSUE_COMMENTS" ]; then
  ISSUE_COMMENT_COUNT=$(echo "$ISSUE_COMMENTS" | wc -l | tr -d ' ')
  if [ "$ISSUE_COMMENT_COUNT" -gt 0 ]; then
    echo "### Issue Comments"
    echo "$ISSUE_COMMENTS" | while IFS='|' read -r repo title url comment; do
      if [ -n "$repo" ] && [ "$repo" != "null" ]; then
        echo "- Commented on [${title}](${url}) in ${repo}"
        echo "  > ${comment}"
      fi
    done
    echo ""
    echo "**Total issue comments:** ${ISSUE_COMMENT_COUNT}"
    echo ""
  fi
fi

# Get Pull Request Activity (opened, closed, etc.)
PR_ACTIVITY=$(echo "$USER_EVENTS" | jq -r --arg yesterday "$YESTERDAY" --arg today "$TODAY" '
  .[] | 
  select((.type == "PullRequestEvent") and ((.created_at | startswith($yesterday)) or (.created_at | startswith($today)))) |
  "\(.repo.name)|\(.payload.pull_request.title)|\(.payload.pull_request.html_url)|\(.payload.action)"
')

if [ -n "$PR_ACTIVITY" ]; then
  PR_ACTIVITY_COUNT=$(echo "$PR_ACTIVITY" | wc -l | tr -d ' ')
  if [ "$PR_ACTIVITY_COUNT" -gt 0 ]; then
    echo "### Pull Request Activity"
    echo "$PR_ACTIVITY" | while IFS='|' read -r repo title url action; do
      if [ -n "$repo" ] && [ "$repo" != "null" ]; then
        ACTION_PAST=$(echo "$action" | sed 's/opened/opened/;s/closed/closed/;s/reopened/reopened/;s/edited/edited/')
        echo "- ${ACTION_PAST} [${title}](${url}) in ${repo}"
      fi
    done
    echo ""
    echo "**Total PR actions:** ${PR_ACTIVITY_COUNT}"
    echo ""
  fi
fi

# Get other issue activity (opened, closed, etc.)
ISSUE_ACTIVITY=$(echo "$USER_EVENTS" | jq -r --arg yesterday "$YESTERDAY" --arg today "$TODAY" '
  .[] | 
  select((.type == "IssuesEvent") and ((.created_at | startswith($yesterday)) or (.created_at | startswith($today)))) |
  "\(.repo.name)|\(.payload.issue.title)|\(.payload.issue.html_url)|\(.payload.action)"
')

if [ -n "$ISSUE_ACTIVITY" ]; then
  ISSUE_ACTIVITY_COUNT=$(echo "$ISSUE_ACTIVITY" | wc -l | tr -d ' ')
  if [ "$ISSUE_ACTIVITY_COUNT" -gt 0 ]; then
    echo "### Issue Activity"
    echo "$ISSUE_ACTIVITY" | while IFS='|' read -r repo title url action; do
      if [ -n "$repo" ] && [ "$repo" != "null" ]; then
        ACTION_PAST=$(echo "$action" | sed 's/opened/opened/;s/closed/closed/;s/reopened/reopened/')
        echo "- ${ACTION_PAST} [${title}](${url}) in ${repo}"
      fi
    done
    echo ""
    echo "**Total issue actions:** ${ISSUE_ACTIVITY_COUNT}"
    echo ""
  fi
fi

# Summary: Get all repositories worked on
echo "## Repositories worked on"
ALL_REPOS=""

# Add repos from commits
if [ "$COMMIT_COUNT" != "0" ] && [ -n "$COMMIT_RESULTS" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$COMMIT_RESULTS" | jq -r '.items[].repository.full_name' | sort -u)"$'\n'
fi

# Add repos from PR reviews
if [ -n "$PR_REVIEWS" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$PR_REVIEWS" | cut -d'|' -f1 | sort -u)"$'\n'
fi

# Add repos from PR comments
if [ -n "$PR_COMMENTS" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$PR_COMMENTS" | cut -d'|' -f1 | sort -u)"$'\n'
fi

# Add repos from PR activity
if [ -n "$PR_ACTIVITY" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$PR_ACTIVITY" | cut -d'|' -f1 | sort -u)"$'\n'
fi

# Add repos from issue comments
if [ -n "$ISSUE_COMMENTS" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$ISSUE_COMMENTS" | cut -d'|' -f1 | sort -u)"$'\n'
fi

# Add repos from issue activity
if [ -n "$ISSUE_ACTIVITY" ]; then
  ALL_REPOS="${ALL_REPOS}$(echo "$ISSUE_ACTIVITY" | cut -d'|' -f1 | sort -u)"$'\n'
fi

# Output unique repos
UNIQUE_REPOS=$(echo "$ALL_REPOS" | grep -v '^$' | sort -u)

if [ -n "$UNIQUE_REPOS" ]; then
  echo "$UNIQUE_REPOS" | while read -r repo; do
    if [ -n "$repo" ]; then
      echo "- ${repo}"
    fi
  done
else
  echo "- No repository activity found"
fi
