# dotfiles

macOS 開発環境の設定ファイル

## セットアップ

```bash
git clone git@github.com:cut0/dotfiles.git ~/repos/space_private/dotfiles
cd ~/repos/space_private/dotfiles
./install.sh
```

## 含まれる設定

| ファイル | 説明 |
|---------|------|
| `.zshrc` | Zsh 設定 |
| `.vimrc` | Vim 設定 |
| `.gitconfig` | Git エイリアス・設定 |
| `.editorconfig` | エディタ共通設定 |
| `.mise.toml` | ランタイムバージョン管理 |
| `nvim/` | Neovim 設定 (lazy.nvim + Native LSP) |
| `wezterm/` | WezTerm ターミナル設定 |
| `starship.toml` | プロンプト設定 |
| `Brewfile` | Homebrew パッケージ |

## 主要ツール

- **エディタ**: Neovim 0.11+
- **ターミナル**: WezTerm
- **シェル**: Zsh + Starship
- **バージョン管理**: mise (node, deno, go)

## キーマップ

### Neovim

| キー | 動作 |
|-----|------|
| `<Space>` | リーダーキー |
| `jj` | Insert → Normal |
| `<leader>e` | ファイルツリー |
| `<leader>ff` | ファイル検索 |
| `H` / `L` | 行頭 / 行末 |

### WezTerm + Neovim 連携

| キー | 動作 |
|-----|------|
| `Cmd+P` | ファイル検索 |
| `Cmd+S` | 保存 |
| `Cmd+.` | コードアクション |
