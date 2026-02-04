#!/bin/bash
set -e

# ==========================================
# Configuration and Paths
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo ">>> Starting installation setup..."
echo "    Root Config Dir: $ROOT_DIR"
echo "    Mac Settings Dir: $SCRIPT_DIR"

# ==========================================
# Homebrew Packages
# ==========================================

if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is not installed. Please install it first."
  exit 1
fi

echo ">>> Installing/Updating packages via Homebrew..."
brew update

PACKAGES=(
  "starship"
  "zoxide"
  "neovim"
  "fzf"
  "lsd"
  "fd"
  "bat"
  "delta"
)

CASKS=(
  "wezterm-nightly"
  "alacritty"
  "neovide"
  "font-fira-mono-nerd-font"
)

echo "Installing packages: ${PACKAGES[*]}"
brew install "${PACKAGES[@]}"

echo "Installing casks: ${CASKS[*]}"
# ensure font cask is available (fonts are now in main cask repo, but just in case for older brew setups)
brew tap homebrew/cask-fonts 2>/dev/null || true
brew install --cask "${CASKS[@]}" || echo "Some casks might already be installed."

# ==========================================
# Oh My Zsh Setup
# ==========================================

echo ">>> Setting up Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh is already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ==========================================
# Plugins: zsh-autosuggestions
# ==========================================

echo ">>> Installing zsh-autosuggestions..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already exists, pulling latest..."
  cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull && cd - > /dev/null
fi

# ==========================================
# Theme: Dracula
# ==========================================

echo ">>> Installing Dracula Zsh Theme..."
OH_MY_ZSH="$HOME/.oh-my-zsh"
TEMP_DIR=$(mktemp -d)

if [ ! -f "$OH_MY_ZSH/themes/dracula.zsh-theme" ]; then
  curl -fsSL "https://github.com/dracula/zsh/archive/master.zip" -o "$TEMP_DIR/dracula.zip"
  unzip -q "$TEMP_DIR/dracula.zip" -d "$TEMP_DIR"
  cp "$TEMP_DIR/zsh-master/dracula.zsh-theme" "$OH_MY_ZSH/themes/dracula.zsh-theme"
  cp -r "$TEMP_DIR/zsh-master/lib" "$OH_MY_ZSH/themes/lib"
  rm -rf "$TEMP_DIR"
  echo "  Dracula Zsh Theme installed"
else
  echo "  Dracula Zsh Theme already installed"
fi

# ==========================================
# Copy Configurations (cp instead of ln)
# ==========================================

backup_file() {
  if [ -f "$1" ]; then
    echo "Backing up $1 to $1.bak.$TIMESTAMP"
    cp "$1" "$1.bak.$TIMESTAMP"
  fi
}

echo ">>> Copying configuration files..."

# WezTerm
echo "Configuring WezTerm..."
backup_file "$HOME/.wezterm.lua"
cp "$ROOT_DIR/common/wezterm.lua" "$HOME/.wezterm.lua"

# Alacritty
echo "Configuring Alacritty..."
mkdir -p "$HOME/.config/alacritty"
backup_file "$HOME/.config/alacritty/alacritty.toml"
cp "$SCRIPT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# LSD
echo "Configuring LSD..."
mkdir -p "$HOME/.config/lsd"
backup_file "$HOME/.config/lsd/config.yaml"
cp "$ROOT_DIR/common/lsd.yaml" "$HOME/.config/lsd/config.yaml"

# Neovim
echo "Configuring Neovim..."
mkdir -p "$HOME/.config/nvim"
backup_file "$HOME/.config/nvim/init.lua"
cp "$ROOT_DIR/common/neovim.init.lua" "$HOME/.config/nvim/init.lua"

# Neovide
echo "Configuring Neovide..."
mkdir -p "$HOME/.config/neovide"
backup_file "$HOME/.config/neovide/config.toml"
cp "$ROOT_DIR/common/neovide.config.toml" "$HOME/.config/neovide/config.toml"

# Omnisharp
echo "Configuring Omnisharp..."
mkdir -p "$HOME/.omnisharp"
backup_file "$HOME/.omnisharp/omnisharp.json"
cp "$ROOT_DIR/common/omnisharp.json" "$HOME/.omnisharp/omnisharp.json"

# Starship
echo "Configuring Starship..."
mkdir -p "$HOME/.config"
backup_file "$HOME/.config/starship.toml"
cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"

# .zshrc
echo "Configuring .zshrc..."
backup_file "$HOME/.zshrc"
cp "$SCRIPT_DIR/zsh.zshrc" "$HOME/.zshrc"

echo ">>> Installation Complete!"
echo "    A new .zshrc has been created."
echo "    Please restart your terminal or run 'source ~/.zshrc' to apply changes."
