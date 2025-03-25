#!/bin/bash
set -euo pipefail

BRANCH="iterations"

git checkout "$BRANCH"
if ! git diff-index --quiet HEAD --; then
  echo "\u274C Uncommitted changes in '$BRANCH'. Please commit or stash them before cleaning."
  exit 1
fi

timestamp=$(date +%Y%m%d-%H%M)
backup_branch="$BRANCH-backup-$timestamp"
git branch "$backup_branch"
echo "\uD83D\uDEE1️ Backup created as '$backup_branch'"

echo "\uD83D\uDCC9 Starting interactive root rebase of '$BRANCH'..."
git rebase -i --root || {
  echo "\u274C Rebase failed. You can restore from '$backup_branch'."
  exit 1
}

echo "\u2705 '$BRANCH' cleaned. Backup: $backup_branch"
