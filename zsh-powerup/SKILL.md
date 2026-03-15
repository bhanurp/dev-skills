---
name: zsh-powerup
description: >
  Set up a stunning, information-rich terminal using oh-my-zsh and Powerlevel10k theme.
  Use this skill when the user wants to: install oh-my-zsh, set up Powerlevel10k (p10k),
  configure a beautiful terminal prompt, make their terminal more aesthetic or informative,
  customize zsh with plugins and themes, get a developer-grade terminal setup, or improve
  their shell experience on macOS or Linux. Triggers on phrases like "aesthetic terminal",
  "pretty prompt", "oh-my-zsh setup", "powerlevel10k", "p10k", "terminal setup",
  "zsh theme", "make my terminal look good", "terminal that shows git/time/battery info".
  Always use this skill proactively even if they just say "set up my terminal" or
  "improve my shell" — don't attempt to improvise a zsh setup without this skill.
---

# ZSH Powerup: Oh-My-Zsh + Powerlevel10k

Sets up a beautiful, highly-informative terminal with oh-my-zsh and Powerlevel10k. The result: a prompt that shows git status, current directory, execution time, exit codes, virtualenvs, Node/Python versions, battery, time — all color-coded and icon-rich.

---

## Step 0: Detect Environment

Before writing any install commands, check:

```bash
echo $SHELL                   # Is zsh already the default shell?
zsh --version 2>/dev/null     # Is zsh installed?
cat /etc/os-release 2>/dev/null || sw_vers 2>/dev/null   # macOS or Linux?
ls ~/.oh-my-zsh 2>/dev/null && echo "OMZ already installed"
ls ~/.p10k.zsh 2>/dev/null && echo "P10K config exists"
```

Adapt all steps below based on what's already installed. Never re-install what exists.

---

## Step 1: Install Prerequisites

### Font (CRITICAL — do this first, before anything else)

Powerlevel10k requires a **Nerd Font** for icons and glyphs. Without it, the prompt looks broken.

**Recommended:** MesloLGS NF (the official p10k-recommended font)

**macOS (Homebrew):**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

**Linux (manual):**
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v
```

> **Tell the user:** After installing the font, they MUST set it in their terminal emulator preferences (iTerm2 → Profiles → Text → Font, or Terminal → Preferences → Profiles → Font). The font name is `MesloLGS NF`. This step cannot be automated and must be done manually before proceeding.

### Install zsh (Linux only, macOS already has it)
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y zsh curl git

# Fedora/RHEL
sudo dnf install -y zsh curl git

# Arch
sudo pacman -S zsh curl git
```

---

## Step 2: Install Oh-My-Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

If zsh is not the default shell yet:
```bash
chsh -s $(which zsh)
```

> Note: `--unattended` avoids the interactive prompt. The user will need to restart their terminal or run `zsh` after this.

---

## Step 3: Install Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Set the theme in `~/.zshrc`:
```bash
sed -i.bak 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
```

---

## Step 4: Install Essential Plugins

These plugins make the terminal dramatically more useful and aesthetic:

```bash
# 1. zsh-autosuggestions (fish-like suggestions in grey as you type)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 2. zsh-syntax-highlighting (colors valid commands green, invalid red)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 3. zsh-completions (extra tab-completions for many tools)
git clone https://github.com/zsh-users/zsh-completions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
```

---

## Step 5: Write the Full .zshrc

Use the **script** to write a comprehensive `.zshrc`. See `scripts/write_zshrc.sh`.

Key sections to include:
- `ZSH_THEME="powerlevel10k/powerlevel10k"`
- Plugins: `git z zsh-autosuggestions zsh-syntax-highlighting zsh-completions`
- `HIST_STAMPS`, `HISTSIZE`, `SAVEHIST` for better history
- `setopt` options: `AUTO_CD`, `CORRECT`, `HIST_IGNORE_DUPS`, `SHARE_HISTORY`
- Sourcing `~/.p10k.zsh` at the bottom

---

## Step 6: Write the Powerlevel10k Configuration (~/.p10k.zsh)

This is the **most important aesthetic step**. Write a pre-configured `~/.p10k.zsh` directly — this skips the interactive wizard and applies a curated aesthetic setup immediately.

Use the configuration from `references/p10k-config.md`.

Apply it:
```bash
# The script writes ~/.p10k.zsh — see scripts/write_p10k.sh
```

---

## Step 7: Apply Changes

```bash
source ~/.zshrc
```

Or tell the user to restart their terminal for all changes to take effect.

---

## Aesthetic Design Philosophy

The p10k config in this skill is designed around these principles:

| Goal | How |
|------|-----|
| **Instant context** | Left prompt: dir + git branch/status + virtualenv |
| **Right-side richness** | Right prompt: time, exit code, cmd duration, background jobs |
| **Language awareness** | Shows Node.js, Python, Go, Rust versions only when relevant files are present |
| **Git power** | Staged, unstaged, untracked counts; ahead/behind upstream arrows |
| **Color coding** | Green = clean/ok, Yellow = warnings/pending, Red = errors/dirty |
| **Performance** | Instant prompt mode enabled — no lag even with slow systems |
| **Two-line prompt** | Line 1: context/path; Line 2: cursor. Gives breathing room |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Boxes/question marks instead of icons | Font not set to MesloLGS NF in terminal preferences |
| Prompt looks plain | Run `p10k configure` to re-run the wizard |
| Changes not applied | Run `source ~/.zshrc` or restart terminal |
| `chsh` requires password | Enter your user password when prompted |
| iTerm2 not showing font | Preferences → Profiles → Text → Font → change to MesloLGS NF |
| `p10k configure` not found | Ensure `source ~/.p10k.zsh` is at end of `.zshrc` |

---

## Read Next

- `references/p10k-config.md` — Full curated `~/.p10k.zsh` with all aesthetic segments
- `scripts/write_zshrc.sh` — Script that writes the complete `.zshrc`
- `scripts/write_p10k.sh` — Script that writes `~/.p10k.zsh`
- `scripts/install.sh` — Full one-shot install script (calls all of the above)
