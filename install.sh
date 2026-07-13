#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# symlink とパッケージは nix-darwin + home-manager が管理する
echo "==> Applying nix-darwin configuration..."
if command -v darwin-rebuild >/dev/null 2>&1; then
  sudo darwin-rebuild switch --flake "$DOTFILES_DIR#mac" --impure
else
  # 初回は darwin-rebuild が未インストールなので flake から直接実行する
  sudo nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake "$DOTFILES_DIR#mac" --impure
fi

echo "==> Installing VS Code extensions..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Generating AI config..."
"$DOTFILES_DIR/scripts/sync-ai-config.sh"

echo "==> Installing terminfo..."
tic -x -o ~/.terminfo "$DOTFILES_DIR/wezterm/wezterm.terminfo"

echo "==> Installing treesitter parsers..."
"$DOTFILES_DIR/nvim/scripts/install-parsers.sh"

echo "==> Done!"
