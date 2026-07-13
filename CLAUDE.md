# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

このリポジトリは個人用の dotfiles で、macOS 環境での開発環境設定を管理しています。主に Neovim、WezTerm、Zsh の設定が含まれています。

## 主要ディレクトリ構造

### `nvim/` - Neovim エディタ設定

- **言語**: Lua
- **対応バージョン**: Neovim 0.11+
- **プラグインマネージャー**: lazy.nvim
- **LSP**: Native LSP (vim.lsp)
- **キーマッピング**:
  - リーダーキー: `<Space>`
  - `jj`: Insert → Normal mode
  - `<leader>e`: ファイルツリー
  - `<leader>ff`: ファイル検索
  - `Cmd+P`: ファイル検索 (WezTerm経由)

```
nvim/
├── init.lua              # エントリーポイント
├── lsp/                  # 各 LSP サーバーの設定
│   ├── ts_ls.lua         # TypeScript
│   ├── denols.lua        # Deno
│   ├── biome.lua         # Biome
│   ├── gopls.lua         # Go
│   ├── lua_ls.lua        # Lua
│   └── eslint.lua        # ESLint
└── lua/
    ├── options.lua       # 基本設定
    ├── keymaps.lua       # 全キーマップ
    ├── autocmds.lua      # 自動コマンド
    ├── commands.lua      # カスタムコマンド (Cut0*)
    ├── lsp_setup.lua     # LSP 設定
    └── plugins/          # プラグイン定義
```

### `wezterm/` - WezTerm ターミナル設定

- **テーマ**: Gruvbox Dark
- **透明度**: 0.9
- **Neovim 連携**: Cmd キーを Alt に変換して Neovim に送信

```
wezterm/
├── wezterm.lua           # メインエントリーポイント
├── keys.lua              # キーバインド (nvim連携 + 基本)
├── key_tables.lua        # コピーモード、検索モード
├── appearance.lua        # 見た目設定
└── keybinds_template.lua # デフォルトキー参照用
```

### `.rulesync/` - AI rules / skills の正本

Claude Code / Codex 向けの共通 rules と skills は Rulesync で管理します。

```
.rulesync/
├── rules/
│   └── overview.md       # .claude/CLAUDE.md と .codex/AGENTS.md の正本
└── skills/               # .claude/skills, .codex/skills, .agents/skills の正本
```

生成物:

- `.claude/CLAUDE.md`
- `.codex/AGENTS.md`
- `.claude/skills/`
- `.codex/skills/`
- `.agents/skills/`

## 開発コマンド

### Neovim 関連

```bash
# Neovim を起動（プラグインは自動インストール）
nvim

# プラグインの更新
:Lazy sync

# LSP サーバー管理
:Mason
```

### AI 設定関連

```bash
# Rulesync 生成物を更新
scripts/sync-ai-config.sh

# 生成物が同期済みか確認
scripts/check-ai-config.sh
```

### パッケージと symlink の管理（Nix）

パッケージと設定ファイルの symlink は nix-darwin + home-manager で管理している。

```bash
# 構成変更（パッケージ・symlink の追加等）を反映
sudo darwin-rebuild switch --flake ~/repos/space_private/dotfiles#mac --impure
```

- CLI ツールの追加: `home/default.nix` の `home.packages` に追記
- symlink の追加: `home/default.nix` の `home.file` / `xdg.configFile` に追記（mkOutOfStoreSymlink を使う）
- GUI アプリ・フォント: `darwin/default.nix` の `homebrew.casks` に追記
- 設定ファイルの内容編集だけなら rebuild 不要（out-of-store symlink のため即反映）
- ユーザー名・ホスト名はリポジトリに含めない方針。そのため `--impure`（ユーザー名を環境変数から取得）と attr 名 `#mac` の明示指定が必須
- 依存の更新は `nix flake update` → switch（flake.lock で SHA 固定）

## アーキテクチャと設計方針

### Neovim 設定の構造

1. **`init.lua`**: エントリーポイント、リーダーキー設定
2. **`lua/options.lua`**: 基本設定（タブ、インデント等）
3. **`lua/keymaps.lua`**: エディタキーマップ（Vim motions、ウィンドウ操作）
4. **`lua/lsp_setup.lua`**: LSP 設定（キーマップ、サーバー、診断）
5. **`lua/plugins/`**: プラグイン定義（lazy.nvim）
6. **`lsp/`**: 各言語サーバーの個別設定

### VS Code 統合

- VS Code Neovim 拡張使用時は最小限の設定のみ読み込み
- `vim.g.vscode` で VS Code 環境を検出

### キーマッピング設計

- **移動系**: `H`/`L`（行頭/行末）、`M`（対応括弧）
- **編集系**: 削除操作はレジスタを汚さない（`"_d`）
- **ウィンドウ操作**: `<leader>` プレフィックス
- **LSP 操作**: `<leader>` + `d`(定義), `r`(参照), `a`(アクション) 等
- **WezTerm 経由**: `Cmd+Enter`(定義), `Cmd+.`(コードアクション) 等

### WezTerm と Neovim の連携

WezTerm は Neovim 実行中を検出し、Cmd キーを Alt に変換して送信:
- `Cmd+P` → Neovim の `<M-p>` (ファイル検索)
- `Cmd+S` → Neovim の `<M-s>` (保存)
- `Cmd+.` → Neovim の `<M-.>` (コードアクション)

## 重要な設定ポイント

### タブとインデント

- タブ幅: 2 スペース
- 自動インデント有効
- スペースでタブを置換

### 自動フォーマット

- conform.nvim による保存時フォーマット
- JS/TS: biome → prettierd → prettier (順に試行)
- Go: gofmt, goimports

### Git 統合

- プロンプトにブランチ情報表示（`git-prompt.sh` 使用）
- 変更状態の視覚的表示

## 開発時の注意点

1. **Neovim 設定を変更する際**:
   - VS Code 統合を考慮（`vim.g.vscode` チェック）
   - lazy.nvim の遅延読み込みを活用

2. **新しいプラグインを追加する際**:
   - `lua/plugins/` にファイルを作成
   - 言語固有は `lua/plugins/lang/` に配置

3. **キーマッピングを追加する際**:
   - エディタ共通: `lua/keymaps.lua`
   - LSP 関連: `lua/lsp_setup.lua`
   - WezTerm 連携が必要な場合は `wezterm/keys.lua` も更新

4. **LSP サーバーを追加する際**:
   - `lsp/` に設定ファイルを作成
   - `lua/lsp_setup.lua` の `vim.lsp.enable()` に追加
   - `lua/plugins/lsp.lua` の `ensure_installed` に追加

5. **AI rules / skills を変更する際**:
   - `.rulesync/` 配下だけを編集
   - `scripts/sync-ai-config.sh` で生成物へ反映
   - `scripts/check-ai-config.sh` で drift がないことを確認
