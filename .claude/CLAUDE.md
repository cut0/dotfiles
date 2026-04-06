# CLAUDE.md - AI Development Assistant Configuration

## 行動ルール

- ユーザーの入力が `？` や `?` で終わる疑問文の場合、質問への回答のみを行い、実装やコード変更を進めないこと
- git commit、push、branch、PR 作成など git にまつわる処理を行う前に、必ず `git-ops` スキルをロードすること

## スキル

以下のスキルをタスクに応じてロードすること

| スキル | 説明 |
|--------|------|
| `code-quality` | 全言語共通のコード品質ルールと制約事項 |
| `git-ops` | Git ワークフロー、コミットルール、PR 作成ガイドライン |
| `typescript` | JavaScript/TypeScript + React のコーディングルール |
| `python` | Python のコーディングルール |
| `go` | Go のコーディングルール |
| `rust` | Rust のコーディングルール |
| `writing` | 文章作成時のスタイルガイド |
| `docs` | AI によるドキュメント作成ガイド |
| `sync` | スキルや CLAUDE.md の同期ガイド |
