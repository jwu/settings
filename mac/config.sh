#!/bin/bash
set -e

# ==========================================
# Configuration and Paths
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo ">>> Starting configuration setup..."
echo "    Root Config Dir: $ROOT_DIR"
echo "    Mac Settings Dir: $SCRIPT_DIR"

# ==========================================
# Copy Configurations
# ==========================================

backup_file() {
  if [ -f "$1" ]; then
    echo "Backing up $1 to $1.bak"
    cp "$1" "$1.bak"
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

# EZA
echo "Configuring EZA..."
mkdir -p "$HOME/.config/eza"

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

echo ">>> Configuration Complete!"
echo "    Please restart your terminal or run 'source ~/.zshrc' to apply changes."
