#!/usr/bin/env sh
set -eu

TARGET_DIR="$HOME/.claude/skills/system-check"

if [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  echo "Removed system-check skill from $TARGET_DIR"
else
  echo "system-check skill is not installed at $TARGET_DIR"
fi

# Remove sc- trigger rule from CLAUDE.md
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

if [ -f "$CLAUDE_MD" ]; then
  if grep -qF "<!-- sc-trigger:start -->" "$CLAUDE_MD"; then
    awk '
      /<!-- sc-trigger:start -->/ { skip=1; next }
      /<!-- sc-trigger:end -->/   { skip=0; next }
      !skip                       { print }
    ' "$CLAUDE_MD" > "${CLAUDE_MD}.tmp" && mv "${CLAUDE_MD}.tmp" "$CLAUDE_MD"
    echo "Removed sc- trigger rule from $CLAUDE_MD"
  else
    echo "sc- trigger rule was not found in $CLAUDE_MD"
  fi
fi

echo "Cached manifests were not removed."
