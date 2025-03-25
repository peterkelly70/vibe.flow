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
