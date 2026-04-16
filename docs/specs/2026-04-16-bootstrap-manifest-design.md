# Bootstrap Manifest Design

## Purpose

`system-check` should reduce manual setup for complex skills that do not yet have a `## System Check Requirements` manifest. When a manifest is missing, the skill should infer a draft manifest from available skill source material, show the draft to the user, ask where to save it, then rerun the check from the saved manifest.

This keeps the preflight workflow resource-efficient while avoiding silent edits to installed or third-party skill files.

## Default Flow

When the target complex skill has no inline or sidecar manifest:

1. Treat the missing manifest as a failed required item.
2. Inspect the local target skill `SKILL.md` if it is available.
3. If local source is unavailable or insufficient, ask the user for a local path or GitHub/source URL.
4. Search the available source for dependency signals.
5. Generate a draft `## System Check Requirements` manifest.
6. Show the draft manifest to the user.
7. Ask where to save it:
   - `1. Sidecar cache`
   - `2. Inline skill file`
   - `3. Do not save`
8. Save only after the user chooses a save target.
9. Rerun `system-check` from the saved manifest.

If the user chooses not to save, stop before executing the target complex skill unless the user explicitly approves proceeding without a manifest.

## Source Inspection

Local source inspection is preferred over remote inspection. Remote or GitHub source inspection requires user-provided or user-approved source.

The bootstrap pass should search for signals such as:

- `Requirements`
- `Dependencies`
- `MCP`
- `MCP integrations`
- `Extensions`
- `Tools`
- `Environment variables`
- `API keys`
- `Setup`
- `Install`
- `Prerequisites`
- `Subagents`
- `Scripts`
- `Project root`
- `Commands`
- `Auth`
- command snippets
- referenced helper script paths
- referenced skill names

## Inference Rules

The draft manifest should prefer conservative, auditable inference:

- Add `required command` when a command is clearly necessary to run the skill.
- Add `required path` when a script or file is directly required by the skill.
- Add `required project-root` when instructions name a fixed working root.
- Add `required skill` when the skill explicitly invokes another skill as part of its normal workflow.
- Add `optional mcp` when an MCP improves the workflow but the skill describes a fallback.
- Add `required mcp` only when the workflow cannot run without that MCP.
- Add `optional env` for optional integrations or API enhancements.
- Add `required env` only when the skill cannot run without that variable.
- Add `note` for conditional behavior, fallback rules, or skip instructions.

Do not infer secrets or write secret values. Environment entries must name variables only.

## Confidence Labels

The generated draft should include short confidence comments where useful:

```markdown
## System Check Requirements
- required command: python # high confidence: setup command uses python
- required path: D:\AI\SEO-AUDIT-ORIGINAL\scripts\check_deps.py # high confidence: required helper script
- optional env: FIRECRAWL_API_KEY # medium confidence: optional Firecrawl integration
- note: Google checks should be skipped when the GSC MCP is unavailable
```

Confidence comments are part of the review draft. They may be kept or removed before saving; the user decides.

## Save Targets

### Sidecar Cache

Save to:

```text
~/.codex/system-check/manifests/<skill-name>.md
```

Use this when the user wants non-invasive local memory.

### Inline Skill File

Add the manifest to the target skill's `SKILL.md`.

Use this only when the user explicitly chooses inline saving. This may modify installed or third-party skill files.

### Do Not Save

Do not write a manifest. Stop before executing the target complex skill unless the user explicitly approves proceeding without a manifest.

## Output Shape

When bootstrapping succeeds:

```text
System check: <skill-name>

[fail] required manifest: no System Check Requirements section or sidecar manifest found

This requirement failed - manifest missing.

Generated manifest draft from local skill source.
Review before saving:

<draft manifest>

Save where?
1. Sidecar cache
2. Inline skill file
3. Do not save
```

After saving:

```text
Manifest saved to <path>.
Rerunning system check from saved manifest.
```

Then print the normal system-check checklist.

## Safety Rules

- Never silently edit a skill file.
- Prefer sidecar cache for non-invasive saves.
- Ask before remote or GitHub source inspection.
- Do not print or infer secret values.
- Do not run expensive checks while generating the draft.
- Do not execute the target skill until the manifest is saved and passes, or the user explicitly approves proceeding.

## Success Criteria

- Missing manifests can be generated from local skill source without manual authoring.
- The user reviews the generated manifest before any save.
- The user chooses sidecar, inline, or no save.
- Saved manifests are immediately used by a rerun check.
- Future runs reuse saved manifests without repeating discovery.
- No remote source is inspected without user-provided or user-approved source.
