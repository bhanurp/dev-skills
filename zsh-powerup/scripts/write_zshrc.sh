#!/usr/bin/env bash
# Writes a full-featured ~/.zshrc for oh-my-zsh + p10k

ZSHRC="$HOME/.zshrc"

# Back up existing .zshrc
if [[ -f "$ZSHRC" ]]; then
  cp "$ZSHRC" "${ZSHRC}.bak.$(date +%Y%m%d_%H%M%S)"
fi

cat > "$ZSHRC" << 'EOF'
# ─────────────────────────────────────────────────────────────
# Powerlevel10k Instant Prompt (must be at very top)
# ─────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────────────────────
# Oh-My-Zsh Configuration
# ─────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

# ─────────────────────────────────────────────────────────────
# Plugins
# ─────────────────────────────────────────────────────────────
plugins=(
  git                      # Git aliases (gst, gco, gp, gl, etc.)
  z                        # Jump to frecent directories: z myproject
  sudo                     # Press ESC twice to prepend sudo
  web-search               # google <query>, gh <query>
  copypath                 # Copy current path to clipboard
  copyfile                 # Copy file contents to clipboard
  dirhistory               # Alt+Left/Right to navigate dir history
  history                  # Better history commands
  colored-man-pages        # Colorized man pages
  command-not-found        # Suggests package when command not found
  zsh-autosuggestions      # Fish-like inline suggestions
  zsh-syntax-highlighting  # Real-time syntax coloring
  zsh-completions          # Extra tab completions
)

source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────────────────────────
# History Settings
# ─────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
HIST_STAMPS="yyyy-mm-dd"

setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Commands starting with space aren't saved
setopt HIST_VERIFY            # Show command before running from history expansion
setopt SHARE_HISTORY          # Share history across all zsh sessions
setopt INC_APPEND_HISTORY     # Write to history immediately

# ─────────────────────────────────────────────────────────────
# Shell Behavior
# ─────────────────────────────────────────────────────────────
setopt AUTO_CD                # Type directory name to cd into it
setopt CORRECT                # Suggest corrections for typos
setopt CORRECT_ALL            # Correct all arguments
setopt NO_CASE_GLOB           # Case-insensitive globbing
setopt EXTENDED_GLOB          # Extended globbing
setopt AUTO_PUSHD             # Push dirs onto stack automatically
setopt PUSHD_IGNORE_DUPS      # No duplicate dirs in stack

# ─────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ─────────────────────────────────────────────────────────────
# Key Bindings
# ─────────────────────────────────────────────────────────────
bindkey '^[[A' history-search-backward  # Up arrow: search history
bindkey '^[[B' history-search-forward   # Down arrow: search history
bindkey '^[^[[C' forward-word           # Alt+Right: forward word
bindkey '^[^[[D' backward-word          # Alt+Left: backward word

# ─────────────────────────────────────────────────────────────
# Autosuggestion Settings
# ─────────────────────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"          # Subtle grey suggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)      # Use history + completion
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ─────────────────────────────────────────────────────────────
# Syntax Highlighting
# ─────────────────────────────────────────────────────────────
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[command]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'

# ─────────────────────────────────────────────────────────────
# Useful Aliases
# ─────────────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Listing (use eza/exa if available, fall back to ls)
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons --git'
  alias lt='eza --tree --icons --level=2'
  alias la='eza -a --icons'
elif command -v exa &>/dev/null; then
  alias ls='exa --icons'
  alias ll='exa -lah --icons --git'
  alias lt='exa --tree --icons --level=2'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah'
  alias la='ls -la'
fi

# Git shortcuts
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'

# System
alias reload='source ~/.zshrc && echo "✔ .zshrc reloaded"'
alias zshconfig='${EDITOR:-vim} ~/.zshrc'
alias p10kconfig='${EDITOR:-vim} ~/.p10k.zsh'
alias paths='echo $PATH | tr ":" "\n"'
alias myip='curl -s ifconfig.me && echo'
alias disk='df -h | grep -v tmpfs'
alias mem='free -h'

# ─────────────────────────────────────────────────────────────
# Environment
# ─────────────────────────────────────────────────────────────
export EDITOR="${EDITOR:-vim}"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add local bin to PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ─────────────────────────────────────────────────────────────
# Powerlevel10k Config (must be at bottom)
# ─────────────────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "✔ ~/.zshrc written successfully"
