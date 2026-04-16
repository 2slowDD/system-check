#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SOURCE="$REPO_ROOT/skill/SKILL.md"
TARGET_DIR="$HOME/.codex/skills/system-check"
TARGET="$TARGET_DIR/SKILL.md"

if [ ! -f "$SOURCE" ]; then
  echo "Source skill not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE" "$TARGET"

echo "Installed system-check skill to $TARGET"
echo "Restart Codex so the skill list refreshes."
