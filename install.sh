#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link_path() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ ! -e "$source" ]; then
    echo "==> Skipping missing source: $source"
    return
  fi

  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      return
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    rm -rf "$target"
  fi

  ln -s "$source" "$target"
}

echo "==> Creating symlinks..."

# Zsh
link_path "$DOTFILES_DIR/.zshrc" ~/.zshrc

# Vim
link_path "$DOTFILES_DIR/.vimrc" ~/.vimrc

# Neovim
link_path "$DOTFILES_DIR/nvim" ~/.config/nvim

# WezTerm
link_path "$DOTFILES_DIR/wezterm" ~/.config/wezterm

# Tmux
link_path "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Generating AI config..."
"$DOTFILES_DIR/scripts/sync-ai-config.sh"

# Claude Code
link_path "$DOTFILES_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
link_path "$DOTFILES_DIR/.claude/settings.json" ~/.claude/settings.json
link_path "$DOTFILES_DIR/.claude/statusline-command.sh" ~/.claude/statusline-command.sh
link_path "$DOTFILES_DIR/.claude/skills" ~/.claude/skills
link_path "$DOTFILES_DIR/.claude/agents" ~/.claude/agents

# Codex
link_path "$DOTFILES_DIR/.codex/AGENTS.md" ~/.codex/AGENTS.md
link_path "$DOTFILES_DIR/.codex/config.toml" ~/.codex/config.toml
link_path "$DOTFILES_DIR/.codex/skills" ~/.codex/skills

# Agent Skills
link_path "$DOTFILES_DIR/.agents/skills" ~/.agents/skills

# Git
link_path "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

# mise
link_path "$DOTFILES_DIR/.mise.toml" ~/.mise.toml

# EditorConfig
link_path "$DOTFILES_DIR/.editorconfig" ~/.editorconfig

# Starship
link_path "$DOTFILES_DIR/starship.toml" ~/.config/starship.toml

echo "==> Installing terminfo..."
tic -x -o ~/.terminfo "$DOTFILES_DIR/wezterm/wezterm.terminfo"

echo "==> Installing treesitter parsers..."
"$DOTFILES_DIR/nvim/scripts/install-parsers.sh"

echo "==> Done!"
