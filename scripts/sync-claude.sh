#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SOURCE="$REPO_ROOT/skill/SKILL.md"
TARGET_DIR="$HOME/.claude/skills/system-check"
TARGET="$TARGET_DIR/SKILL.md"

if [ ! -f "$SOURCE" ]; then
  echo "Source skill not found: $SOURCE" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE" "$TARGET"

echo "Synced system-check skill to $TARGET"

# Ensure sc- trigger rule is present in CLAUDE.md (idempotent)
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
START_MARKER="<!-- sc-trigger:start -->"

touch "$CLAUDE_MD"

if ! grep -qF "$START_MARKER" "$CLAUDE_MD"; then
  cat >> "$CLAUDE_MD" << 'SCEOF'

<!-- sc-trigger:start -->
## system-check Trigger (sc-)
When the user sends a message matching `sc-<target>` (e.g. `sc-seo`, `sc-brainstorm`):
- Invoke the `system-check` skill with `<target>` as the target skill
- Do NOT treat it as a skill name or slash command directly
- If sent as `sc-` alone, invoke `system-check` and list available targets
<!-- sc-trigger:end -->
SCEOF
  echo "Injected sc- trigger rule into $CLAUDE_MD"
else
  echo "sc- trigger rule already present in $CLAUDE_MD"
fi

echo "Restart Claude so the skill list refreshes."
