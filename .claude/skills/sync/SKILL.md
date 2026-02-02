---
name: sync
description: |
  スキルや CLAUDE.md の同期ガイドを提供します。
  グローバルスキルとプロジェクトスキルの管理方法を含みます。
---

# スキル同期ガイド

## ディレクトリ構成

```
~/.claude/skills/           # グローバルスキル（全プロジェクト共通）
  ├── code-quality/
  ├── git-ops/
  ├── go/
  ├── jj/
  ├── python/
  ├── rust/
  ├── typescript/
  └── writing/

<project>/.claude/skills/   # プロジェクトスキル（プロジェクト固有）
  ├── cli/
  ├── docs/
  ├── jj/
  ├── sync/
  └── typescript/
```

## 同期方針

### グローバルからプロジェクトへ

汎用的なスキルはグローバルに置き、プロジェクトでカスタマイズが必要な場合のみコピー。

```bash
# グローバルスキルをプロジェクトにコピー
cp ~/.claude/skills/<skill>/SKILL.md .claude/skills/<skill>/SKILL.md
```

### プロジェクトからグローバルへ

プロジェクトで作成・改善したスキルを他プロジェクトでも使いたい場合。

```bash
# プロジェクトスキルをグローバルにコピー
cp .claude/skills/<skill>/SKILL.md ~/.claude/skills/<skill>/SKILL.md
```

## CLAUDE.md の管理

### 構成

```markdown
# CLAUDE.md

## スキル

プロジェクト固有のスキルへのリンクを記載。

- [スキル名](.claude/skills/<skill>/SKILL.md)

## コマンド

プロジェクトで使用するコマンドを記載。
```

### スキルリンクの追加

新しいスキルを追加したら CLAUDE.md にリンクを追加。

```markdown
## スキル

- [ライブラリ構成ガイド](.claude/skills/cli/SKILL.md)
- [Jujutsu ガイド](.claude/skills/jj/SKILL.md)  # 追加
```

## 同期コマンド

### 全スキルの差分確認

```bash
# グローバルとプロジェクトのスキルを比較
diff -r ~/.claude/skills .claude/skills 2>/dev/null | grep -v "Only in"
```

### 特定スキルの同期

```bash
# jj スキルをグローバルからプロジェクトへ同期
cp ~/.claude/skills/jj/SKILL.md .claude/skills/jj/SKILL.md

# typescript スキルをプロジェクトからグローバルへ同期
cp .claude/skills/typescript/SKILL.md ~/.claude/skills/typescript/SKILL.md
```

## 優先順位

Claude Code は以下の順序でスキルを読み込む:

1. プロジェクトスキル (`.claude/skills/`)
2. グローバルスキル (`~/.claude/skills/`)

同名のスキルがある場合、プロジェクトスキルが優先される。
