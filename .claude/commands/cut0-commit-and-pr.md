# commit-and-pr

## 概要

変更内容をコミット → プッシュ →PR 作成する汎用的なワークフロー

## 前提条件

- git リポジトリで作業している
- GitHub CLI がインストールされている（`brew install gh`）
- 作業ブランチで開発している

## 実行手順

### 1. 変更内容の確認とユーザーへの質問

```bash
# 変更ファイルの一覧を確認
git status

# 変更内容の詳細を確認
git diff

# ステージング済みの変更を確認
git diff --staged
```

**ユーザーに確認する内容：**

- 「現在の変更をコミット・プッシュ・PR 作成しますか？」
- 変更内容の要約を提示
- コミットメッセージの提案

### 2. 変更のステージング

```bash
# すべての変更をステージング
git add -A

# または特定のファイル/ディレクトリのみ
git add <path>

# インタラクティブにステージング
git add -p
```

### 3. コミットの作成

```bash
# コミットメッセージのフォーマット
git commit -m "<type>: <簡潔な説明>"

# 詳細な説明が必要な場合
git commit -m "<type>: <簡潔な説明>" -m "<詳細な説明>"
```

#### コミットタイプ

- `feat`: 新機能
- `update`: 既存機能の更新
- `fix`: バグ修正
- `refactor`: リファクタリング
- `test`: テスト関連
- `docs`: ドキュメントのみ
- `chore`: その他のメンテナンス

### 4. プッシュ前の確認

```bash
# コミット履歴の確認
git log --oneline -5

# リモートとの差分確認
git log origin/$(git branch --show-current)..HEAD
```

### 5. リモートへのプッシュ

```bash
# 現在のブランチ名を取得
BRANCH=$(git branch --show-current)

# リモートにプッシュ
git push -u origin $BRANCH
```

### 6. PR 作成

```bash
# 基本的なPR作成（プロジェクトのテンプレートを使用）
gh pr create

# タイトルのみ指定（本文はプロジェクトのテンプレートを使用）
gh pr create --title "<コミットメッセージと同じタイトル>"

# ドラフトPRとして作成
gh pr create --draft
```

**注意**: PR 本文のテンプレートは各プロジェクトの `.github/pull_request_template.md` または `.github/PULL_REQUEST_TEMPLATE/` に定義されているものを使用します。

### 7. PR 作成後の確認

```bash
# 作成したPRを確認
gh pr view --web

# PRのステータス確認
gh pr status
```

## 注意事項

1. **変更前の確認**

   - 必ず`git diff`で変更内容を確認
   - 意図しない変更が含まれていないかチェック

2. **コミットメッセージ**

   - プロジェクトのコミットルールに従う
   - 変更の目的を明確に記載

3. **ブランチ戦略**

   - main ブランチへの直接プッシュは避ける
   - 機能ブランチから PR を作成

4. **レビュー**

   - PR を作成したらレビューを待つ
   - 必要に応じて修正を加える

5. **PR テンプレート**
   - 各プロジェクトの PR テンプレートを優先
   - `.github/pull_request_template.md`を確認
   - テンプレートがない場合のみ手動で本文を作成
