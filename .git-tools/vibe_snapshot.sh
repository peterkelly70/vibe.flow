#!/bin/bash
set -euo pipefail

ITER_BRANCH="iterations"
MAIN_BRANCH="main"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "$ITER_BRANCH" ]]; then
  echo "\u274C You must be on the '$ITER_BRANCH' branch to run 'git vibe.snapshot'."
  echo "\uD83D\uDCA1 Run: git checkout $ITER_BRANCH"
  exit 1
fi

if ! git diff-index --quiet HEAD --; then
  echo "\u274C Uncommitted changes in '$ITER_BRANCH'. Please commit or stash them first."
  exit 1
fi

ITER_HASH=$(git rev-parse --short HEAD)
USER_MSG=${1:-"Snapshot from $ITER_BRANCH"}
COMMIT_MSG="$ITER_HASH - $USER_MSG"

if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
  echo "\u274C Target branch '$MAIN_BRANCH' does not exist."
  exit 1
fi

echo "\uD83D\uDCE6 Creating snapshot from '$ITER_BRANCH' into '$MAIN_BRANCH' (but not checking it out)..."
git checkout "$MAIN_BRANCH"
git checkout "$ITER_BRANCH" -- .
git commit -am "$COMMIT_MSG"
git checkout "$ITER_BRANCH"

echo "\u2705 Snapshot committed to '$MAIN_BRANCH': $COMMIT_MSG"
