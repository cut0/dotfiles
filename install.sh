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

# Tmux
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# Claude Code
mkdir -p ~/.claude
ln -sf "$DOTFILES_DIR/.claude/statusline-command.sh" ~/.claude/statusline-command.sh

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

echo "==> Installing terminfo..."
tic -x -o ~/.terminfo "$DOTFILES_DIR/wezterm/wezterm.terminfo"

echo "==> Installing treesitter parsers..."
"$DOTFILES_DIR/nvim/scripts/install-parsers.sh"

echo "==> Done!"
