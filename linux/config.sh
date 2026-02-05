#!/bin/bash
set -euo pipefail

# ==========================================
# Configuration and Paths
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo ">>> Starting configuration setup..."
echo "    Root Config Dir: $ROOT_DIR"
echo "    Linux Settings Dir: $SCRIPT_DIR"

# ==========================================
# Copy Configurations
# ==========================================

backup_file() {
  if [ -f "$1" ]; then
    echo "Backing up $1 to $1.bak.$TIMESTAMP"
    cp "$1" "$1.bak.$TIMESTAMP"
  fi
}

echo ">>> Copying configuration files..."

# TTY Font
echo ">>> Configuring tty font..."
CONFIG_FILE="/etc/vconsole.conf"
FONT_NAME="ter-v16n"
if grep -q "^FONT=" "$CONFIG_FILE"; then
  sudo sed -i "s/^FONT=.*/FONT=$FONT_NAME/" "$CONFIG_FILE"
else
  sudo echo "FONT=$FONT_NAME" >> "$CONFIG_FILE"
fi

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

# Omnisharp
echo "Configuring Omnisharp..."
mkdir -p "$HOME/.omnisharp"
backup_file "$HOME/.omnisharp/omnisharp.json"
cp "$ROOT_DIR/common/omnisharp.json" "$HOME/.omnisharp/omnisharp.json"

# Starship
echo "Configuring Starship..."
mkdir -p "$HOME/.config"
backup_file "$HOME/.config/starship.toml"
if [ -f "$SCRIPT_DIR/starship.toml" ]; then
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

# Alacritty (optional for TTY systems, skip if not needed)
if command -v alacritty &> /dev/null; then
  echo "Configuring Alacritty..."
  mkdir -p "$HOME/.config/alacritty"
  backup_file "$HOME/.config/alacritty/alacritty.toml"
  if [ -f "$SCRIPT_DIR/alacritty.toml" ]; then
    cp "$SCRIPT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  fi
fi

# .zshrc
echo "Configuring .zshrc..."
backup_file "$HOME/.zshrc"
if [ -f "$SCRIPT_DIR/zsh.zshrc" ]; then
  cp "$SCRIPT_DIR/zsh.zshrc" "$HOME/.zshrc"
fi

echo ">>> Configuration Complete!"
echo "    Please restart your terminal or run 'source ~/.zshrc' to apply changes."
