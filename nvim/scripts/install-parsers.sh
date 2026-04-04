#!/usr/bin/env bash
set -euo pipefail

PARSER_DIR="${HOME}/.config/nvim/parser"
QUERY_DIR="${HOME}/.config/nvim/queries"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$PARSER_DIR" "$QUERY_DIR"

# ---------------------------------------------------------------------------
# 1. パーサーのビルド
# ---------------------------------------------------------------------------

build_parser() {
  local lang="$1" repo="$2" subdir="${3:-}"
  local repo_name
  repo_name="$(basename "$repo" .git)"
  local repo_dir="${WORK}/${repo_name}"

  if [[ ! -d "$repo_dir" ]]; then
    echo "  cloning: ${repo_name}"
    git clone --depth 1 -q "$repo" "$repo_dir"
  fi

  local build_path="$repo_dir"
  if [[ -n "$subdir" ]]; then
    build_path="${repo_dir}/${subdir}"
  fi

  echo "  building: ${lang}"
  tree-sitter build "$build_path" -o "${PARSER_DIR}/${lang}.so"
}

echo "=== パーサーのビルド ==="

build_parser javascript  https://github.com/tree-sitter/tree-sitter-javascript.git
build_parser typescript  https://github.com/tree-sitter/tree-sitter-typescript.git typescript
build_parser tsx         https://github.com/tree-sitter/tree-sitter-typescript.git tsx
build_parser go          https://github.com/tree-sitter/tree-sitter-go.git
build_parser rust        https://github.com/tree-sitter/tree-sitter-rust.git
build_parser python      https://github.com/tree-sitter/tree-sitter-python.git
build_parser json        https://github.com/tree-sitter/tree-sitter-json.git
build_parser yaml        https://github.com/tree-sitter-grammars/tree-sitter-yaml.git
build_parser toml        https://github.com/tree-sitter-grammars/tree-sitter-toml.git
build_parser html        https://github.com/tree-sitter/tree-sitter-html.git
build_parser css         https://github.com/tree-sitter/tree-sitter-css.git

echo ""

# ---------------------------------------------------------------------------
# 2. クエリファイルの取得 (nvim-treesitter から)
# ---------------------------------------------------------------------------

echo "=== クエリファイルの取得 ==="

nvim_ts_dir="${WORK}/nvim-treesitter"
git clone --depth 1 -b main -q https://github.com/nvim-treesitter/nvim-treesitter.git "$nvim_ts_dir"

for lang in ecma jsx html_tags \
            typescript tsx javascript go rust python json yaml toml html css; do
  src="${nvim_ts_dir}/runtime/queries/${lang}"
  if [[ -d "$src" ]]; then
    echo "  copying queries: ${lang}"
    rm -rf "${QUERY_DIR}/${lang}"
    cp -r "$src" "${QUERY_DIR}/${lang}"
  else
    echo "  skipped (not found): ${lang}"
  fi
done

echo ""
echo "=== 完了 ==="
echo "パーサー: ${PARSER_DIR}"
echo "クエリ:   ${QUERY_DIR}"
echo ""
echo "Neovim を再起動して :checkhealth vim.treesitter で確認してください"
