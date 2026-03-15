#!/usr/bin/env bash
# ============================================================
# ZSH Powerup: Full Install Script
# Installs oh-my-zsh + Powerlevel10k + plugins + config
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

step() { echo -e "\n${CYAN}▶ $1${NC}"; }
ok()   { echo -e "${GREEN}✔ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }

# ── 1. Detect OS ──────────────────────────────────────────
step "Detecting environment..."
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
  PLATFORM="macos"
elif [[ -f /etc/os-release ]]; then
  . /etc/os-release
  PLATFORM="${ID:-linux}"
else
  PLATFORM="linux"
fi
ok "Platform: $PLATFORM"

# ── 2. Install zsh if needed ─────────────────────────────
if ! command -v zsh &>/dev/null; then
  step "Installing zsh..."
  case "$PLATFORM" in
    ubuntu|debian)  sudo apt update -q && sudo apt install -yq zsh curl git ;;
    fedora|rhel)    sudo dnf install -yq zsh curl git ;;
    arch)           sudo pacman -Sq --noconfirm zsh curl git ;;
    macos)          brew install zsh ;;
    *)              warn "Unknown distro. Install zsh manually." && exit 1 ;;
  esac
  ok "zsh installed"
else
  ok "zsh already installed: $(zsh --version)"
fi

# ── 3. Install fonts (macOS only automated) ──────────────
if [[ "$PLATFORM" == "macos" ]]; then
  step "Installing MesloLGS NF font (Homebrew)..."
  if brew list --cask font-meslo-lg-nerd-font &>/dev/null 2>&1; then
    ok "Font already installed"
  else
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font
    ok "MesloLGS NF installed"
  fi
elif [[ "$PLATFORM" != "macos" ]]; then
  step "Installing MesloLGS NF font (Linux)..."
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" \
            "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    DEST="$FONT_DIR/${f// /%20}"
    if [[ ! -f "$FONT_DIR/$f" ]]; then
      curl -fsSL "${BASE}/${f// /%20}" -o "$FONT_DIR/$f"
    fi
  done
  fc-cache -f -v &>/dev/null
  ok "MesloLGS NF fonts installed to $FONT_DIR"
fi

# ── 4. Install oh-my-zsh ─────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  step "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "oh-my-zsh installed"
else
  ok "oh-my-zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ── 5. Install Powerlevel10k ─────────────────────────────
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  step "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  ok "Powerlevel10k installed"
else
  ok "Powerlevel10k already installed"
fi

# ── 6. Install plugins ───────────────────────────────────
step "Installing zsh plugins..."

clone_if_missing() {
  local name="$1" url="$2" dest="$ZSH_CUSTOM/plugins/$1"
  if [[ ! -d "$dest" ]]; then
    git clone --depth=1 "$url" "$dest"
    ok "Plugin: $name"
  else
    ok "Plugin already present: $name"
  fi
}

clone_if_missing zsh-autosuggestions \
  https://github.com/zsh-users/zsh-autosuggestions

clone_if_missing zsh-syntax-highlighting \
  https://github.com/zsh-users/zsh-syntax-highlighting.git

clone_if_missing zsh-completions \
  https://github.com/zsh-users/zsh-completions

# ── 7. Write .zshrc ──────────────────────────────────────
step "Writing ~/.zshrc..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/write_zshrc.sh"
ok ".zshrc written"

# ── 8. Write .p10k.zsh ───────────────────────────────────
step "Writing ~/.p10k.zsh (aesthetic config)..."
bash "$SCRIPT_DIR/write_p10k.sh"
ok ".p10k.zsh written"

# ── 9. Set zsh as default shell ──────────────────────────
if [[ "$SHELL" != "$(which zsh)" ]]; then
  step "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
  ok "Default shell set to zsh (restart terminal to take effect)"
else
  ok "zsh is already the default shell"
fi

# ── Done ─────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✨ ZSH Powerup installed successfully!  ✨  ║${NC}"
echo -e "${GREEN}╠══════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║                                              ║${NC}"
echo -e "${GREEN}║  IMPORTANT: Set your terminal font to:       ║${NC}"
echo -e "${GREEN}║             MesloLGS NF                      ║${NC}"
echo -e "${GREEN}║                                              ║${NC}"
echo -e "${GREEN}║  Then restart your terminal to see the       ║${NC}"
echo -e "${GREEN}║  new prompt. Run 'p10k configure' anytime    ║${NC}"
echo -e "${GREEN}║  to re-customize with the interactive wizard.║${NC}"
echo -e "${GREEN}║                                              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
