# dotfiles

macOS 開発環境の設定ファイル

## セットアップ

```bash
# 1. Nix をインストール（Determinate Systems installer）
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# 2. クローンして反映
git clone git@github.com:cut0/dotfiles.git ~/repos/space_private/dotfiles
cd ~/repos/space_private/dotfiles
./install.sh
```

パッケージと symlink は nix-darwin + home-manager が管理する。設定変更後の反映は:

```bash
sudo darwin-rebuild switch --flake ~/repos/space_private/dotfiles#mac --impure
```

## 含まれる設定

| ファイル | 説明 |
|---------|------|
| `flake.nix` | Nix エントリーポイント（依存は flake.lock で固定） |
| `darwin/` | nix-darwin 設定（Homebrew cask の宣言管理を含む） |
| `home/` | home-manager 設定（CLI パッケージ・symlink 定義） |
| `.zshrc` | Zsh 設定 |
| `.vimrc` | Vim 設定 |
| `.gitconfig` | Git エイリアス・設定 |
| `.editorconfig` | エディタ共通設定 |
| `.mise.toml` | ランタイムバージョン管理 |
| `nvim/` | Neovim 設定 (lazy.nvim + Native LSP) |
| `wezterm/` | WezTerm ターミナル設定 |
| `starship.toml` | プロンプト設定 |
| `Brewfile` | VS Code 拡張の記録 |

## 主要ツール

- **パッケージ管理**: Nix (nix-darwin + home-manager)、GUI アプリとフォントのみ Homebrew cask
- **エディタ**: Neovim 0.12+
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
