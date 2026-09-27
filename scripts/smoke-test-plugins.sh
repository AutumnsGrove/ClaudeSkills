#!/usr/bin/env bash
# Registration smoke test: adds a marketplace to a throwaway Claude Code config,
# installs every plugin it lists, and asserts each one registers exactly the
# skills the manifest declares. A plugin can install cleanly yet register zero
# components, so installing alone is not enough.
#
# Usage: ./scripts/smoke-test-plugins.sh [marketplace-dir]   (default: repo root)
# Requires: jq and the Claude Code CLI (override the binary with $CLAUDE).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MARKETPLACE_DIR="$(cd "${1:-$ROOT}" && pwd)"
CLAUDE="${CLAUDE:-claude}"
MANIFEST="$MARKETPLACE_DIR/.claude-plugin/marketplace.json"
MARKETPLACE_NAME="$(jq -r .name "$MANIFEST")"

CLAUDE_CONFIG_DIR="$(mktemp -d)"
export CLAUDE_CONFIG_DIR
export CLAUDE_CODE_PLUGIN_CACHE_DIR="$CLAUDE_CONFIG_DIR/cache"
trap 'rm -rf "$CLAUDE_CONFIG_DIR"' EXIT

# A bare path is parsed as owner/repo; an absolute path is always a directory.
$CLAUDE plugin marketplace add "$MARKETPLACE_DIR/"

errors=0
while read -r plugin; do
  expected="$(jq -r --arg p "$plugin" \
    '.plugins[] | select(.name == $p) | (.skills // [])[] | sub("/+$"; "") | split("/") | last' \
    "$MANIFEST" | sort | paste -sd, -)"

  $CLAUDE plugin install "$plugin@$MARKETPLACE_NAME" >/dev/null
  details="$($CLAUDE plugin details "$plugin")"
  actual="$(echo "$details" | sed -nE 's/^[[:space:]]*Skills \([0-9]+\)[[:space:]]+//p' \
    | tr -d ' ' | tr ',' '\n' | sort | paste -sd, -)"

  if [[ "$actual" == "$expected" ]]; then
    echo "OK   $plugin: $actual"
  else
    echo "FAIL $plugin: registered [$actual], manifest lists [$expected]" >&2
    errors=$((errors + 1))
  fi
done < <(jq -r '.plugins[].name' "$MANIFEST")

if (( errors > 0 )); then
  echo "Smoke test failed for $errors plugin(s)." >&2
  exit 1
fi
