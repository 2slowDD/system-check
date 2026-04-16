#!/usr/bin/env sh
set -eu

TARGET_DIR="$HOME/.codex/skills/system-check"

if [ -d "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  echo "Removed system-check skill from $TARGET_DIR"
else
  echo "system-check skill is not installed at $TARGET_DIR"
fi

echo "Cached manifests were not removed."
