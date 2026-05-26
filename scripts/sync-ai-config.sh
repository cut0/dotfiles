#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
MODE="${1:-sync}"

if ! command -v rulesync >/dev/null 2>&1; then
  printf 'rulesync is not installed. Run: brew install rulesync\n' >&2
  exit 1
fi

case "$MODE" in
  sync)
    cd "$REPO_ROOT"
    rulesync generate --targets codexcli --features rules --output-roots .codex
    rulesync generate --targets claudecode --features rules --output-roots .claude
    rulesync generate --targets claudecode,codexcli,agentsskills --features skills
    ;;
  --check|check)
    cd "$REPO_ROOT"
    rulesync generate --check --targets codexcli --features rules --output-roots .codex
    rulesync generate --check --targets claudecode --features rules --output-roots .claude
    rulesync generate --check --targets claudecode,codexcli,agentsskills --features skills
    ;;
  *)
    printf 'usage: %s [sync|--check]\n' "$0" >&2
    exit 2
    ;;
esac
