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
- 命名規則: `feature/{task-description}`

## ブランチ作成手順

```bash
git checkout main
git pull --rebase origin main
git checkout -b feature/{branch-name}
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

### Co-Author

- コミットには必ず Co-Authored-By を追加

## コミット・プッシュ・PR 作成前の確認事項

1. リント実行: lint がパスすることを確認
2. フォーマット実行: コードが整形されていることを確認
3. 型チェック実行: 型エラーがないことを確認（該当プロジェクトの場合）
4. テスト実行: 変更ファイルに関連するテストを実行
5. すべてのチェックがパス: 上記すべてが成功していることを確認
