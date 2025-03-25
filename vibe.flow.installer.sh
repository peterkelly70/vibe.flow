#!/bin/bash
set -euo pipefail

VERSION="1.1.2"
REPO="peterkelly70/vibe.flow"
INIT_SCRIPT_NAME="vibe.init"
DRYRUN=false
FORCE=false

# Platform detection
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  INSTALL_DIR="$HOME/bin"
  echo "🪟 Windows detected. Using Git Bash-compatible path: $INSTALL_DIR"
else
  INSTALL_DIR="${HOME}/bin"
fi

# Argument parsing
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRYRUN=true
      shift
      ;;
    --force|--upgrade)
      FORCE=true
      echo "♻️  Force mode enabled"
      shift
      ;;
    --version)
      echo "vibe.flow.installer.sh version $VERSION"
      exit 0
      ;;
    --check-latest)
      echo "🔍 Checking for updates..."
      LATEST_VERSION=$(curl -s --connect-timeout 3 "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K[^"]+' || echo "")
      if [[ -z "$LATEST_VERSION" ]]; then
        echo "⚠️  Couldn't check updates (offline?)"
      elif [[ "$LATEST_VERSION" != "$VERSION" ]]; then
        echo "🚀 Update available: $LATEST_VERSION (You have $VERSION)"
        echo "   Download: https://github.com/$REPO/releases/latest"
      else
        echo "✅ You're using the latest version ($VERSION)"
      fi
      exit 0
      ;;
    --windows)
      INSTALL_DIR="$HOME/bin"
      echo "🪟 Forcing Windows/Git Bash setup"
      shift
      ;;
    *)
      echo "Usage: $0 [--dry-run] [--force] [--version] [--check-latest] [--windows]"
      exit 1
      ;;
  esac
done

# Ensure installation directory
mkdir -p "$INSTALL_DIR"

# Locate or fetch vibe.init
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [[ ! -f "$SCRIPT_DIR/$INIT_SCRIPT_NAME" ]]; then
  echo "📥 Downloading $INIT_SCRIPT_NAME from GitHub..."
  if ! curl -sSf -o "$INSTALL_DIR/$INIT_SCRIPT_NAME.tmp" "https://raw.githubusercontent.com/$REPO/main/$INIT_SCRIPT_NAME"; then
    echo "❌ Download failed"
    echo "ℹ️  Manual download: https://github.com/$REPO/blob/main/$INIT_SCRIPT_NAME"
    exit 1
  fi
  mv "$INSTALL_DIR/$INIT_SCRIPT_NAME.tmp" "$INSTALL_DIR/$INIT_SCRIPT_NAME"
  echo "✅ Downloaded successfully"
elif [[ "$SCRIPT_DIR" != "$INSTALL_DIR" ]]; then
  cp "$SCRIPT_DIR/$INIT_SCRIPT_NAME" "$INSTALL_DIR/"
fi

# Set permissions
chmod +x "$INSTALL_DIR/$INIT_SCRIPT_NAME"

# Dry-run mode
if $DRYRUN; then
  echo "🧪 Dry run complete"
  echo " - Install path: $INSTALL_DIR/$INIT_SCRIPT_NAME"
  echo " - Source: $([[ -f "$SCRIPT_DIR/$INIT_SCRIPT_NAME" ]] && echo "Local" || echo "GitHub")"
  exit 0
fi

# PATH configuration
configure_path() {
  local shell_file
  case "$(basename "$SHELL")" in
    zsh)  shell_file="$HOME/.zshrc" ;;
    bash) shell_file="$HOME/.bashrc" ;;
    *)    shell_file="$HOME/.profile" ;;
  esac

  if ! grep -q "$INSTALL_DIR" "$shell_file" 2>/dev/null; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$shell_file"
    echo "🔧 Added to PATH in $shell_file"
    echo "⚠️  Restart terminal or run: source $shell_file"
  fi
}

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  configure_path
fi

echo "✨ Vibe-Flow $VERSION installed successfully"
echo "   Run 'vibe.init' in any Git repository to begin"
