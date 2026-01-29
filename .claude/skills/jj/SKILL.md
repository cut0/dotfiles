---
name: jj
description: |
  Jujutsu (jj) バージョン管理システムの操作ガイドを提供します。
  Git と互換性を持ちながら、より柔軟なワークフローを実現します。
  jj コマンドの使用時に自動的にトリガーされます。
---

# Jujutsu (jj) ワークフロー

## Git との主な違い

| 特性 | Git | Jujutsu |
|------|-----|---------|
| ワーキングコピー | 独立した概念 | コミットとして扱う |
| ステージング (index) | あり | なし |
| ブランチ | 必須 | 任意（ブックマーク） |
| 競合発生時 | 操作失敗 | コミット可能 |
| 子孫のリベース | 手動 | 自動 |

## 基本概念

### ワーキングコピー (`@`)

- ワーキングコピーは実際のコミットとして扱われる
- `@` は現在のワーキングコピーコミットを指す
- ファイル変更は `jj st` 等のコマンド実行時に自動コミット

### チェンジ ID

- コミットハッシュとは別に、安定した識別子
- リベースでコミットが書き直されても変わらない
- `jj log` で確認可能

### ブックマーク

- Git のブランチに相当
- リビジョンへの名前付きポインタ
- リベース時に自動追従

## 基本コマンド

### リポジトリ操作

```bash
# Git リポジトリをクローン
jj git clone <URL>

# 既存 Git リポジトリを jj で初期化
jj git init --colocate

# リモートから最新を取得
jj git fetch
```

### 状態確認

```bash
# ステータス確認
jj st              # jj status の短縮形

# ログ表示
jj log             # 現在のブランチ履歴
jj log -r @        # カレントコミットのみ
jj log -r ::@      # ルートから現在まで

# 差分表示
jj diff            # ワーキングコピーの変更
jj diff -r @-      # 一つ前のコミットの差分
```

### コミット操作

```bash
# 現在の変更にメッセージを設定
jj describe -m "メッセージ"

# 新しいコミットを作成して移動
jj new             # 空のコミットを作成
jj new -m "メッセージ"

# 変更をコミットして新しいコミットに移動（Git の commit に近い）
jj commit -m "メッセージ"

# 現在の変更を親コミットに統合
jj squash

# コミットを分割
jj split
```

### 履歴操作

```bash
# リベース
jj rebase -d main           # main の上にリベース
jj rebase -r @ -d main      # 特定コミットをリベース

# 過去のコミットを編集
jj edit <revision>          # 指定コミットを編集状態に
jj diffedit -r @-           # チェックアウトせずに差分編集

# 操作の取り消し
jj undo                     # 直前の操作を取り消し
jj op log                   # 操作履歴を表示
```

### ブックマーク操作

```bash
# 一覧表示
jj bookmark list
jj b list                   # 短縮形

# 作成
jj bookmark create <name> -r @

# 移動
jj bookmark move <name> --to @

# 削除
jj bookmark delete <name>

# リモート追跡
jj bookmark track <name>@origin
jj bookmark untrack <name>@origin
```

## GitHub ワークフロー

### PR 作成（自動ブックマーク）

```bash
# main から新しいコミットを作成
jj new main

# 変更をコミット
jj commit -m "feat: add new feature"

# ブックマークを自動作成してプッシュ
jj git push -c @-
```

### PR 作成（名前付きブックマーク）

```bash
# ブックマークを作成
jj bookmark create my-feature -r @-

# プッシュ
jj git push --bookmark my-feature
```

### PR レビュー対応

**コミット追加方式:**

```bash
jj new my-feature
jj commit -m "address pr comments"
jj bookmark move my-feature --to @-
jj git push
```

**コミット修正方式:**

```bash
jj new my-feature-
jj squash
jj git push --bookmark my-feature
```

### リモート同期

```bash
# 最新を取得
jj git fetch

# main にリベース
jj rebase -d main@origin
```

## コミットルール

### フォーマット

```
<type>: <description>

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 許可されるタイプ

| タイプ | 説明 |
|--------|------|
| `feat` | 新機能 |
| `update` | 既存機能の更新 |
| `fix` | バグ修正 |
| `refactor` | リファクタリング |
| `test` | テスト関連 |
| `docs` | ドキュメントのみ |
| `chore` | その他のメンテナンス |

## 競合解決

jj では競合があってもコミット可能。後から解決できる。

```bash
# 競合の解決
jj resolve             # インタラクティブに解決
jj resolve --list      # 競合ファイル一覧

# 手動で解決した場合
# ファイルを編集後、自動的にコミットされる
```

## Git コマンド対応表

| Git | Jujutsu |
|-----|---------|
| `git status` | `jj st` |
| `git diff` | `jj diff` |
| `git add -p; git commit` | `jj split` |
| `git commit` | `jj commit` / `jj describe` + `jj new` |
| `git commit --amend` | `jj squash` / `jj describe` |
| `git rebase -i` | `jj squash` / `jj diffedit` |
| `git stash` | 不要（変更は自動コミット） |
| `git branch` | `jj bookmark` |
| `git checkout` | `jj new <rev>` / `jj edit <rev>` |
| `git log` | `jj log` |
| `git push` | `jj git push` |
| `git pull` | `jj git fetch` + `jj rebase` |

## 参考リンク

- [公式ドキュメント](https://docs.jj-vcs.dev/latest/)
- [GitHub リポジトリ](https://github.com/jj-vcs/jj)
