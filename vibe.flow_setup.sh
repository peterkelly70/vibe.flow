#!/bin/bash
set -euo pipefail

# Vibe-Flow Installer Script
# Sets up .git-tools, installs vibe.* scripts, and configures git aliases

TOOLS_DIR=".git-tools"

mkdir -p "$TOOLS_DIR"

##############################################
# Install vibe_push.sh
##############################################
cat > "$TOOLS_DIR/vibe_push.sh" <<'EOF'
#!/bin/bash
set -euo pipefail

ITER_BRANCH="iterations"
MAIN_BRANCH="main"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "$ITER_BRANCH" ]]; then
  echo "\u274C You must be on the '$ITER_BRANCH' branch to run 'git vibe.push'."
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

echo "\uD83D\uDCE6 Applying snapshot from '$ITER_BRANCH' to '$MAIN_BRANCH'..."
git checkout "$MAIN_BRANCH"
git checkout "$ITER_BRANCH" -- .
git commit -am "$COMMIT_MSG"
git checkout "$ITER_BRANCH"

echo "\u2705 Snapshot pushed to '$MAIN_BRANCH':"
echo "   $COMMIT_MSG"
EOF
chmod +x "$TOOLS_DIR/vibe_push.sh"


##############################################
# Install vibe_pull.sh
##############################################
cat > "$TOOLS_DIR/vibe_pull.sh" <<'EOF'
#!/bin/bash
set -euo pipefail

DEST_BRANCH="iterations"
SRC_BRANCH="${1:-main}"

git checkout "$DEST_BRANCH" || { echo "\u274C Could not switch to branch '$DEST_BRANCH'"; exit 1; }

if ! git show-ref --verify --quiet "refs/heads/$SRC_BRANCH"; then
  echo "\u274C Source branch '$SRC_BRANCH' does not exist."
  exit 1
fi

echo "\uD83D\uDCE5 Pulling snapshot from '$SRC_BRANCH' into '$DEST_BRANCH'..."
git checkout "$SRC_BRANCH" -- .

echo "\u2705 Snapshot from '$SRC_BRANCH' applied to '$DEST_BRANCH'."
EOF
chmod +x "$TOOLS_DIR/vibe_pull.sh"


##############################################
# Install vibe_clean.sh
##############################################
cat > "$TOOLS_DIR/vibe_clean.sh" <<'EOF'
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
EOF
chmod +x "$TOOLS_DIR/vibe_clean.sh"


##############################################
# Install vibe_snapshot.sh
##############################################
cat > "$TOOLS_DIR/vibe_snapshot.sh" <<'EOF'
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
EOF
chmod +x "$TOOLS_DIR/vibe_snapshot.sh"


##############################################
# Git Aliases
##############################################
git config alias.vibe.push "!bash $TOOLS_DIR/vibe_push.sh"
git config alias.vibe.pull "!bash $TOOLS_DIR/vibe_pull.sh"
git config alias.vibe.clean "!bash $TOOLS_DIR/vibe_clean.sh"
git config alias.vibe.snapshot "!bash $TOOLS_DIR/vibe_snapshot.sh"

echo "\n\u2728 Vibe-Flow tools installed successfully. Use:\n"
echo "   git vibe.push     - snapshot iterations to main"
echo "   git vibe.pull [branch] - pull state into iterations"
echo "   git vibe.clean     - clean up iterations history"
echo "   git vibe.snapshot  - commit iterations state into main manually"
echo "\nHappy vibe coding! \uD83C\uDFB6"
