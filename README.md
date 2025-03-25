# Vibe-Flow: A Git Workflow for Vibe Coding

[Vibe coding](https://en.wikipedia.org/wiki/Vibe_coding) is a lightweight, AI-assisted programming style where natural language prompts generate code, and the human guides, tests, and integrates it. Vibe-Flow is a Git methodology designed for solo developers and small teams practicing vibe coding.

This system gives you maximum flexibility while keeping your `main` branch clean and stable.

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

| Command               | Purpose                                                           |
|-----------------------|-------------------------------------------------------------------|
| `git vibe.push`       | Snapshot the current state of `iterations` into `main`            |
| `git vibe.snapshot`   | Like `vibe.push`, but fully manual and decoupled from flow logic  |
| `git vibe.pull [src]` | Copy current state from `main` or `feature/X` into `iterations`   |
| `git vibe.clean`      | Rebase and clean up `iterations` history (backup auto-created)    |

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

Run:
```bash
bash vibe-init.sh
```

This will:
- Create `.git-tools/`
- Install all scripts (`vibe.push`, `vibe.pull`, `vibe.clean`, `vibe.snapshot`)
- Add Git aliases

---

## Learn More
- [Vibe Coding on Wikipedia](https://en.wikipedia.org/wiki/Vibe_coding)
- See the origin of the term and methodology by Andrej Karpathy

---

Happy vibe coding 🎶

---

> "Version control, meet vibe control."

