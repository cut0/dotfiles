# GitHub Issue Task Command

**Command Name:** `github-issue-task`

**Purpose:** GitHub issue の内容を取得し、setup-task ワークフローを使用してタスクを自動実行する

## Parameters

### Required Parameters

- `issue_number`: GitHub issue 番号（例: "123"）
- `repo_owner`: リポジトリオーナー名（例: "octocat"）
- `repo_name`: リポジトリ名（例: "Hello-World"）

### Optional Parameters

- `base_branch_name`: ベースブランチ名（例: "main"、デフォルト: "カレントブランチ"）

## Execution Steps

### Step 1: GitHub Issue Retrieval

**Action:** GitHub MCP または gh コマンドを使用して issue の詳細を取得

```bash
gh issue view {issue_number} --repo {repo_owner}/{repo_name} --json title,body,labels,assignees
```

### Step 2: Issue Content Analysis

**Action:** 取得した issue から以下の情報を抽出

- タイトル
- 本文（要件や詳細な説明）
- ラベル（機能タイプやカテゴリ）

### Step 3: Task Description Auto-Generation

**Action:** Issue 内容から以下の形式でタスク説明を自動生成

```
## Issue #{issue_number}: {title}

### 要件
{issue_body}

### 実装方針
- TDD（テスト駆動開発）を適用
- CLAUDE.mdの開発ルールに従う
- 適切なエラーハンドリングを実装
- リンターとフォーマッターの要件を満たす

### 完了条件
- すべてのテストがパス
- リンターエラーなし
- フォーマッターエラーなし
- PRテンプレートに従った説明
```

### Step 4: Task Execution Workflow

**Parameters:**

- `project_name`: {repo_name}
- `task_description`: {自動生成されたタスク説明}

### Step 5: Detailed Workflow Implementation

#### 5.1 Project Directory Navigation

**Action:** プロジェクトディレクトリへの移動

```bash
cd ./{project_name}
```

#### 5.2 Git Worktree Creation (Mandatory)

**Important:** 本コマンドでは Git Worktree の使用が必須

**Actions:**

```bash
# ベースブランチに移動
git checkout {base_branch_name}

# 既存のworktreeを確認
git worktree list

# worktree作成
branch_name="{issue_number}-{sanitized_title}-{date}"
git worktree add ../claude-workspaces/{project_name}/{branch_name} -b {branch_name}
```

**Git Worktree Requirements Rationale:**

- 同時並行での複数 issue 作業を可能にする
- メインの作業ディレクトリを汚さない
- 安全な作業環境の分離を実現

#### 5.3 Worktree Directory Navigation

**Action:**

```bash
cd ../claude-workspaces/{project_name}/{branch_name}
```

#### 5.4 Work Environment Verification and Reporting

**Actions:**

- 現在のディレクトリパスを出力
- git status で作業ブランチを確認

#### 5.5 Project Dependencies Installation

**Actions:**

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

#### 5.6 Task Execution

**Actions:**

- task_description に基づいて作業を実行
- テスト駆動開発（TDD）の原則に従う（CLAUDE.md の設定に基づく）

#### 5.7 Changes Commit Process

**Pre-commit Actions:**

```bash
git status
git diff
```

**User Confirmation Required:**

- 「これらの変更をコミットしますか？」
- 変更内容の要約を提示
- コミットメッセージの提案（`<type>: <description>`形式）

**If User Approves:**

```bash
git add .
git commit -m "<type>: <description>"
# <type>: feat, update, fix, refactor, test, docs, chore (CLAUDE.md準拠)
# description: 端的な日本語
```

#### 5.8 Post-Commit Processing Confirmation

**User Confirmation Required:**

- 「コミットが完了しました。続けてプッシュと PR 作成を行いますか？」

**Options:**

- はい → プッシュと PR 作成を続行
- いいえ → コミットのみで終了
- 後で → コミットのみで終了（手動でプッシュと PR 作成）

#### 5.9 Remote Push

**Action:**

```bash
git push -u origin {branch_name}
```

#### 5.10 Pull Request Creation

**Action:**

```bash
gh pr create \
  --title "<作業内容を簡潔に表すタイトル>" \
  --body "<プロジェクトのPRテンプレートに基づく本文>"
```

**PR Creation Guidelines:**

- **Template Compliance:** `.github/pull_request_template.md`に準拠
- **Screenshots:** テンプレートで要求されていても省略可能
- **Title Rules:** 明確で検索しやすいタイトルを使用
- **Content:** 変更の目的、実装内容、テスト結果を含める

### Step 6: Notifications and Feedback

#### 6.1 Startup Notification

**Action:** CLAUDE.md 設定に基づく通知音

```bash
{QUESTION_SOUND_COMMAND}
```

#### 6.2 Completion Notification

**Action:** CLAUDE.md 設定に基づく完了音

```bash
{COMPLETION_SOUND_COMMAND}
```

#### 6.3 Progress Reporting

**Display Information at Each Step Completion:**

- 取得した issue 情報の要約
- 生成されたブランチ名
- 作業ディレクトリパス
- 実行中のタスクの進捗

## Error Handling

### GitHub API Related Errors

- **Authentication Error:** `gh auth status`で認証状態を確認
- **Issue Existence Error:** 指定された issue 番号の存在確認
- **Repository Access Error:** リポジトリの存在とアクセス権限の確認

### Workflow Execution Errors

- **General Error:** 各ステップでエラーが発生した場合は、エラー内容を報告して処理を中断
- **Existing Worktree:** worktree が既に存在する場合は、既存の worktree を使用（worktree 使用は必須のため）
- **Push Permission Error:** プッシュ時に権限エラーが発生した場合は、リモート URL とアクセス権を確認
- **Worktree Creation Failure:** worktree 作成に失敗した場合は、作業を中断（通常の git checkout は使用禁止）

## Completion Criteria

### Required Conditions

- Issue 内容が正常に取得できること
- PR が正常に作成され、PR の URL が表示されること
- 作成された PR に issue が適切にリンクされること
- すべてのテストがパスしていること（プロジェクトにテストがある場合）
- リンターエラーがないこと
