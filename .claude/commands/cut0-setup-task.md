# setup-task

このコマンドは、git worktree を使用して独立した作業環境を構築し、作業完了後に PR を作成するまでの一連のワークフローを実行します。

## 必須パラメータ

```yaml
project_name: string # 対象プロジェクトの名前（リポジトリ名）
branch_name: string # 作成する作業ブランチ名
task_description: string # 実行する作業内容の詳細
```

## 実行ステップ

### 1. プロジェクトディレクトリへの移動

```bash
cd /path/to/{project_name}
```

### 2. Git Worktree の作成

```bash
# worktreeディレクトリのパス生成ルール:
# - ベースパス: ../claude-cache/{project_name}/{branch_name}
# - branch_name内の "/" は "-" に置換
git worktree add ../claude-cache/{project_name}/{branch_name} {branch_name}
```

### 3. Worktree ディレクトリへの移動

```bash
cd ../claude-cache/{project_name}/{branch_name}
```

### 4. 作業環境の確認と報告

- 現在のディレクトリパスを出力
- git status で作業ブランチを確認

### 5. プロジェクト依存関係のインストール

```bash
# package.jsonが存在する場合
npm install || yarn install || pnpm install

# requirements.txtが存在する場合
pip install -r requirements.txt

# go.modが存在する場合
go mod download

# Cargo.tomlが存在する場合
cargo build
```

### 6. 指定された作業の実行

- task_description に基づいて作業を実行
- テスト駆動開発（TDD）の原則に従う（CLAUDE.md の設定に基づく）

### 7. 変更内容のコミット

```bash
# 変更ファイルの確認
git status
git diff
```

**ユーザーに確認する内容：**

- 「これらの変更をコミットしますか？」
- 変更内容の要約を提示
- コミットメッセージの提案（`<type>: <description>`形式）

ユーザーが承認した場合：

```bash
# ステージングとコミット
git add .
git commit -m "<type>: <description>"
# <type>は CLAUDE.md のCOMMIT_RULESに従う: feat, update, fix, refactor, test, docs, chore
```

### 7.5. コミット後の処理の確認

**ユーザーに確認する内容：**

- 「コミットが完了しました。続けてプッシュと PR 作成を行いますか？」
- 以下のオプションを提示：
  - はい → プッシュと PR 作成を続行（ステップ 8 へ）
  - いいえ → コミットのみで終了
  - 後で → コミットのみで終了（後で手動でプッシュと PR 作成）

### 8. リモートへのプッシュ

```bash
git push -u origin {branch_name}
```

### 9. Pull Request の作成

```bash
# ghコマンドを使用してPRを作成
gh pr create \
  --title "<作業内容を簡潔に表すタイトル>" \
  --body "<プロジェクトのPRテンプレートに基づく本文>"
```

#### PR 作成時の注意事項

- **テンプレート準拠**: 各プロジェクトの`.github/pull_request_template.md`に従う
- **スクリーンショット**: テンプレートで要求されていても省略可能
- **タイトル規則**: 明確で検索しやすいタイトルを使用
- **本文内容**: 変更の目的、実装内容、テスト結果を含める

## エラーハンドリング

- 各ステップでエラーが発生した場合は、エラー内容を報告して処理を中断
- worktree が既に存在する場合は、既存の worktree を使用するか確認を求める
- プッシュ時に権限エラーが発生した場合は、リモート URL とアクセス権を確認

## 完了条件

- PR が正常に作成され、PR の URL が表示されること
- すべてのテストがパスしていること（プロジェクトにテストがある場合）
- リンターエラーがないこと
