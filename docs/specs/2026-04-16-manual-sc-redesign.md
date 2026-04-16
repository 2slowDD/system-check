# Manual `sc-*` Redesign

## Purpose

`system-check` should be manually invoked, not automatically run before complex skills. Users should target checks with an `sc-<target skill>` phrase, such as `sc-SEO audit` or `sc-Brainstorming`.

The redesign makes `system-check` an explicit diagnostic command instead of an automatic preflight hook.

## Manual Invocation

The user invokes system-check with:

```text
sc-<target skill>
```

Examples:

```text
sc-SEO audit
sc-Brainstorming
sc-systematic-debugging
sc-github fix ci
```

Everything after `sc-` is treated as the target skill name. The skill should resolve the target against available installed skills using exact match, normalized match, and reasonable alias/fuzzy matching.

Normal target skill invocation must not trigger `system-check`.

## Target Resolution

Resolution order:

1. Exact skill name match
2. Case-insensitive normalized match
3. Space, hyphen, and underscore normalized match
4. Description/name fuzzy match when one target is clearly best
5. Ask the user to choose if multiple candidates are plausible

If no target can be found, ask for a local `SKILL.md` path or source URL.

## Manifest Behavior

When a target skill has a manifest:

1. Read inline `## System Check Requirements` first.
2. Read sidecar cache second.
3. Run the checklist.

When a target skill has no manifest:

1. Inspect local `SKILL.md` if available.
2. Generate a draft manifest from dependency signals.
3. Show the draft to the user.
4. Save to sidecar cache by default, but offer override choices:
   - `1. Save sidecar cache (default)`
   - `2. Save inline in skill file`
   - `3. Do not save`
5. Rerun the system check from the saved manifest.

If the user chooses not to save, stop unless the user explicitly approves proceeding without a manifest.

## Sidecar Default

The default save target is:

```text
~/.codex/system-check/manifests/<skill-name>.md
```

Inline skill edits require explicit user choice. The skill must never silently modify an installed skill file.

## Replace Automatic Hook

The old global behavior is removed:

```text
Run system-check before each complex skill...
```

Replacement instruction:

```markdown
## Manual System Check

Do not run `system-check` automatically before complex skills.

Run it only when the user explicitly invokes a manual check using `sc-<target skill>`, such as `sc-SEO audit` or `sc-Brainstorming`.
```

## Install, Uninstall, And Sync

The package should support install, uninstall, and sync for Codex and Claude.

### Codex

Windows:

```powershell
.\scripts\install.ps1
.\scripts\uninstall.ps1
.\scripts\sync.ps1
```

POSIX:

```sh
sh scripts/install.sh
sh scripts/uninstall.sh
sh scripts/sync.sh
```

### Claude

Windows:

```powershell
.\scripts\install-claude.ps1
.\scripts\uninstall-claude.ps1
.\scripts\sync-claude.ps1
```

POSIX:

```sh
sh scripts/install-claude.sh
sh scripts/uninstall-claude.sh
sh scripts/sync-claude.sh
```

Definitions:

- `install`: copy repo `skill/SKILL.md` to the local skill directory.
- `uninstall`: remove only the installed `system-check` skill file/directory.
- `sync`: copy current repo `skill/SKILL.md` over the installed local skill.

Uninstall must not delete sidecar manifests.

## Documentation Updates

README should include:

- manual `sc-*` usage
- examples
- note that normal skill invocation does not trigger system-check
- sidecar cache default with override choices
- install, uninstall, and sync for Codex
- install, uninstall, and sync for Claude
- note that uninstall preserves cached manifests

## Safety Rules

- Do not auto-run before complex skills.
- Do not silently edit target skill files.
- Use sidecar cache as the default save target.
- Ask before inline saves.
- Ask before remote/GitHub source inspection.
- Never print env var values.
- Never delete sidecar manifests during uninstall unless a separate explicit purge command exists.

## Success Criteria

- `sc-<target>` is documented as the only automatic trigger pattern.
- Normal skill invocation does not trigger system-check.
- Sidecar cache is the default save target for generated manifests.
- Inline save remains available as an explicit override.
- README documents install, uninstall, and sync for Codex and Claude.
- Scripts exist for install, uninstall, and sync across Windows and POSIX.
- The local AGENTS rule no longer instructs automatic checks before complex skills.
