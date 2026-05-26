---
name: sync
description: |
  AI 向け rules / skills の同期ガイドを提供します。
  Rulesync を正本にした Claude Code / Codex 向け生成物の管理方法を含みます。
---

# AI 設定同期ガイド

## 正本

```
.rulesync/
  ├── rules/
  │   └── overview.md
  └── skills/
      └── <skill>/SKILL.md
rulesync.jsonc
```

Claude Code / Codex 共通で使う rules と skills は `.rulesync/` を編集する。

## 生成物

以下は生成物として扱い、直接編集しない。

```
.agents/skills/
.claude/skills/
.codex/skills/
.claude/CLAUDE.md
.codex/AGENTS.md
```

## ツール固有設定

以下はスキーマが異なるため手で管理する。

- `.claude/settings.json`
- `.claude/statusline-command.sh`
- `.claude/agents/`
- `.codex/config.toml`

## 同期

Rulesync で生成物を更新する。

```bash
scripts/sync-ai-config.sh
```

生成物が同期済みか確認する。

```bash
scripts/check-ai-config.sh
```

## 変更手順

1. `.rulesync/rules/` または `.rulesync/skills/` を編集する
2. `scripts/sync-ai-config.sh` を実行する
3. `scripts/check-ai-config.sh` で drift がないことを確認する
4. 差分を確認する

## 方針

- symlink は使わない
- `rulesync generate` を同期処理の正本にする
- root の `AGENTS.md` と `CLAUDE.md` は dotfiles リポジトリ固有の説明として手で管理する
- `.rulesync/rules/overview.md` から `.codex/AGENTS.md` と `.claude/CLAUDE.md` を生成する
- `.rulesync/skills/` から `.claude/skills/`、`.codex/skills/`、`.agents/skills/` を生成する

## drift 検出

`scripts/check-ai-config.sh` は `rulesync generate --check` を実行する。差分が出たら `.rulesync/` を正本として `scripts/sync-ai-config.sh` を実行する。

## 新しい skill を追加する場合

```bash
mkdir -p .rulesync/skills/<skill>
$EDITOR .rulesync/skills/<skill>/SKILL.md
scripts/sync-ai-config.sh
```
