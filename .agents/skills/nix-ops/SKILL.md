---
name: nix-ops
description: |
  dotfiles の Nix (nix-darwin + home-manager) 運用ガイドを提供します。
  パッケージ追加、設定変更、反映、ロールバックの手順を含みます。
  パッケージのインストールや環境設定の変更時に自動的にトリガーされます。
---
# Nix 運用ガイド

## 原則

マシンを直接変えず、リポジトリを変えて反映する。`brew install` や `npm install -g` を直接実行しない
（homebrew.onActivation.cleanup = "zap" のため、宣言にないものは次回 switch で削除される）。

## 反映コマンド

```bash
sudo darwin-rebuild switch --flake ~/repos/space_private/dotfiles#mac --impure
```

- sudo が必要（AI エージェントは実行できないため、ユーザーに実行を依頼する）
- `--impure`: ユーザー名を環境変数（SUDO_USER / USER）から取得するために必須
- `#mac`: ホスト名やユーザー名をリポジトリに含めない方針のため、attr 名の明示指定が必須
- エイリアス `drs` が .zshrc に定義済み

## 変更の種類と手順

| 変更 | 手順 |
|------|------|
| CLI ツール追加 | `home/default.nix` の `home.packages` に追加 → switch |
| GUI アプリ追加 | `darwin/default.nix` の `homebrew.casks` に追加 → switch |
| App Store アプリ追加 | `mas search` で ID を調べ `homebrew.masApps` に追加 → switch |
| 設定ファイルの内容変更 | リポジトリ内のファイルを直接編集（即反映、switch 不要） |
| 設定ファイルを新規に管理 | リポジトリにコピー → `home/default.nix` に link 追加 → switch |
| macOS 設定変更 | `darwin/default.nix` の `system.defaults` を編集 → switch |
| ランタイム (node / go 等) | mise で管理（Nix の対象外） |

## パッケージの探し方

```bash
nix search nixpkgs <名前>   # CLI ツール（brew と名前が違うことがある。例: jj → jujutsu）
brew search <名前>          # GUI アプリの cask 名
mas search <名前>           # App Store アプリの ID
```

## 更新・ロールバック

```bash
nix flake update            # flake.lock を更新 → switch
brew upgrade                # cask アプリの更新
sudo darwin-rebuild --rollback  # 直前の世代に戻す
```

## 注意点

- 新しい設定ファイルを管理下に入れる前に、トークン等の秘密情報が含まれないことを確認する
  （例: gh は config.yml のみ管理し、hosts.yml は含めない）
- MDM (Jamf) 配布アプリ（Cisco / Falcon / FortiClient / WARP / Self Service+ / zoom）は宣言化しない
- nix コマンドが GitHub API のレート制限に当たる場合は
  `NIX_CONFIG="access-tokens = github.com=$(gh auth token)"` を付ける
- `system.defaults` の値は GUI で変更しても次回 switch で宣言値に戻る
