# AGENTS.md

このリポジトリは macOS の dotfiles で、Neovim・WezTerm・Zsh などの設定を管理しています。回答やコメントは基本的に日本語でお願いします。

## 主要ディレクトリ

- `nvim/`: Neovim 設定（Lua、Neovim 0.11+、lazy.nvim、LSP）
- `wezterm/`: WezTerm 設定
- `.claude/`: Claude 用設定とスキル
- `.agents/skills/`: Codex 用スキル（`.claude/skills/` を同期）

## 変更時のガイド

- 既存の構造と命名を尊重して最小限の変更にする
- VS Code Neovim 連携は `vim.g.vscode` 判定を壊さない
- プラグイン追加は `nvim/lua/plugins/` 配下にファイル追加
- LSP 追加は `nvim/lsp/` に設定ファイルを作成し、`nvim/lua/lsp_setup.lua` と `nvim/lua/plugins/lsp.lua`（`ensure_installed`）も更新
- キーマップは用途に応じて `nvim/lua/keymaps.lua` か `nvim/lua/lsp_setup.lua` を更新
- WezTerm のキーバインド変更は `wezterm/keys.lua` を更新

## よく使うコマンド

- `nvim`（プラグインは自動インストール）
- `:Lazy sync`（プラグイン更新）
- `:Mason`（LSP 管理）
- `brew bundle`（依存インストール）
- `asdf install`（ランタイム導入）

詳細な説明は `CLAUDE.md` を参照してください。
