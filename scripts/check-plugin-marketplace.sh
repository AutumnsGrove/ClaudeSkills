#!/usr/bin/env bash
# Structural check of the plugin marketplace manifest against the skill roster.
#
# Fails when:
#   - .claude-plugin/marketplace.json is missing, invalid JSON, or lacks name/owner/plugins
#   - .github/plugin/marketplace.json does not resolve to the same manifest
#   - two plugins share a name
#   - a plugin lists a skill path that is missing, has no SKILL.md, or whose
#     SKILL.md `name:` does not match its folder name
#   - a skill folder (any top-level dir with a SKILL.md) is listed in zero or
#     more than one plugin
#
# Requires: bash, jq. Run from anywhere: ./scripts/check-plugin-marketplace.sh
set -euo pipefail

cd "$(dirname "$0")/.."

MANIFEST=".claude-plugin/marketplace.json"
MIRROR=".github/plugin/marketplace.json"
errors=0

fail() {
  echo "ERROR: $*" >&2
  errors=$((errors + 1))
}

[[ -f "$MANIFEST" ]] || { echo "ERROR: $MANIFEST not found" >&2; exit 1; }
jq empty "$MANIFEST" 2>/dev/null || { echo "ERROR: $MANIFEST is not valid JSON" >&2; exit 1; }

for field in name owner plugins; do
  [[ "$(jq "has(\"$field\")" "$MANIFEST")" == "true" ]] || fail "$MANIFEST is missing \"$field\""
done

# VS Code and Copilot CLI read .github/plugin/marketplace.json; it must stay a
# symlink to (or an exact copy of) the Claude Code manifest.
if [[ ! -e "$MIRROR" ]]; then
  fail "$MIRROR is missing (expected a symlink to ../../$MANIFEST)"
elif ! cmp -s "$MANIFEST" "$MIRROR"; then
  fail "$MIRROR differs from $MANIFEST"
fi

dupes="$(jq -r '.plugins[].name' "$MANIFEST" | sort | uniq -d)"
[[ -z "$dupes" ]] || fail "duplicate plugin names: $(echo "$dupes" | tr '\n' ' ')"

# Every listed skill path must be a real skill whose frontmatter name matches.
listed="$(jq -r '.plugins[] | .source as $src | (.skills // [])[] | "\($src)|\(.)"' "$MANIFEST")"
declare -A seen=()
while IFS='|' read -r src skill; do
  [[ -n "$skill" ]] || continue
  path="${src%/}/${skill#./}"
  path="${path#./}"
  dir="$(basename "$path")"
  if [[ ! -f "$path/SKILL.md" ]]; then
    fail "listed skill $path has no SKILL.md"
    continue
  fi
  fm_name="$(awk '/^---$/{n++; next} n==1 && /^name:/{sub(/^name:[[:space:]]*/, ""); gsub(/["'\'']/, ""); print; exit}' "$path/SKILL.md")"
  [[ "$fm_name" == "$dir" ]] || fail "$path/SKILL.md has name \"$fm_name\", expected \"$dir\""
  seen[$path]=$(( ${seen[$path]:-0} + 1 ))
done <<< "$listed"

# Every skill folder in the repo must be registered exactly once.
for skill_md in */SKILL.md; do
  dir="${skill_md%/SKILL.md}"
  case "${seen[$dir]:-0}" in
    0) fail "skill $dir is not listed in any plugin in $MANIFEST" ;;
    1) ;;
    *) fail "skill $dir is listed in ${seen[$dir]} plugins (expected exactly 1)" ;;
  esac
done

if (( errors > 0 )); then
  echo "Plugin marketplace check failed with $errors error(s)." >&2
  exit 1
fi

echo "Plugin marketplace OK: $(jq '.plugins | length' "$MANIFEST") plugins, ${#seen[@]} skills."
