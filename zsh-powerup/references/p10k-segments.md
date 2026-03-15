# Powerlevel10k Segment Reference

This config shows the following information in your prompt. Here's exactly what each segment shows and when.

---

## Left Prompt (Line 1)

### 🖥 `os_icon`
- Shows  on macOS,  on Linux
- Always visible — identifies your system at a glance

### 👤 `context` (user@host)
- **Hidden by default** when you're your own user locally
- **Shown** when: SSH'd into a remote server, running as root, or different user
- Red when root, cyan when remote — immediately alerts you of risky contexts

### 📁 `dir`
- Shows your current directory path
- **Smart truncation**: long paths are shortened to unique prefixes (e.g., `~/p/m/src` instead of `~/projects/myapp/src`)
- Full final component always shown
- **Lock icon** if directory is not writable
- Color: blue

### 🌿 `vcs` (Git status)
All in one segment — color-coded:
- **Green** = clean working tree, nothing to commit
- **Yellow** = unstaged or untracked changes
- **Red** = merge conflicts

Shows:
| Symbol | Meaning |
|--------|---------|
| `⎇ main` | Branch name |
| `↑3` | 3 commits ahead of upstream |
| `↓2` | 2 commits behind upstream |
| `~1` | 1 modified file (unstaged) |
| `+2` | 2 staged files |
| `?1` | 1 untracked file |
| `⚑1` | 1 stash |

### 📦 `node_version` / `python_version` / `go_version` / `rust_version`
- **Only shown when in a relevant project directory** (has `package.json`, `.py`, `go.mod`, `Cargo.toml`)
- Prevents clutter — you only see language versions when they're relevant
- Helps avoid "which python am I using?" confusion

### 🐍 `virtualenv` / `conda_version`
- Shows active Python virtual environment name
- Shown whenever a venv or conda env is activated
- Prevents accidentally installing packages globally

---

## Left Prompt (Line 2)

### `prompt_char` (❯)
- **Green ❯** = last command succeeded (exit code 0)
- **Red ❯** = last command failed (exit code != 0)
- Instant visual feedback without cluttering line 1

---

## Right Prompt

### ✘ `status` (exit code)
- **Hidden when last command succeeded** — zero clutter on happy path
- **Shown in red with ✘** when command fails
- Shows the actual exit code number

### ⏱ `command_execution_time`
- **Hidden if command ran in < 3 seconds** (configurable via `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD`)
- Shown as: `took 1m 23s` for long commands
- Extremely useful for build scripts, tests, deployments

### ⚙ `background_jobs`
- Shows count of background jobs (`&` processes)
- Helps you remember what's running in the background

### 🕐 `time`
- Current time in `HH:MM:SS` format
- Useful for knowing when you ran a command without checking logs

### 🔋 `battery`
- Shows battery percentage with icon that changes at different levels
- **Red** when < 20%, **green** when charging/charged
- Hidden on desktop machines (only shown when battery exists)

---

## Kubernetes & AWS (context-sensitive)

### ☸ `kubecontext`
- Only shown when running `kubectl`, `helm`, `k9s`, etc.
- **Red** for prod contexts, **orange** for staging — prevents accidental prod deploys
- Matches context name patterns (configurable)

### ☁ `aws`
- Only shown when running `aws`, `terraform`, `cdk`, etc.
- **Red** for prod profiles, **orange** for staging
- Uses `AWS_PROFILE` environment variable

---

## Aesthetic Choices

| Choice | Reason |
|--------|--------|
| **Two-line prompt** | More breathing room; long paths don't crowd the cursor |
| **Transparent background** | Looks great on dark terminals (Dracula, Tokyo Night, Nord, etc.) |
| **Instant prompt** | Zero perceived lag — prompt appears before zsh fully loads |
| **Right-aligned info** | Time/duration don't interrupt left-side workflow context |
| **Show-only-when-relevant** | Language versions hidden unless you're in that project type |
| **Blank line before prompt** | Visual separation between command output and new prompt |

---

## Recommended Terminal Themes to Pair With

| Theme | Where to Get |
|-------|-------------|
| **Dracula** | dracula.theme.so |
| **Tokyo Night** | GitHub: enkia/tokyo-night-iterm2 |
| **Catppuccin** | github.com/catppuccin/iterm |
| **Nord** | nordtheme.com |
| **Gruvbox** | Available in most terminal apps |

All work beautifully with the MesloLGS NF font and this p10k config.

---

## Customizing Further

Run the interactive wizard anytime:
```bash
p10k configure
```

Edit config directly:
```bash
vim ~/.p10k.zsh
# Then reload:
source ~/.zshrc
```

Key variables to tweak:
- `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD` — change from 3s to whatever you prefer
- `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` — add/remove/reorder segments
- `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` — same for right side
- `POWERLEVEL9K_TIME_FORMAT` — change time format
