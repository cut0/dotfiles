# Neovim Configuration

Neovim 0.11+ 向けの設定ファイル。

## セットアップ

```bash
# シンボリックリンクを作成
ln -s /path/to/dotfiles/nvim ~/.config/nvim

# Neovim を起動（プラグインは自動インストール）
nvim

# LSP サーバーのインストール状況確認
:Mason
```

## ディレクトリ構造

```
nvim/
├── init.lua           # エントリーポイント（リーダーキー設定、モジュール読み込み）
├── lsp/               # 各 LSP サーバーの設定（Neovim 0.11 native LSP）
│   ├── ts_ls.lua      # TypeScript
│   ├── denols.lua     # Deno
│   ├── biome.lua      # Biome
│   ├── gopls.lua      # Go
│   ├── lua_ls.lua     # Lua
│   └── eslint.lua     # ESLint
└── lua/
    ├── options.lua      # 基本設定（タブ幅、行番号、etc.）
    ├── keymaps.lua      # 全キーマップ（Vim motions、ウィンドウ操作、etc.）
    ├── autocmds.lua     # 自動コマンド（yank ハイライト、カーソル復元、etc.）
    ├── commands.lua     # カスタムコマンド（Cut0* コマンド）
    ├── lsp_setup.lua    # LSP 設定（キーマップ、サーバー、診断表示）
    └── plugins/         # プラグイン定義
        └── ...
```

## プラグイン一覧

### コア

| プラグイン | 役割 |
|-----------|------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | プラグインマネージャー |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/フォーマッター/リンターのインストール管理 |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP クライアント設定 |

### エディタ機能

| プラグイン | 役割 |
|-----------|------|
| [blink.cmp](https://github.com/saghen/blink.cmp) | 補完エンジン |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | フォーマッター（保存時自動フォーマット） |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | リンター |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot |

### UI

| プラグイン | 役割 |
|-----------|------|
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | ファイルエクスプローラー |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー（ファイル検索、grep、コマンドパレット） |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | ターミナル |
| [gruvbox-material](https://github.com/sainnhe/gruvbox-material) | カラースキーム |

### 言語固有

| プラグイン | 役割 |
|-----------|------|
| [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) | Rust 開発（rust-analyzer 統合） |
| [flutter-tools.nvim](https://github.com/nvim-flutter/flutter-tools.nvim) | Flutter/Dart 開発 |

## フォーマッター自動選択

JS/TS ファイルは `stop_after_first = true` で順番に試行:

1. **biome** - `biome.json` が存在する場合のみ実行
2. **prettierd** - 高速版 prettier
3. **prettier** - フォールバック

確認: `:ConformInfo`

## トラブルシューティング

| コマンド | 用途 |
|---------|------|
| `:Lazy sync` | プラグイン同期 |
| `:Mason` | LSP サーバー管理 |
| `:LspInfo` | LSP 状態確認 |
| `:ConformInfo` | フォーマッター確認 |
| `:checkhealth` | 全体ヘルスチェック |
