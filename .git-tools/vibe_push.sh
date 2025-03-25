#!/bin/bash
set -euo pipefail

ITER_BRANCH="iterations"
MAIN_BRANCH="main"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "$ITER_BRANCH" ]]; then
  echo "❌ You must be on the '$ITER_BRANCH' branch to run 'git vibe.push'."
  echo "💡 Run: git checkout $ITER_BRANCH"
  exit 1
fi

# Determine user message and --origin flag
USER_MSG="Snapshot from $ITER_BRANCH"
AUTO_PUSH=false

for arg in "$@"; do
  if [[ "$arg" == --origin ]]; then
    AUTO_PUSH=true
  else
    USER_MSG="$arg"
  fi
done

# Stage and commit uncommitted changes if present
if ! git diff-index --quiet HEAD --; then
  echo "📝 Uncommitted changes detected. Staging and committing automatically..."
  git add .
  ITER_HASH=$(git rev-parse --short HEAD)
  COMMIT_MSG="$ITER_HASH - $USER_MSG"
  git commit -m "$COMMIT_MSG"
  echo "✅ Changes committed in '$ITER_BRANCH': $COMMIT_MSG"
else
  ITER_HASH=$(git rev-parse --short HEAD)
  COMMIT_MSG="$ITER_HASH - $USER_MSG"
fi

if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
  echo "❌ Target branch '$MAIN_BRANCH' does not exist."
  exit 1
fi

echo "📦 Applying snapshot from '$ITER_BRANCH' to '$MAIN_BRANCH'..."
git checkout "$MAIN_BRANCH"
git checkout "$ITER_BRANCH" -- .
git commit -am "$COMMIT_MSG"
git checkout "$ITER_BRANCH"

echo "✅ Snapshot pushed to '$MAIN_BRANCH':"
echo "   $COMMIT_MSG"

if $AUTO_PUSH; then
  echo "🚀 Pushing '$MAIN_BRANCH' to 'origin/$MAIN_BRANCH'..."
  git push origin "$MAIN_BRANCH"
  echo "✅ Remote updated: origin/$MAIN_BRANCH is now up to date."
fi
