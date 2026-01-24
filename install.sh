#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Creating symlinks..."

# Zsh
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

# Vim
ln -sf "$DOTFILES_DIR/.vimrc" ~/.vimrc

# Neovim
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

# WezTerm
ln -sf "$DOTFILES_DIR/wezterm" ~/.config/wezterm

# Git
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

# mise
ln -sf "$DOTFILES_DIR/.mise.toml" ~/.mise.toml

# EditorConfig
ln -sf "$DOTFILES_DIR/.editorconfig" ~/.editorconfig

# Starship
mkdir -p ~/.config
ln -sf "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml

echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Done!"
