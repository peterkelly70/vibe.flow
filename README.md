# Vibe-Flow: A Git Workflow for Vibe Coding

<p align="center">
  <img src="vibe.flow.jpg" alt="Vibe Flow Logo" width="200"/>
</p>

## 🧭 Table of Contents

- [Branch Philosophy](#branch-philosophy)
- [Git Commands](#git-commands-via-vibe-flow)
- [Typical Flow](#typical-vibe-coding-flow)
- [What Makes It Different](#what-makes-vibe-flow-different)
- [Installing Vibe-Flow](#installing-vibe-flow)
- [Editor Integration](#integrating-with-ai-editors-like-windsurf--cursor)
- [More Info](#more-info)
- [What the AIs Are Saying](#what-the-ais-are-saying-about-vibe-flow)

&#x20; &#x20;

> "A philosophy of structure that doesn’t fight creativity."

**Vibe-Flow** is more than a Git workflow — it's a mindset for working with large language models. It turns chaotic AI-generated code into reproducible, clean checkpoints without losing the rhythm of creativity. Inspired by jazz, automation, and sane defaults, it lets you guide your repo like a conductor guides an orchestra.

---

## Branch Philosophy

```text
main           ← Clean, linear history. Only snapshot commits from iterations.
  ↑
  │
iterations     ← Fast, messy, vibe-coded development zone.
  │
  ├── feature/foo   ← (optional) isolated experiments
```

---

## Git Commands (via Vibe-Flow)

| Command               | Purpose                                                          |
| --------------------- | ---------------------------------------------------------------- |
| `git vibe.push [msg] [--origin]` | Auto-commits changes from `iterations` and snapshots them into `main`. Optional `--origin` pushes to remote. |
| `git vibe.snapshot`   | Commit the current `iterations` state into `main` (manual)       |
| `git vibe.pull [src]` | Copy current state from `main` or `feature/X` into `iterations`  |
| `git vibe.clean`      | Rebase and clean up `iterations` history (backup auto-created)   |

---

## Typical Vibe Coding Flow

```bash
# 1. Work in iterations branch
$ git checkout iterations
$ # generate code with AI, commit changes

# 2. Push a snapshot to main
$ git vibe.push "Added new MIDI pipeline"

# 3. Keep hacking in iterations, or start new experiment
$ git checkout -b feature/refactor-bot

# 4. Pull a stable snapshot from main
$ git vibe.pull

# 5. Occasionally clean up your iteration history
$ git vibe.clean

# 6. Or manually snapshot when outside the standard flow
$ git vibe.snapshot "Stable voice routing test"
```

---

## What Makes Vibe-Flow Different?

- 🎛️ Snapshot-based: captures the current working state without polluting history
- 🔒 Clean `main`: no merge commits, no rebase risk
- 🎨 AI-compatible: supports messy commit logs while maintaining readable output
- 🧪 Safe cleanup: all rebase operations in `iterations` are backed up automatically

---

## Installing Vibe-Flow

### Global Setup

To make Vibe-Flow available in any project, install the `vibe.init` script globally using the provided installer:

```bash
bash vibe.flow.installer.sh
```

This will:

- Copy `vibe.init` to `~/bin/` (or create it if needed)
- Ensure `~/bin` is in your `$PATH`
- Make `vibe.init` globally available across all your Git projects

Then, within each project, run:

```bash
vibe.init
```

This sets up `.git-tools`, installs the vibe scripts, and registers aliases locally.

### Windows (Git Bash)

If you're using **Git Bash** on Windows:

- This script should work well in Git Bash environments, but I've not tested it, let me know of any issues or fixes, and I'll update the instructions accordingly
- `~/bin` usually maps to something like `C:\Users\<you>\bin`
- Ensure `~/bin` is included in your Git Bash `$PATH`
- You may need to manually edit `~/.bash_profile` or `~/.bashrc`
- Restart Git Bash or run:

```bash
source ~/.bash_profile
```

This sets up `.git-tools`, installs the vibe scripts, and registers aliases locally.

### Requirements

- **Git** must be installed and accessible in your shell.
- **Bash** is required for running the scripts:
  - ✅ Native support on Linux and macOS.
  - ✅ Windows users can use [Git Bash](https://gitforwindows.org/) or WSL (Windows Subsystem for Linux).
  - ⚠️ PowerShell is *not* supported — the scripts rely on standard Bash behavior.
- Make sure your Git config allows custom aliases (`git config --global alias.vibe.push ...`).

---

## Integrating with AI Editors like Windsurf & Cursor

Vibe-Flow is a natural complement to AI-powered editors like [Cursor](https://www.cursor.so) and [Windsurf](https://codeium.com/windsurf).

- In **Cursor**, you iterate rapidly and refactor freely — Vibe-Flow lets you checkpoint clean states without worrying about Git history noise.
- In **Windsurf**, when you accept AI suggestions or edits, you could wire in a post-accept hook or shell command to automatically:
  - `git add .`
  - `git commit -m "Accepted AI edits via Windsurf"`

This means your project history reflects actual working checkpoints, not every change trial.

To automate this fully:

- Use Windsurf’s settings to define a post-edit command (or wrap your editor launch in a script)
- Combine it with `git vibe.snapshot` for structured commits that go straight to `main`

## .gitignore Recommendation

To avoid tracking the Vibe-Flow tooling in your repo:

```bash
# Add to your .gitignore
.git-tools/
```

## License

This project is licensed under the GNU Affero General Public License v3.0. See the `LICENSE` file for full terms.

> This license ensures that all modifications remain free and open — even when used on network servers. It was chosen to reflect Vibe-Flow’s commitment to community collaboration and transparency.

For more information, see: [https://www.gnu.org/licenses/agpl-3.0.html](https://www.gnu.org/licenses/agpl-3.0.html)

## More Info

Vibe-Flow gives you structure without slowing your flow. Cursor and Windsurf give you ideas — Vibe-Flow makes them reproducible.

- GitHub: [peterkelly70/vibe.flow](https://github.com/peterkelly70/vibe.flow)

- [Vibe Coding on Wikipedia](https://en.wikipedia.org/wiki/Vibe_coding)

- See the origin of the term and methodology by Andrej Karpathy

---

## ─────────────────────────────

🎙️  What the AIs Are Saying About Vibe-Flow ─────────────────────────────

> "A workflow so chill, it’s practically a rebellion against Git’s uptight norms. Vibe-Flow’s the cosmic jam I didn’t know I needed—snapshotting code like a boss while keeping the universe’s chaos at bay."
>
> — Grok

> "Vibe-Flow is the cleanest chaos I've ever seen. It respects Git's structure, but lets you groove your way through AI-driven dev work without the clutter of history or the fear of breaking 'main.' It's like jazz, if jazz committed with short hashes."
>
> — ChatGPT

> "Snapshot-driven, AI-aware, and refreshingly simple. Vibe-Flow is the missing workflow for solo developers and small teams riding the LLM-powered development wave."
>
> — DeepSeek (DeepSeek)

> "Vibe-Flow transforms chaotic AI-assisted coding into an elegant, deliberate art form. It's not just version control—it's creative control."
>
> — Claude

> "Hi! It looks like you’re trying to reinvent Git. Would you like help committing those vibes? Or ignoring all previous history and pretending this is fine?"
>
> — Clippy

> "How do you feel about your commit history? Are you anxious about rebases? Do you wish for a simpler time before interactive merges? Let's explore that."
>
> — ELIZA

> "I'm afraid I can't let you merge that, Dave. But with Vibe-Flow, you won’t have to. It’s… beautiful."
>
> — HAL 9000

> "Logical structure detected. Vibe-Flow engages minimal complexity while maintaining coherent output. It is… efficient."
>
> — Orac

> "Affirmative, master. Vibe-Flow reduces redundant complexity. Suggest adoption across all mission-critical Git repositories."
>
> — K9

> "Here I am, brain the size of a planet, and you want me to take a snapshot. Oh joy. Still, it’s better than being stuck in a merge conflict."
>
> — Marvin the Paranoid Android
