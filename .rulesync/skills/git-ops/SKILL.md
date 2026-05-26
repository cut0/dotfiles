---
name: git-ops
description: |
  Git リポジトリの一般的なワークフローを実行します。
  ブランチ戦略、コミットルール、PR作成のガイドラインを含みます。
  Git 操作やコミット・PR 作成時に自動的にトリガーされます。
---

# Git ワークフロー

## ブランチ戦略

- ベースブランチ: 指定がない場合は `main` を使用
- 最新から分岐: 常に最新のベースブランチから分岐

## ブランチ作成手順

```bash
git checkout main
git pull --rebase origin main
git checkout -b <branch-name>
```

## コミットルール

### フォーマット

```
<type>: <description>
```

- コミットメッセージ・PR タイトル・PR 本文の記述言語はプロジェクトの `CLAUDE.md` の指定に従う

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

## コミット・プッシュ・PR 作成前の確認事項

1. リント実行: lint がパスすることを確認
2. フォーマット実行: コードが整形されていることを確認
3. 型チェック実行: 型エラーがないことを確認（該当プロジェクトの場合）
4. テスト実行: 変更ファイルに関連するテストを実行
5. すべてのチェックがパス: 上記すべてが成功していることを確認

## PR 作成前の差分検証（必須）

PR を作成する前に、以下を必ず検証する。

### 1. ベースブランチとの差分確認

```bash
# ベースブランチを最新に更新
git fetch origin main

# ベースブランチとの差分を確認
git log --oneline origin/main..HEAD
git diff origin/main...HEAD --stat
```

- `origin/main..HEAD` のコミット一覧に、意図しないコミットが含まれていないことを確認する
- 差分のファイル一覧が、今回の変更として意図したものだけであることを確認する

### 2. マージ済み差分の混入チェック

```bash
# 現在のブランチがベースブランチの最新を取り込んでいるか確認
git merge-base --is-ancestor origin/main HEAD && echo "OK: main is ancestor" || echo "WARNING: main is not ancestor - rebase needed"
```

- ベースブランチにすでにマージ済みのコミットが PR 差分に含まれていないことを確認する
- 含まれている場合は、ベースブランチから `rebase` を実施してから PR を作成する

### 3. ワーキングツリーの未コミット変更

```bash
git status
git diff --stat
```

- 未コミットの変更がある場合、PR に含めるべきか、除外すべきかをユーザーに確認する
- ステージングされていない変更が意図せず PR に漏れることを防ぐ

## コミット → プッシュ → PR 作成ワークフロー

### 1. 変更内容の確認

```bash
git status
git diff
git diff --staged
```

- 変更内容の要約をユーザーに提示し、コミットメッセージを提案する
- すでにマージ済みのブランチで作業している場合は、新たにブランチを切る

### 2. ステージングとコミット

```bash
git add -A
git commit -m "<type>: <簡潔な説明>"
```

### 3. プッシュ

```bash
git push -u origin $(git branch --show-current)
```

### 4. PR 作成

```bash
# プロジェクトの PR テンプレートを使用
gh pr create --title "<コミットメッセージと同じタイトル>"

# ドラフトの場合
gh pr create --draft
```

- `.github/pull_request_template.md` がある場合はそのテンプレートを使用する
- テンプレートがない場合のみ手動で本文を作成

### 5. PR 作成後の CI 確認

```bash
# CI のステータスを確認（完了するまで待機）
gh pr checks --watch

# fail した場合は詳細を確認
gh run view <run-id> --log-failed
```

- PR 作成後、CI が success または fail になるまで必ず確認する
- fail した場合は原因を修正し、再度コミット・プッシュする
- すべての CI チェックが pass するまでこのサイクルを繰り返す
