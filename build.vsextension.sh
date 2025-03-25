#!/bin/bash
set -euo pipefail

# Script to create a Vibe-Flow VS Code extension, working around filesystem quirks
# Run this in your repo directory (/media/thoth/Halfnium/Projects/vibe.flow)

EXTENSION_NAME="vibe-flow"
EXTENSION_DISPLAY_NAME="Vibe-Flow"
EXTENSION_ID="peterkelly70.vibe-flow"
EXTENSION_DESC="Git workflow for vibe coding with AI"
VERSION="1.0.0"
PUBLISHER="peterkelly70"
NODE_VERSION="18"

echo "🚀 Setting up Vibe-Flow VS Code extension in $PWD..."

# Check and install Node.js if missing
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "📦 Node.js not found. Installing Node.js v$NODE_VERSION..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y curl
      curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
      sudo apt-get install -y nodejs
    else
      echo "❌ Unsupported Linux distro (apt-get not found). Install Node.js manually: https://nodejs.org/"
      exit 1
    fi
  else
    echo "❌ Unsupported OS for auto-install: $OSTYPE. Install Node.js manually: https://nodejs.org/"
    exit 1
  fi
  if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    echo "❌ Node.js installation failed. Install manually: https://nodejs.org/"
    exit 1
  fi
  echo "✅ Node.js installed successfully!"
else
  echo "✅ Node.js and npm already installed."
fi

# Set npm cache to avoid filesystem issues
echo "🔧 Configuring npm cache..."
npm config set cache /root/.npm-cache --verbose

# Create extension directory
if [[ ! -d "$EXTENSION_NAME" ]]; then
  echo "🛠️ Creating extension directory..."
  mkdir "$EXTENSION_NAME" || { echo "❌ Failed to create $EXTENSION_NAME dir. Check permissions."; exit 1; }
  cd "$EXTENSION_NAME"
else
  echo "⚠️ Directory '$EXTENSION_NAME' already exists. Cleaning and reusing..."
  rm -rf "$EXTENSION_NAME"/* "$EXTENSION_NAME"/.[!.]* # Clean it out
  cd "$EXTENSION_NAME"
fi

# Scaffold with npx (verbose for debugging)
echo "🛠️ Scaffolding extension with npx yo code..."
npx -y yo code --quick <<EOF
extension-typescript
$EXTENSION_NAME
$EXTENSION_ID
$EXTENSION_DESC
y
webpack
EOF

# Ensure key files exist
echo "🔍 Verifying scaffolded files..."
for file in package.json tsconfig.json src/extension.ts; do
  if [[ ! -f "$file" ]]; then
    echo "⚠️ $file missing after scaffolding. Creating it manually..."
    case "$file" in
      "package.json")
        cat > package.json <<EOF
{
  "name": "$EXTENSION_NAME",
  "displayName": "$EXTENSION_DISPLAY_NAME",
  "description": "$EXTENSION_DESC",
  "version": "$VERSION",
  "publisher": "$PUBLISHER",
  "engines": {"vscode": "^1.85.0"},
  "categories": ["SCM Providers"],
  "activationEvents": ["onCommand:$EXTENSION_NAME.push"],
  "main": "./out/extension.js",
  "contributes": {
    "commands": [
      {"command": "$EXTENSION_NAME.push", "title": "Vibe: Push Snapshot"},
      {"command": "$EXTENSION_NAME.pull", "title": "Vibe: Pull Snapshot"},
      {"command": "$EXTENSION_NAME.clean", "title": "Vibe: Clean Iterations"},
      {"command": "$EXTENSION_NAME.snapshot", "title": "Vibe: Manual Snapshot"},
      {"command": "$EXTENSION_NAME.init", "title": "Vibe: Initialize"}
    ],
    "menus": {
      "scm/sourceControl": [
        {"command": "$EXTENSION_NAME.push", "group": "navigation"},
        {"command": "$EXTENSION_NAME.pull", "group": "navigation"}
      ]
    }
  },
  "scripts": {
    "vscode:prepublish": "npm run compile",
    "compile": "tsc -p ./",
    "watch": "tsc -watch -p ./"
  },
  "devDependencies": {
    "@types/vscode": "^1.85.0",
    "@types/node": "^18.x",
    "typescript": "^5.2.2"
  }
}
EOF
        ;;
      "tsconfig.json")
        cat > tsconfig.json <<EOF
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es2020",
    "outDir": "out",
    "rootDir": "src",
    "sourceMap": true,
    "strict": true,
    "lib": ["es2020"]
  },
  "exclude": ["node_modules", ".vscode-test"]
}
EOF
        ;;
      "src/extension.ts")
        mkdir -p src
        cat > src/extension.ts <<'EOF'
import * as vscode from 'vscode';
import { execSync } from 'child_process';

export function activate(context: vscode.ExtensionContext) {
  let pushCommand = vscode.commands.registerCommand('vibe-flow.push', async () => {
    try {
      const iterBranch = 'iterations';
      const mainBranch = 'main';
      const currentBranch = execSync('git rev-parse --abbrev-ref HEAD', { encoding: 'utf8' }).trim();
      if (currentBranch !== iterBranch) {
        vscode.window.showErrorMessage(`❌ You must be on the '${iterBranch}' branch.`);
        return;
      }
      execSync('git diff-index --quiet HEAD --', { stdio: 'ignore' });
      const iterHash = execSync('git rev-parse --short HEAD', { encoding: 'utf8' }).trim();
      const userMsg = await vscode.window.showInputBox({ prompt: 'Commit message', value: `Snapshot from ${iterBranch}` });
      if (!userMsg) return;
      const commitMsg = `${iterHash} - ${userMsg}`;
      execSync(`git checkout ${mainBranch}`);
      execSync(`git checkout ${iterBranch} -- .`);
      execSync(`git commit -am "${commitMsg}"`);
      execSync(`git checkout ${iterBranch}`);
      vscode.window.showInformationMessage(`✅ Snapshot pushed to '${mainBranch}': ${commitMsg}`);
    } catch (error) {
      vscode.window.showErrorMessage(`❌ Push failed: ${error.message}`);
    }
  });

  let pullCommand = vscode.commands.registerCommand('vibe-flow.pull', () => {
    vscode.window.showInformationMessage('Vibe: Pull not implemented yet!');
  });

  let cleanCommand = vscode.commands.registerCommand('vibe-flow.clean', () => {
    vscode.window.showInformationMessage('Vibe: Clean not implemented yet!');
  });

  let snapshotCommand = vscode.commands.registerCommand('vibe-flow.snapshot', () => {
    vscode.window.showInformationMessage('Vibe: Snapshot not implemented yet!');
  });

  let initCommand = vscode.commands.registerCommand('vibe-flow.init', () => {
    vscode.window.showInformationMessage('Vibe: Init not implemented yet!');
  });

  context.subscriptions.push(pushCommand, pullCommand, cleanCommand, snapshotCommand, initCommand);
}

export function deactivate() {}
EOF
        ;;
    esac
  fi
done

# Install dependencies locally
echo "📦 Installing dependencies..."
npm install --loglevel=verbose

# Compile TypeScript
echo "🔨 Compiling extension..."
npm run compile

# Package the extension with npx vsce
echo "📦 Packaging extension as .vsix..."
npx -y vsce package

echo "✅ Vibe-Flow extension created!"
echo "📥 Install it in VS Code with: code --install-extension $EXTENSION_NAME-$VERSION.vsix"
echo "📥 For Windsurf, use 'Install from VSIX' in the Command Palette."
echo "✨ Edit src/extension.ts to add...
