---
name: rulesync
description: |
  Rulesync を使って Claude Code / Codex 向けの rules、skills、生成物を管理する際に使用します。
  .rulesync 配下の正本を編集し、rulesync generate / check で同期する手順を提供します。
---

# Rulesync 運用ガイド

## 正本

```
.rulesync/
  ├── rules/
  │   └── overview.md
  └── skills/
      └── <skill>/SKILL.md
rulesync.jsonc
```

## 生成物

以下は Rulesync の生成物として扱い、直接編集しない。

```
.claude/skills/
.codex/skills/
.agents/skills/
.claude/CLAUDE.md
.codex/AGENTS.md
```

## 基本コマンド

```bash
scripts/sync-ai-config.sh
scripts/check-ai-config.sh
```

直接 Rulesync を使う場合:

```bash
rulesync generate
rulesync generate --check
```

## 変更手順

1. rules を変更する場合は `.rulesync/rules/` を編集する
2. skills を変更する場合は `.rulesync/skills/` を編集する
3. `scripts/sync-ai-config.sh` を実行する
4. `scripts/check-ai-config.sh` を実行する
5. 差分を確認する

## 注意点

- root の `AGENTS.md` と `CLAUDE.md` は dotfiles リポジトリ固有の説明として手で管理する
- `.claude/CLAUDE.md`、`.codex/AGENTS.md`、`.claude/skills/`、`.codex/skills/`、`.agents/skills/` は生成物
- Claude Code / Codex 固有の runtime 設定は `.claude/settings.json` と `.codex/config.toml` で手管理する
