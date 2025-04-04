#!/bin/bash
set -euo pipefail

ITER_BRANCH="iterations"
MAIN_BRANCH="main"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "$ITER_BRANCH" ]]; then
  echo "🚫 You must be on the '$ITER_BRANCH' branch to run 'git vibe.snapshot'."
  echo "💡 Run: git checkout $ITER_BRANCH"
  exit 1
fi

if ! git diff-index --quiet HEAD --; then
  echo "🚫 Uncommitted changes in '$ITER_BRANCH'. Please commit or stash them first."
  exit 1
fi

ITER_HASH=$(git rev-parse --short HEAD)
USER_MSG=${1:-"manual snapshot"}
COMMIT_MSG="Snapshot: $ITER_HASH - $USER_MSG"

if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
  echo "🚫 Target branch '$MAIN_BRANCH' does not exist."
  exit 1
fi

echo "📦 Applying snapshot from '$ITER_BRANCH' to '$MAIN_BRANCH'..."
git checkout "$MAIN_BRANCH" || {
  echo "❌ Failed to checkout '$MAIN_BRANCH'."
  exit 1
}

git checkout "$ITER_BRANCH" -- .
git commit -am "$COMMIT_MSG"
git checkout "$ITER_BRANCH"

echo "✅ Snapshot committed to '$MAIN_BRANCH': $COMMIT_MSG"
