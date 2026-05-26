# AGENTS.md

このリポジトリは macOS の dotfiles で、Neovim・WezTerm・Zsh などの設定を管理しています。回答やコメントは基本的に日本語でお願いします。

## 主要ディレクトリ

- `nvim/`: Neovim 設定（Lua、Neovim 0.11+、lazy.nvim、LSP）
- `wezterm/`: WezTerm 設定
- `.rulesync/`: Claude Code / Codex 向け rules・skills の正本
- `.claude/`: Claude Code 用設定と Rulesync 生成物
- `.codex/`: Codex 用設定と Rulesync 生成物
- `.agents/skills/`: Agent Skills 互換の Rulesync 生成物

## 変更時のガイド

- 既存の構造と命名を尊重して最小限の変更にする
- VS Code Neovim 連携は `vim.g.vscode` 判定を壊さない
- プラグイン追加は `nvim/lua/plugins/` 配下にファイル追加
- LSP 追加は `nvim/lsp/` に設定ファイルを作成し、`nvim/lua/lsp_setup.lua` と `nvim/lua/plugins/lsp.lua`（`ensure_installed`）も更新
- キーマップは用途に応じて `nvim/lua/keymaps.lua` か `nvim/lua/lsp_setup.lua` を更新
- WezTerm のキーバインド変更は `wezterm/keys.lua` を更新
- AI rules / skills は `.rulesync/` を編集し、`scripts/sync-ai-config.sh` で生成物へ反映

## よく使うコマンド

- `nvim`（プラグインは自動インストール）
- `:Lazy sync`（プラグイン更新）
- `:Mason`（LSP 管理）
- `brew bundle`（依存インストール）
- `asdf install`（ランタイム導入）
- `scripts/sync-ai-config.sh`（Rulesync 生成物を更新）
- `scripts/check-ai-config.sh`（Rulesync 生成物の drift 検出）

詳細な説明は `CLAUDE.md` を参照してください。
